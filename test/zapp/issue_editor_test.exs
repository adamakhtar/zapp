defmodule Zapp.IssueEditorTest do
  use Zapp.DataCase

  alias Zapp.Newsletters

  describe "newsletters" do
    alias Zapp.IssueEditor
    alias Zapp.Library
    alias Zapp.Newsletters.{TweetSection}

    import Zapp.NewslettersFixtures
    import Zapp.AccountsFixtures

    setup do
      %{account: account_fixture()}
    end

    test "add_tweet_to_issue/2 adds given tweet to issue at requested position", %{account: account} do
      newsletter = newsletter_fixture(account)
      issue = issue_fixture(newsletter)
      tweet_section_fixture(issue, 1, %{body: "first"})
      tweet_section_fixture(issue, 2, %{body: "second"})
      tweet = Enum.at(Library.list_tweets, 0)

      {:ok, %TweetSection{} = tweet_section} = IssueEditor.add_tweet_to_issue(issue, %{tweet_id: tweet.id, position: 1})

      reloaded_issue = Newsletters.get_issue_with_sections!(issue.id)
      assert tweet_section.body == tweet.body
      assert tweet_section.section.issue_id == issue.id
      assert Enum.at(reloaded_issue.sections, 0).tweet_section.body == "first"
      assert Enum.at(reloaded_issue.sections, 1).tweet_section.body == tweet.body
      assert Enum.at(reloaded_issue.sections, 2).tweet_section.body == "second"
    end
  end
end
