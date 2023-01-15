defmodule ZappWeb.Subdomain.IssueController do
  use ZappWeb, :controller
  alias Zapp.Newsletters
  alias Zapp.Newsletters.Issue

  def index(conn, _params) do
    issues = Newsletters.list_newsletter_issues(conn.assigns.newsletter)
    render(conn, "index.html", newsletter: conn.assigns.newsletter, issues: issues)
  end

  def show(conn, %{"id" => id}) do
    issue = Newsletters.get_issue_with_sections!(id)

    render(conn, "show.html", issue: issue)
  end
end
