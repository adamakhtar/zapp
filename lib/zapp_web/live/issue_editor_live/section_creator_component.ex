defmodule ZappWeb.IssueEditorLive.SectionCreatorComponent do
  use ZappWeb, :live_component

  alias Zapp.Newsletters

  @impl true
  def render(assigns) do
    ~H"""
      <div x-data="{ open: false }" class="h-4 my-4">
        <a href="#"
           class="border border-gray-400 text-gray-600 rounded-full px-1 py-1"
           x-show="!open"
           x-on:click="open = true">+</a>

        <div x-show="open" x-on:click.outside="open = false" class="flex flex-row justify-center">
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="create_heading_section" phx-target={@myself}>+ Heading</a>
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="create_text_section" phx-target={@myself}>+ Text</a>
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="" phx-target={@myself}>+ Tweet</a>
        </div>
      </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
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
