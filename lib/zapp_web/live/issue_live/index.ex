defmodule ZappWeb.IssueLive.Index do
  use ZappWeb, :live_view

  alias Zapp.Newsletters

  @impl true
  def mount(_params, _session, socket) do
    newsletter = Newsletters.get_account_newsletter!(socket.assigns.current_account)
    issues = Newsletters.list_newsletter_issues(newsletter)

    {:ok,
      socket
      |> assign(:issues, issues)
      |> assign(:newsletter, newsletter)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    case Newsletters.create_issue(socket.assigns.newsletter, %{title: "A new issue"}) do
      {:ok, issue} ->
         socket
         |> put_flash(:info, "Issue created successfully")
         |> push_redirect(to: Routes.issue_editor_show_path(socket, :show, issue))

      {:error, _changeset} ->
        {:noreply,
        socket
         |> put_flash(:error, "There was a problem. Please try again.")}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Issues")
    |> assign(:issue, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    issue = Newsletters.get_issue!(id)
    {:ok, _} = Newsletters.delete_issue(issue)

    {:noreply, assign(socket, :issues, list_issues())}
  end

  defp list_issues do
    Newsletters.list_issues()
  end
end
