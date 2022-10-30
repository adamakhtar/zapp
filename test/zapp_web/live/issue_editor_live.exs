defmodule ZappWeb.IssueEditorLiveTest do
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


  describe "Edit" do
    setup :create_newsletter
    setup :create_issue

    test "displays issue", %{conn: conn, issue: issue} do
      {:ok, _edit_live, html} = live(conn, Routes.issue_editor_show_path(conn, :show, issue))

      assert html =~ "Edit Issue"
      assert html =~ issue.title
    end
  end
end
