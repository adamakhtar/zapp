defmodule Zapp.Twitter.Client.Tweet do
  defstruct   [:text,
              :media,
              :user,
              :retweet_count,
              :favorite_count]
end

defmodule Zapp.Twitter.Client.Media do
  defstruct [:media_url,
             :type]
end

defmodule Zapp.Twitter.Client.User do
  defstruct [:screen_name,
             :name,
             :profile_image_url]
end



defmodule Zapp.Twitter.Client do
  def configure(access_token, access_token_secret) do
    ExTwitter.configure(:process, [
      consumer_key:        System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret:     System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token:        access_token,
      access_token_secret: access_token_secret
    ])
  end

  def get_tweet(tweet_id, opts \\ []) do
    ExTwitter.lookup_status(tweet_id, include_entitites: true)
    |> Enum.at(0)
    |> parse_tweet()
  end

  def get_lists(user_id) do
    ExTwitter.lists(String.to_integer(user_id), reverse: true)
  end

  def get_list_timeline(owner_id, list_id, options \\ []) do
    ExTwitter.list_timeline([list_id: list_id, owner_id: owner_id] ++ options)
  end

  defp parse_tweet(ex_tweet) do
    tweet = struct(Zapp.Twitter.Client.Tweet, Map.from_struct(ex_tweet))
    user  = parse_user(ex_tweet.user)

    media = parse_media(ex_tweet)

    %{
      tweet | media: media, user: user
    }
  end

  defp parse_media(%{extended_entities: %{media: media}}) do
    Enum.map(media, fn m ->
      %Zapp.Twitter.Client.Media{
        media_url: m.media_url_https,
        type: m.type
      }
    end)
  end

  defp parse_media(_) do
    []
  end

  defp parse_user(ex_user) do
    %Zapp.Twitter.Client.User{
      screen_name: ex_user.screen_name,
      name: ex_user.name,
      profile_image_url: ex_user.profile_image_url_https
    }
  end

  defp parse_user(nil) do
    nil
  end
end
