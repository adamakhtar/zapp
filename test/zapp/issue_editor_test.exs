defmodule Zapp.IssueEditorTest do
  use Zapp.DataCase

  alias Zapp.Newsletters

  describe "newsletters" do
    alias Zapp.IssueEditor
    alias Zapp.Library
    alias Zapp.Newsletters.{Newsletter, TweetSection}



    import Zapp.NewslettersFixtures
    import Zapp.AccountsFixtures

    @invalid_attrs %{name: nil}

    setup do
      %{account: account_fixture()}
    end

    test "add_tweet_to_issue/2 adds given tweet to issue", %{account: account} do
      newsletter = newsletter_fixture(account)
      issue = issue_fixture(newsletter)
      tweet = Enum.at(Library.list_tweets, 0)

      {:ok, %TweetSection{} = tweet_section} = IssueEditor.add_tweet_to_issue(issue, tweet.id)

      assert tweet_section.body == tweet.body
      assert tweet_section.issue_id == issue.id
    end
  end
end
