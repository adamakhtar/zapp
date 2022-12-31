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
          <div class="js-handle hover:cursor-grab opacity-0 group-hover:opacity-100 transition-opacity ease-out absolute -left-6 top-2 px-1 py-1 bg-white rounded-full border border-gray-300">
            <a href="#"
               class="block">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 15L12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9" />
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
                <div class="mb-2">
                  <%= for media <- @section.tweet_section.tweet_section_medias do %>
                    <img src={ media.url }>
                  <% end %>
                </div>
              <% end %>

              <div class='flex flex-row space-between items-center space-x-4 text-sm text-gray-500'>
                <div class="flex flex-row items-center">
                  <svg  class="w-5 h-5 mr-1 block"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12c0-1.232-.046-2.453-.138-3.662a4.006 4.006 0 00-3.7-3.7 48.678 48.678 0 00-7.324 0 4.006 4.006 0 00-3.7 3.7c-.017.22-.032.441-.046.662M19.5 12l3-3m-3 3l-3-3m-12 3c0 1.232.046 2.453.138 3.662a4.006 4.006 0 003.7 3.7 48.656 48.656 0 007.324 0 4.006 4.006 0 003.7-3.7c.017-.22.032-.441.046-.662M4.5 12l3 3m-3-3l-3 3" />
                  </svg>
                  <div>
                    <%= @section.tweet_section.retweet_count %>
                  </div>
                </div>

                <div class="flex flex-row items-center">
                  <svg class="w-5 h-5 mr-1 text-xs block"
                       xmlns="http://www.w3.org/2000/svg"
                       fill="none"
                       viewBox="0 0 24 24"
                       stroke-width="1.5"
                       stroke="currentColor"
                       >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
                  </svg>
                  <div>
                    <%= @section.tweet_section.favorite_count %>
                  </div>
                </div>
              </div>
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