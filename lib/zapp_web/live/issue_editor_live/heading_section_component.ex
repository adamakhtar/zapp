defmodule ZappWeb.IssueEditorLive.HeadingSectionComponent do
  use ZappWeb, :live_component

  alias Phoenix.LiveView.JS

  alias Zapp.Newsletters
  alias Zapp.Newsletters.TextSection


  @impl true
  def render(assigns) do
    ~H"""
      <div id={@id}>
        <div class="js-output" phx-click={toggle_form(@id)}>
          <h3 class="text-lg mb-4"><%= @heading_section.title %></h3>
        </div>

        <div phx-click-away={toggle_form(@id) } class="hidden js-form">
          <.form
            let={f}
            id={ "#{@id}-form" }
            for={@changeset}
            phx-target={@myself}
            phx-submit={on_submit(@id, @myself)}>
            <%= text_input f, :title %>

            <% # No submit button required. User can just press enter %>
          </.form>
        </div>
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

  def toggle_form(id) do
    JS.toggle(to: "##{id} .js-output")
    |> JS.toggle(to: "##{id} .js-form")
  end

  def on_submit(id, myself) do
    toggle_form(id)
    |> JS.push("save", target: myself)
  end

  @impl true
  def handle_event("save", %{"heading_section" => heading_section_params}, socket) do
    # TODO use case statement and handle errors
    {:ok, heading_section} =
        socket.assigns.heading_section
        |> Newsletters.update_heading_section(heading_section_params)

    send self(), {:heading_section_updated, heading_section}
    {:noreply, socket}
  end
end