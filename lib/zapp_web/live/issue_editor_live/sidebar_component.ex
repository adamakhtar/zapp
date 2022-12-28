defmodule ZappWeb.IssueEditorLive.SidebarComponent do
  use ZappWeb, :live_component

  alias Zapp.Twitter

  @impl true
  def render(assigns) do
    ~H"""
      <div class="bg-gray-200 fixed right-0 bottom-0 border-l border-gray-200 max-w-sm bg-white" style="top: 45px;">
        <div class="flex flex-col h-full">
          <div class="px-3 py-2 border-b border-gray-200">
            <.form
              let={f}
              for={:s}
              phx-change="list_selected"
            >
              <%= select(f, :current_list_id, Enum.map(@lists, &{&1.name, &1.id}), selected: @current_list.id) %>
            </.form>
          </div>

          <div class="px-3 py-2 flex-grow overflow-auto overscroll-contain"
               data-dropzone="tweets">
            <%= if @twitter_credentials do %>
              <%= for _i <- 1..100 do %>
                <div class="w-full h-64 border border-gray-200 mb-2"></div>
              <% end %>
              <%= for tweet <- @tweets do %>
                <div draggable="true"
                     data-tweet-id={"#{tweet.id}"}
                     class="js-draggable w-full min-h-32 bg-white border border-gray-200 rounded-lg mb-2 px-3 py-2 text-sm">

                  <img src={ tweet.user.profile_image_url_https}/>
                  @<%= tweet.user.screen_name %>
                  <%= tweet.text %>

                  <%= if tweet.extended_entities && tweet.extended_entities.media do %>
                    <%= for media <- tweet.extended_entities.media do %>
                      <img src={ media.media_url_https }>
                    <% end %>
                 <% end %>

                 <%= tweet.retweet_count %>
                 <%= tweet.favorite_count %>
                </div>
              <% end %>

              <button phx-click="load_more_tweets" phx-target={ @myself }>Load More</button>
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

    # tweets = fetch_list_timeline(
    #   twitter_credentials.service_id,
    #   current_list.twitter_id
    # )

    tweets = []

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:tweets, tweets)
     |> assign(:current_list, current_list)
     |> assign(:lists, lists)
    }
  end

  def handle_event("list_selected", params, socket) do
    IO.inspect(params)
    # IO.inspect(["list_selected", list_id])

    # TODO - what happens if there is no longer a list?
    # current_list = Twitter.get_list(socket.assigns.current_account.id, list_id)
    # tweets = fetch_list_timeline(
    #   socket.assigns.twitter_credentials.service_id,
    #   current_list.twitter_id
    # )

    # {:noreply,
    #  socket
    #  |> assign(:current_list, current_list)
    #  |> assign(:tweets, tweets)
    # }

    {:noreply, socket}
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



