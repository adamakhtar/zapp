defmodule Zapp.Newsletters.IssueNotifierTest do
  use ExUnit.Case, async: true
  import Swoosh.TestAssertions

  alias Zapp.Newsletters.IssueNotifier
  alias Zapp.Mailer

  test "deliver_issue/1" do
    user = %{name: "Alice", email: "alice@example.com"}

    IssueNotifier.deliver_issue(user)
    |> Mailer.deliver

    assert_email_sent(
      subject: "Welcome to Phoenix, Alice!",
      to: {"Alice", "alice@example.com"},
      html_body: ~r/Welcome/
    )
  end
end
