defmodule ZappWeb.IssueEditorLive.HeadingSectionComponent do
  use ZappWeb, :live_component

  alias Phoenix.LiveView.JS

  alias Zapp.Newsletters
  alias Zapp.Newsletters.TextSection


  @impl true
  def render(assigns) do
    ~H"""
      <div id={@id} phx-hook="HeadingSection">
        <div class="js-output" phx-click={ reveal_form(@id) } >
          <h2 class="js-heading text-2xl font-semibold leading-tight"><%= @heading_section.title %></h2>
        </div>


        <.form
          let={f}
          id={ "#{@id}-form" }
          for={@changeset}
          phx-target={@myself}
          phx-submit={on_submit(@id, @myself)}
          class="hidden js-form"
          >
          <%= textarea(
            f,
            :title,
            autofocus: true,
            height: 'auto',
            class: "focus:ring-0  w-full text-2xl font-semibold leading-tight px-0 py-0"
            ) %>

          <% # No submit button required. User can just press enter %>
        </.form>
      </div>
    """
  end

  @impl true
  def update(%{heading_section: heading_section} = assigns, socket) do
    changeset = Newsletters.change_heading_section(
      heading_section,
      %{title: heading_section.title}
    )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
    }
  end

  def reveal_form(id) do
    JS.dispatch("heading_section:reveal_form", to: "##{id}")
  end

  # def toggle_form(id) do
  #   JS.toggle(to: "##{id} .js-output")
  #   |> JS.toggle(to: "##{id} .js-form")
  #   |> JS.dispatch("textarea:resize_to_fit", to: "##{id} .js-form textarea")
  # end

  def on_keyup() do
    # JS.dispatch("textarea:resize_to_fit")
    # |> JS.dispatch("textarea:enter_to_submit")
  end

  def on_submit(id, myself) do
    IO.inspect("SUBMIT!!!!")
    JS.dispatch("heading_section:hide_form", to: "##{id}")
    JS.push("save", target: myself)
  end

  @impl true
  def handle_event("save", %{"heading_section" => heading_section_params}, socket) do
    IO.inspect(heading_section_params)
    # TODO use case statement and handle errors
    {:ok, heading_section} =
        socket.assigns.heading_section
        |> Newsletters.update_heading_section(heading_section_params)

    send self(), {:heading_section_updated, heading_section}

    {:noreply, socket}
  end
end