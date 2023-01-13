defmodule ZappWeb.Subdomain.IssueController do
  use ZappWeb, :controller

  alias Zapp.Newsletter
  alias Zapp.Newsletters.Issue

  def index(conn, _params) do
    issues = [] # Newsletter.list_issues()
    render(conn, "index.html", issues: issues, subdomain: conn.private.subdomain)
  end

  def show(conn, %{"id" => id}) do
    # issue = Newsletter.get_issue!(id)
    render(conn, "show.html", issue: %Issue{})
  end
end
