defmodule ZappWeb.IssueLive.Index do
  use ZappWeb, :live_view

  alias Zapp.Newsletters
  alias Zapp.Audience

  def render(assigns) do
    ~H"""
      <h1>Listing Issues for <%= @newsletter.name %></h1>

      <table>
        <thead>
          <tr>
            <th>Title</th>

            <th></th>
          </tr>
        </thead>

        <tbody id="issues">
          <%= for issue <- @issues do %>
            <tr id={"issue-#{issue.id}"}>
              <td><%= issue.title %></td>

              <td>
                <span><%= live_redirect "Show", to: Routes.issue_show_path(@socket, :show, issue) %></span>
                <span><%= live_redirect "Edit", to: Routes.issue_editor_show_path(@socket, :show, issue) %></span>
                <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: issue.id, data: [confirm: "Are you sure?"] %></span>
                <span><%= link "Publish", to: "#", phx_click: "publish", phx_value_id: issue.id, data: [confirm: "Are you sure?"] %></span>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>

      <span><%= live_patch "New Issue", to: Routes.issue_index_path(@socket, :new) %></span>
    """
  end

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
    # TODO SECURITY - authorise
    issue = Newsletters.get_issue!(id)
    {:ok, _} = Newsletters.delete_issue(issue)

    {:noreply, assign(socket, :issues, list_issues())}
  end

  @impl true
  def handle_event("publish", %{"id" => id}, socket) do
    # TODO SECURITY - authorise
    issue = Newsletters.get_issue_with_sections!(id)
    # TOOD PEFORMANCE - batch the loading and publishing. Backgroud job?
    subscribers = Audience.list_newsletter_subscribers(issue.newsletter_id)

    IO.inspect(["HELLO", subscribers, issue.newsletter_id])

    case Newsletters.publish_issue(issue, subscribers) do
      {:ok, _} ->
        {:noreply,
        socket
         |> put_flash(:info, "Issue successfully published")
        }
      {:error, _} ->
        {:noreply,
          socket
           |> put_flash(:info, "There was a problem publishing.")
        }
    end
  end

  defp list_issues do
    Newsletters.list_issues()
  end
end
