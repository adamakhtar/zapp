defmodule ZappWeb.IssueEditorLive.SectionComponent do
  use ZappWeb, :live_component

  alias Zapp.Newsletters

  alias ZappWeb.IssueEditorLive.{
    TextSectionComponent,
    HeadingSectionComponent
  }

  @impl true
  def render(assigns) do
    ~H"""
      <div draggable="true"
           id={"#{@id}"}
           class="js-draggable mb-4"
            data-section-id={@section.id}>
        <div class="border border-gray-200 py-3 px-4 text-sm">
          <div class="flex flex-row justify-end py-1 border-b border-gray-200">
            <a href="#"
               class=""
               phx-click="delete"
               phx-target={@myself}>Delete</a>.
          </div>

          <%= if @section.tweet_section do %>
            <%= @section.tweet_section.body %>
          <% end %>

          <%= if @section.heading_section do %>
            <.live_component
                module={HeadingSectionComponent}
                id={ "#{@id}-heading-section" }
                section={@section}
                heading_section={@section.heading_section}
            />
          <% end %>

          <%= if @section.text_section do %>
            <.live_component
                module={TextSectionComponent}
                id={ "#{@id}-text-section" }
                section={@section}
                text_section={@section.text_section}
            />
          <% end %>
        </div>
      </div>
    """
  end

  @impl true
  def update(%{section: section} = assigns, socket) do

    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("delete", _event, socket) do
    {:ok, _section} = Newsletters.delete_section(socket.assigns.section)
    send self(), {:section_deleted, socket.assigns.section}
    {:noreply, socket}
  end
end