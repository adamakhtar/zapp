defmodule ZappWeb.IssueLive.Edit do
  use ZappWeb, :live_view

  alias Zapp.Newsletters
  alias Zapp.Library
  alias Zapp.IssueEditor

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    # TODO - authorise
    issue = Newsletters.get_issue_with_sections!(id)
    tweets = Library.list_tweets()

    {:ok,
    socket
    |> assign(:page_title, "Edit Issue")
    |> assign(:issue, issue)
    |> assign(:tweets, tweets)
    |> assign(:dropzone, [])
    }
  end

  @impl true
  def handle_params(_params, _session, socket) do

    {:noreply, socket}
  end

  @impl true
  def handle_event("tweet_dropped", %{"tweet_id" => tweet_id, "index" => index}, socket) do
    case IssueEditor.add_tweet_to_issue(socket.assigns.issue, String.to_integer(tweet_id)) do
      {:ok, _tweet_section} ->
        issue = Newsletters.get_issue_with_sections!(socket.assigns.issue.id)
        {:noreply,
         socket
         |> assign(issue: issue)
        }

      {:error, _} ->
        # TODO
    end
  end
end
