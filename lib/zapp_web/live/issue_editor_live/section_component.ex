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
      <div
           id={"#{@id}"}
           class="js-draggable group mb-4"
            data-section-id={@section.id}>
        <div class="relative">
          <div class="js-handle hover:cursor-grab opacity-0 group-hover:opacity-100 transition-opacity ease-out absolute -left-3 -top-3 px-1 py-1 bg-white rounded-full border border-gray-300">
            <a href="#"
               class="block"
               phx-click="delete"
               phx-target={@myself}>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </a>
          </div>
          <div class="opacity-0 group-hover:opacity-100 transition-opacity ease-out absolute -right-3 -top-3 px-1 py-1 bg-white rounded-full border border-gray-300">
            <a href="#"
               class=""
               phx-click="delete"
               phx-target={@myself}>
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 9.75l4.5 4.5m0-4.5l-4.5 4.5M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </a>
          </div>

          <%= if @section.tweet_section do %>
            <div class="flex flex-col rounded-lg border border-gray-300 hover:shadow-sm py-3 px-4 text-sm">
              <header class="flex flex-row justify-left mb-2">
                <img src={ @section.tweet_section.user_profile_image_url} class="w-12 h-12 rounded-full"/>

                <div class="flex flex-col justify-center ml-2">
                  <div class="text-gray-900 text-base font-medium leading-none mb-1"><%= @section.tweet_section.user_name %></div>
                  <div class="text-gray-600 leading-none mb-0">@<%= @section.tweet_section.user_screen_name %></div>
                </div>
              </header>

              <section class="text-base leading-normal">
                <%= @section.tweet_section.text %>
              </section>

              <%= if @section.tweet_section.tweet_section_medias do %>
                <%= for media <- @section.tweet_section.tweet_section_medias do %>
                  <img src={ media.url }>
                <% end %>
              <% end %>

              <%= @section.tweet_section.retweet_count %>
              <%= @section.tweet_section.favorite_count %>
            </div>
          <% end %>

          <%= if @section.heading_section do %>
            <%= live_component(
                  @socket,
                  ZappWeb.IssueEditorLive.HeadingSectionComponent,
                  id: "#{@id}-heading-section",
                  section: @section,
                  heading_section: @section.heading_section
                )
            %>
          <% end %>

          <%= if @section.text_section do %>
            <%= live_component(
                  @socket,
                  ZappWeb.IssueEditorLive.TextSectionComponent,
                  id: "#{@id}-text-section",
                  section: @section,
                  text_section: @section.text_section
                )
            %>
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