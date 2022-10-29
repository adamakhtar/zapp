defmodule Zapp.IssueEditor do
  @moduledoc """
  The Newsletters context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo

  alias Zapp.Newsletters
  alias Zapp.Newsletters.{Issue, TweetSection}
  alias Zapp.Library

  # TODO test
  def add_tweet_to_issue(%Issue{} = issue, tweet_id) do
    with tweet <- Library.get_tweet(tweet_id),
         {:ok, %TweetSection{} = twitter_section} <- Newsletters.create_issue_tweet_section(issue, tweet) do
      {:ok, twitter_section}
    else
      err ->
        err
    end
  end
end