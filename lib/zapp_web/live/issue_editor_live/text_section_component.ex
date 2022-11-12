defmodule ZappWeb.IssueEditorLive.TextSectionComponent do
  use ZappWeb, :live_component

  alias Phoenix.LiveView.JS

  alias Zapp.Newsletters
  alias Zapp.Newsletters.TextSection


  @impl true
  def render(assigns) do
    ~H"""
      <div id={@id}>
        <div class="js-title" phx-click={toggle_form(@id)}>
          <%= @text_section.body %>
        </div>

        <div phx-click-away={toggle_form(@id) } class="hidden js-form">
          <.form
            let={f}
            id={ "#{@id}-form" }
            for={@changeset}
            phx-target={@myself}
            phx-submit={on_submit(@id, @myself)}>
            <%= textarea f, :body %>

            <%= submit "Save" %>
          </.form>
        </div>
      </div>
    """
  end

  @impl true
  def update(%{text_section: text_section} = assigns, socket) do
    changeset = Newsletters.change_text_section(
      text_section,
      %{body: text_section.body}
    )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
    }
  end

  def toggle_form(id) do
    JS.toggle(to: "##{id} .js-title")
    |> JS.toggle(to: "##{id} .js-form")
  end

  def on_submit(id, myself) do
    toggle_form(id)
    |> JS.push("save", target: myself)
  end

  @impl true
  def handle_event("save", %{"text_section" => text_section_params}, socket) do
    # TODO use case statement and handle errors
    {:ok, text_section} =
        socket.assigns.text_section
        |> Newsletters.update_text_section(text_section_params)

    send self(), {:text_section_updated, text_section}
    {:noreply, socket}
  end
end