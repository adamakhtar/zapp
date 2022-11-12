defmodule ZappWeb.IssueEditorLive.SectionCreatorComponent do
  use ZappWeb, :live_component

  alias Phoenix.LiveView.JS

  alias Zapp.Newsletters

  @impl true
  def render(assigns) do
    ~H"""
      <div id={@id}
           class="h-4 my-4">
        <a href="#"
            phx-click={ show_menu(assigns) } }
           class="border border-gray-400 text-gray-600 rounded-full px-1 py-1">+</a>

        <div phx-click-away={ hide_menu(assigns) }
             class="js-menu flex flex-row justify-center hidden">
          <a href="#"
             class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1"
             phx-click={ click_create_section(assigns, "create_heading_section") }
             >+ Heading</a>
          <a href="#"
             class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1"
             phx-click={ click_create_section(assigns, "create_text_section") }
             >+ Text</a>
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="" phx-target={@myself}>+ Tweet</a>
        </div>
      </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  def show_menu(assigns) do
    JS.show(to: "##{assigns.id} .js-menu")
  end

  def hide_menu(assigns) do
    JS.hide(to: "##{assigns.id} .js-menu")
  end

  def click_create_section(assigns, "create_heading_section") do
    JS.push("create_heading_section", target: assigns.myself)
    |> JS.hide(to: "##{assigns.id} .js-menu")
  end

  def click_create_section(assigns, "create_text_section") do
    JS.push("create_text_section", target: assigns.myself)
    |> JS.hide(to: "##{assigns.id} .js-menu")
  end

  @impl true
  def handle_event("create_heading_section", _params, socket) do
    {:ok, heading_section} = Newsletters.create_heading_section(
      socket.assigns.issue,
      socket.assigns.insert_position,
      %{title: "A new heading"}
    )

    send self(), {:section_added, heading_section}
    {:noreply, socket}
  end

  @impl true
  def handle_event("create_text_section", _params, socket) do
    {:ok, text_section} = Newsletters.create_text_section(
      socket.assigns.issue,
      socket.assigns.insert_position,
      %{body: "Some text"}
    )

    send self(), {:section_added, text_section}
    {:noreply, socket}
  end
end
