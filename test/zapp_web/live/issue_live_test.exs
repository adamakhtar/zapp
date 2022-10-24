defmodule ZappWeb.IssueLiveTest do
  use ZappWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Zapp.Newsletters.Issue

  setup :register_and_log_in_identity

  defp create_newsletter(%{account: account}) do
    newsletter = Zapp.NewslettersFixtures.newsletter_fixture(account, %{name: "test newsletter"})
    %{newsletter: newsletter}
  end

  defp create_issue(%{newsletter: newsletter}) do
    issue = Zapp.NewslettersFixtures.issue_fixture(newsletter, %{title: "test issue"})
    %{issue: issue}
  end

  describe "Index" do
    setup :create_newsletter
    setup :create_issue

    test "lists all issues", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.issue_index_path(conn, :index))

      assert html =~ "Listing Issues for test newsletter"
      assert html =~ "test issue"
    end

    test "creates new issue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.issue_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> element("a", "New Issue")
        |> render_click()
        |> follow_redirect(conn)

      created_issue = Issue |> Ecto.Query.last |> Zapp.Repo.one

      assert_redirect(index_live, Routes.issue_edit_path(conn, :edit, created_issue))

      assert html =~ "Issue created successfully"
      assert html =~ "A new issue"
    end

    test "deletes issue in listing", %{conn: conn, issue: issue} do
      {:ok, index_live, _html} = live(conn, Routes.issue_index_path(conn, :index))

      assert index_live |> element("#issue-#{issue.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#issue-#{issue.id}")
    end
  end

   describe "Edit" do
    setup :create_newsletter
    setup :create_issue

    test "displays issue", %{conn: conn, issue: issue} do
      {:ok, _edit_live, html} = live(conn, Routes.issue_edit_path(conn, :edit, issue))

      assert html =~ "Edit Issue"
      assert html =~ issue.title
    end
  end
end
