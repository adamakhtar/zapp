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
  def add_tweet_to_issue(%Issue{} = issue, %{tweet_id: tweet_id, position: position}) do
    with tweet <- Library.get_tweet(tweet_id),
         {:ok, %TweetSection{} = tweet_section} <- Newsletters.create_tweet_section(issue, position, tweet) do
      {:ok, tweet_section}
    else
      err ->
        err
    end
  end

  # TOOD test
  def move_section(%Issue{} = issue, %{section_id: section_id, position: position}) do
    section = Newsletters.get_section!(section_id)
    {:ok, section} = Newsletters.move_section(section, position)
    {:ok, section}
  end
end