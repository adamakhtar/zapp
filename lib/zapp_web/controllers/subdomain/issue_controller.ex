defmodule ZappWeb.Subdomain.IssueController do
  use ZappWeb, :controller
  alias Zapp.Newsletters
  alias Zapp.Newsletters.Issue
  alias Zapp.Audience
  alias Zapp.Audience.Subscriber

  def index(conn, _params) do
    subscriber_changeset = Audience.change_subscriber(%Subscriber{})
    issues = Newsletters.list_newsletter_issues(conn.assigns.newsletter)

    render(conn,
          "index.html",
          subscriber_changeset: subscriber_changeset,
          newsletter: conn.assigns.newsletter,
          issues: issues
          )
  end

  def show(conn, %{"id" => id}) do
    subscriber_changeset = Audience.change_subscriber(%Subscriber{})
    issue = Newsletters.get_issue_with_sections!(id)

    render(conn, "show.html", issue: issue, subscriber_changeset: subscriber_changeset)
  end
end
