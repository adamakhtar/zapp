defmodule Zapp.NewslettersTest do
  use Zapp.DataCase

  alias Zapp.Newsletters

  describe "newsletters" do
    alias Zapp.Newsletters.Newsletter

    import Zapp.NewslettersFixtures
    import Zapp.AccountsFixtures

    @invalid_attrs %{name: nil}

    setup do
      %{account: account_fixture()}
    end

    test "list_newsletters/0 returns all newsletters", %{account: account} do
      newsletter = newsletter_fixture(account)
      assert Newsletters.list_newsletters() == [newsletter]
    end

    test "get_newsletter!/1 returns the newsletter with given id", %{account: account} do
      newsletter = newsletter_fixture(account)
      assert Newsletters.get_newsletter!(newsletter.id) == newsletter
    end

    test "create_newsletter/1 with valid data creates a newsletter" do
      account = account_fixture()
      valid_attrs = valid_newsletter_attributes(%{name: "some name"})

      assert {:ok, %Newsletter{} = newsletter} = Newsletters.create_newsletter(account, valid_attrs)
      assert newsletter.name == "some name"
      assert newsletter.account_id == account.id
    end

    test "create_newsletter/1 with invalid data returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} = Newsletters.create_newsletter(account, @invalid_attrs)
    end

    test "create_demo_newsletter/1" do
      account = account_fixture()

      {:ok, %{newsletter: newsletter, issue: issue}} = Newsletters.create_demo_newsletter(account)

      assert newsletter.name == "Amazing Newsletter"
      assert issue.title == "The Maiden Issue"
      assert newsletter.account_id == account.id
      assert issue.account_id == account.id
      assert issue.newsletter_id == newsletter.id
    end

    test "update_newsletter/2 with valid data updates the newsletter", %{account: account} do
      newsletter = newsletter_fixture(account)
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Newsletter{} = newsletter} = Newsletters.update_newsletter(newsletter, update_attrs)
      assert newsletter.name == "some updated name"
    end

    test "update_newsletter/2 with invalid data returns error changeset", %{account: account} do
      newsletter = newsletter_fixture(account)
      assert {:error, %Ecto.Changeset{}} = Newsletters.update_newsletter(newsletter, @invalid_attrs)
      assert newsletter == Newsletters.get_newsletter!(newsletter.id)
    end

    test "delete_newsletter/1 deletes the newsletter", %{account: account} do
      newsletter = newsletter_fixture(account)
      assert {:ok, %Newsletter{}} = Newsletters.delete_newsletter(newsletter)
      assert_raise Ecto.NoResultsError, fn -> Newsletters.get_newsletter!(newsletter.id) end
    end

    test "change_newsletter/1 returns a newsletter changeset", %{account: account} do
      newsletter = newsletter_fixture(account)
      assert %Ecto.Changeset{} = Newsletters.change_newsletter(newsletter)
    end
  end

  describe "issues" do
    alias Zapp.Newsletters.Issue

    import Zapp.NewslettersFixtures
    import Zapp.AccountsFixtures

    @invalid_attrs %{title: nil}

    setup do
      account = account_fixture()
      newsletter = newsletter_fixture(account)

      %{newsletter: newsletter}
    end

    test "list_issues/0 returns all issues", %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      assert Newsletters.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id", %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      assert Newsletters.get_issue!(issue.id) == issue
    end

    alias Zapp.Newsletters.Section

    test "get_issue_with_sections/1 returns the issue with preloaded sections orderd by rank for given id",
        %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      tweet_section_1 = tweet_section_fixture(issue, 0, %{body: "first"})
      tweet_section_2 = tweet_section_fixture(issue, 1, %{body: "second"})
      tweet_section_3 = tweet_section_fixture(issue, 2, %{body: "third"})
      # now insert a new record inbetween
      tweet_section_4 = tweet_section_fixture(issue, 0, %{body: "fourth"})

      fetched_issue = Newsletters.get_issue_with_sections!(issue.id)

      assert fetched_issue.id == issue.id
      assert Enum.count(fetched_issue.sections) == 4
      assert Enum.at(fetched_issue.sections, 0).id == tweet_section_4.section.id
      assert Enum.at(fetched_issue.sections, 1).id == tweet_section_1.section.id
      assert Enum.at(fetched_issue.sections, 2).id == tweet_section_2.section.id
      assert Enum.at(fetched_issue.sections, 3).id == tweet_section_3.section.id
    end

    test "create_issue/1 with valid data creates a issue", %{newsletter: newsletter} do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Issue{} = issue} = Newsletters.create_issue(newsletter, valid_attrs)
      assert issue.title == "some title"
      assert issue.newsletter_id == newsletter.id
      assert issue.account_id == newsletter.account_id
    end

    test "create_issue/1 with invalid data returns error changeset", %{newsletter: newsletter} do
      assert {:error, %Ecto.Changeset{}} = Newsletters.create_issue(newsletter, @invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue", %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Issue{} = issue} = Newsletters.update_issue(issue, update_attrs)
      assert issue.title == "some updated title"
    end

    test "update_issue/2 with invalid data returns error changeset", %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      assert {:error, %Ecto.Changeset{}} = Newsletters.update_issue(issue, @invalid_attrs)
      assert issue == Newsletters.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue", %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      assert {:ok, %Issue{}} = Newsletters.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Newsletters.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset", %{newsletter: newsletter} do
      issue = issue_fixture(newsletter)
      assert %Ecto.Changeset{} = Newsletters.change_issue(issue)
    end
  end


  describe "sections" do
    alias Zapp.Newsletters.{Issue, Section}

    import Zapp.NewslettersFixtures
    import Zapp.AccountsFixtures

    @invalid_attrs %{title: nil}

    setup do
      account = account_fixture()
      newsletter = newsletter_fixture(account)
      issue = issue_fixture(newsletter)

      %{issue: issue}
    end

    test "change_issue_section/2 returns changeset", %{issue: issue} do
      changeset = Newsletters.change_issue_section(issue, %Section{}, %{position: 1})

      assert changeset.changes.issue_id == issue.id
      assert changeset.changes.position == 1
    end

    test "list_sections/0 returns sections preloaded with section types", %{issue: issue} do
      tweet_section_1 = tweet_section_fixture(issue, 1, %{body: "first"})
      tweet_section_2 = tweet_section_fixture(issue, 2, %{body: "second"})

      sections = Newsletters.list_sections()

      assert Enum.count(sections) == 2
      assert Enum.at(sections, 0).tweet_section.body == "first"
      assert Enum.at(sections, 1).tweet_section.body == "second"
    end
  end

  describe "tweet_sections" do
    alias Zapp.Newsletters.{Issue, TweetSection}

    import Zapp.NewslettersFixtures
    import Zapp.AccountsFixtures

    @invalid_attrs %{title: nil}

    setup do
      account = account_fixture()
      newsletter = newsletter_fixture(account)
      issue = issue_fixture(newsletter)

      %{issue: issue}
    end

    test "change_tweet_section/3 returns changeset", %{issue: issue} do
      changeset = Newsletters.change_tweet_section(issue, %TweetSection{}, %{body: "Hi there"})

      assert changeset.changes.body == "Hi there"
    end

    test "create_issue_tweet_section/3 creates tweet_section with section", %{issue: issue} do
      tweet_section_fixture(issue, 0, %{body: "first"})
      tweet_section_fixture(issue, 1, %{body: "second"})

      {:ok, %TweetSection{} = tweet_section} = Newsletters.create_tweet_section(issue, 1, %{body: "Hi there"})

      reloaded_issue = Newsletters.get_issue_with_sections!(issue.id)
      # assert tweet_section.section.issue_id == issue.id
      # assert tweet_section.section.position == 1
      # assert tweet_section.body == "Hi there"
      # assert Enum.at(reloaded_issue.sections, 0).tweet_section.body == "first"
      assert Enum.at(reloaded_issue.sections, 2).tweet_section.body == "second"
      # assert Enum.at(reloaded_issue.sections, 1).tweet_section.body == "Hi there"

    end
  end
end
