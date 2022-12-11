defmodule Zapp.IssueEditor do
  @moduledoc """
  The Newsletters context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo

  alias Zapp.Newsletters
  alias Zapp.Newsletters.{Issue, TweetSection}
  alias Zapp.Twitter.Client
  alias Zapp.Twitter.Client.{Tweet, Media, User}

  # TODO test
  def add_tweet_to_issue(%Issue{} = issue, %{tweet_id: tweet_id, position: position}) do
    tweet =  Client.get_tweet(tweet_id, [:extended_entities, :media])

    with tweet <- Client.get_tweet(tweet_id),
         {:ok, %TweetSection{} = tweet_section} <- create_tweet_section(issue, position, tweet) do
      {:ok, tweet_section}
    else
      err ->
        err
    end
  end

  defp create_tweet_section(%Issue{} = issue, position, %Client.Tweet{}=tweet) do
    args = transform_tweet_into_args(tweet)
    Newsletters.create_tweet_section(issue, position, args)
  end

  defp transform_tweet_into_args(tweet) do
    media_args = Enum.map(tweet.media, &Map.from_struct(&1))

    tweet
    |> Map.from_struct
    |> Map.drop([:user, :media])
    |> Enum.into(%{
        user_name: tweet.user.name,
        user_screen_name: tweet.user.screen_name,
        user_profile_image_url: tweet.user.profile_image_url,
        tweet_section_medias: media_args
      })
  end


  # TOOD test
  def move_section(%Issue{} = issue, %{section_id: section_id, position: position}) do
    section = Newsletters.get_section!(section_id)
    {:ok, section} = Newsletters.move_section(section, position)
    {:ok, section}
  end
end