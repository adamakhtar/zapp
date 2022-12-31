defmodule ZappWeb.IssueEditorLive.TextSectionComponent do
  use ZappWeb, :live_component

  alias Phoenix.LiveView.JS

  alias Zapp.Newsletters
  alias Zapp.Newsletters.TextSection


  @impl true
  def render(assigns) do
    ~H"""
      <div id={@id} class="rounded-lg border border-white hover:border-gray-300 hover:shadow-sm py-3 px-4">
        <div class="js-title cursor-pointer" phx-click={ toggle_form(@id) }>
          <%= raw(@text_section.body) %>
        </div>

        <div id={ "{#@id}-form"}  class="js-form hidden cursor-text" phx-update="ignore">
          <.form
            let={f}
            id={ "#{@id}-form" }
            for={@changeset}
            phx-target={@myself}
            phx-submit={on_submit(@id, @myself)}
            >
            <%= textarea f, :body, hidden: true, id: "#{@id}-trix" %>
            <trix-editor input={ "#{@id}-trix" }></trix-editor>

            <%# dont need save button as phx-click-away will trigger a sumbmit event %>
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