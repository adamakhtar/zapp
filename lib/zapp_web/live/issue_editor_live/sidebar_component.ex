defmodule ZappWeb.IssueEditorLive.SidebarComponent do
  use ZappWeb, :live_component

  alias Zapp.Twitter

  @impl true
  def render(assigns) do
    ~H"""
      <div class="bg-gray-50 fixed right-0 bottom-0 border-l border-gray-300 max-w-sm bg-white" style="top: 45px;">
        <div class="flex flex-col h-full">
          <div class="px-3 py-2 border-b border-gray-300">
            <.form
              let={f}
              for={:s}
              phx-change="list_selected"
              phx-target={@myself}
            >
              <%= select(f, :list_id, Enum.map(@lists, &{&1.name, &1.id}), selected: @current_list.id) %>
            </.form>
          </div>

          <div class="px-3 py-2 flex-grow overflow-auto overscroll-contain"
               data-dropzone="tweets">
            <%= if @twitter_credentials do %>
              <%= for tweet <- @tweets do %>
                <div draggable="true"
                     data-tweet-id={"#{tweet.id}"}
                      class="js-draggable flex flex-col rounded-lg bg-white border border-gray-200 hover:shadow-sm py-3 px-4 mb-4 text-sm">
                  <header class="flex flex-row justify-left mb-1">
                    <img src={ tweet.user.profile_image_url_https} class="w-10 h-10 rounded-full"/>

                    <div class="flex flex-col justify-center ml-2">
                      <div class="text-gray-900 text-sm font-medium leading-none mb-1"><%= tweet.user.screen_name %></div>
                      <div class="text-gray-600 text-sm leading-none mb-0">@<%= tweet.user.name %></div>
                    </div>
                  </header>

                  <section class="text-sm leading-snug mb-2">
                    <%= tweet.text %>
                  </section>

                  <%= if tweet.extended_entities && tweet.extended_entities.media do %>
                    <div class="mb-2">
                      <%= for media <- tweet.extended_entities.media do %>
                        <img src={ media.media_url_https } class="rounded">
                      <% end %>
                    </div>
                  <% end %>

                  <div class='flex flex-row space-between items-center space-x-4 text-xs text-gray-500'>
                    <div class="flex flex-row items-center">
                      <svg  class="w-4 h-4 mr-1 block"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="1.5"
                            stroke="currentColor"
                            >
                        <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12c0-1.232-.046-2.453-.138-3.662a4.006 4.006 0 00-3.7-3.7 48.678 48.678 0 00-7.324 0 4.006 4.006 0 00-3.7 3.7c-.017.22-.032.441-.046.662M19.5 12l3-3m-3 3l-3-3m-12 3c0 1.232.046 2.453.138 3.662a4.006 4.006 0 003.7 3.7 48.656 48.656 0 007.324 0 4.006 4.006 0 003.7-3.7c.017-.22.032-.441.046-.662M4.5 12l3 3m-3-3l-3 3" />
                      </svg>
                      <div>
                        <%= tweet.retweet_count %>
                      </div>
                    </div>

                    <div class="flex flex-row items-center">
                      <svg class="w-4 h-4 mr-1 text-xs block"
                           xmlns="http://www.w3.org/2000/svg"
                           fill="none"
                           viewBox="0 0 24 24"
                           stroke-width="1.5"
                           stroke="currentColor"
                           >
                        <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z" />
                      </svg>
                      <div>
                        <%= tweet.favorite_count %>
                      </div>
                    </div>
                  </div>
                </div>
              <% end %>

              <div class="flex flex-row justify-center py-2">
                <button class="bg-blue-600 text-blue-50 hover:bg-blue-500 px-4 py-2 rounded-md w-full"
                        phx-click="load_more_tweets" phx-target={ @myself } >Load More</button>
              </div>
            <% else %>
              <%= link "Connect Twitter", to: Routes.oauth_path(@socket, :request, "twitter") %>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

  @impl true
  def update(%{issue: issue, twitter_credentials: twitter_credentials, current_account: current_account} = assigns, socket) do
    Twitter.Client.configure(twitter_credentials.token, twitter_credentials.secret)
    lists = Twitter.list_lists(current_account.id, issue.newsletter_id)
    current_list = List.first(lists)

    tweets = fetch_list_timeline(
      twitter_credentials.service_id,
      current_list.twitter_id
    )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tweets, tweets)
     |> assign(:current_list, current_list)
     |> assign(:lists, lists)
    }
  end

  def handle_event("list_selected", %{"s" => %{"list_id" => list_id}} = params, socket) do
    IO.inspect("PARPAMS")
    IO.inspect(params)
    # TODO - what happens if there is no longer a list?
    current_list = Twitter.get_list(socket.assigns.current_account.id, list_id)
    tweets = fetch_list_timeline(
      socket.assigns.twitter_credentials.service_id,
      current_list.twitter_id
    )

    {:noreply,
     socket
     |> assign(:current_list, current_list)
     |> assign(:tweets, tweets)
    }
  end

  def handle_event("load_more_tweets", _value, %{assigns: %{tweets: tweets, twitter_credentials: twitter_credentials, current_list: current_list}} = socket) do
    last_tweet = Enum.at(tweets, -1)
    last_tweet_id = if last_tweet, do: last_tweet.id, else: nil

    IO.inspect(last_tweet)

    new_tweets_including_last_tweet = Twitter.fetch_list_timeline(
      Twitter.Client,
      twitter_credentials.service_id,
      current_list.twitter_id,
      max_id: last_tweet_id,
      expansions: "author_id"
    )

    [_repeated_last_tweet | new_tweets] = new_tweets_including_last_tweet

    all_tweets = tweets ++ new_tweets

    {:noreply,
     socket
     |> assign(:tweets, all_tweets)
    }
  end

  defp fetch_list_timeline(twitter_user_id, twitter_list_id) do
    tweets = Twitter.fetch_list_timeline(
      Twitter.Client,
      twitter_user_id,
      twitter_list_id,
      expansions: "author_id"
    )
  end
end



