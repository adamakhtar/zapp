defmodule ZappWeb.IssueEditorLive.SectionCreatorComponent do
  use ZappWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <div x-data="{ open: false }" class="h-4 my-4">
        <a href="#"
           class="border border-gray-400 text-gray-600 rounded-full px-1 py-1"
           x-show="!open"
           x-on:click="open = true">+</a>

        <div x-show="open" x-on:click.outside="open = false" class="flex flex-row justify-center">
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="" phx-target={@myself}>+ Heading</a>
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="" phx-target={@myself}>+ Text</a>
          <a href="#" class="text-xs border border-gray-400 text-gray-600 rounded-full px-1 py-1" phx-click="" phx-target={@myself}>+ Tweet</a>
        </div>
      </div>
    """
  end
end
