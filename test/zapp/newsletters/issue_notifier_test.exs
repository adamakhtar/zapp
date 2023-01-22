defmodule Zapp.Newsletters.IssueNotifierTest do
  use Zapp.DataCase
  use ExUnit.Case, async: true
  import Swoosh.TestAssertions

  import Zapp.AccountsFixtures
  import Zapp.AudienceFixtures
  import Zapp.NewslettersFixtures

  alias Zapp.Newsletters
  alias Zapp.Newsletters.IssueNotifier
  alias Zapp.Mailer

  test "deliver_issue/1" do
    account = account_fixture()
    newsletter = newsletter_fixture(account)
    issue = issue_fixture(newsletter, %{title: "The maiden issue!"})
    heading_section_fixture(issue, 1, %{title: "An interesting heading"})
    subscriber = subscriber_fixture(newsletter, %{email: "a@a.com"})

    issue_with_sections = Newsletters.get_issue_with_sections!(issue.id)

    IssueNotifier.deliver_issue(issue_with_sections, subscriber)
    |> Mailer.deliver

    assert_email_sent(
      subject: "The maiden issue!",
      to: {"", "a@a.com"},
      html_body: ~r/An interesting heading/
    )
  end
end
