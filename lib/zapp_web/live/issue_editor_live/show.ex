defmodule ZappWeb.IssueEditorLive.Show do
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
  def handle_event("tweet_dropped", %{"tweet_id" => tweet_id, "position" => position}, socket) do
    prepared_attrs = %{
      tweet_id: String.to_integer(tweet_id),
      position: position
    }

    case IssueEditor.add_tweet_to_issue(socket.assigns.issue, prepared_attrs) do
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


  @impl true
  def handle_event("section_moved", %{"section_id" => section_id, "position" => position}, socket) do
    prepared_attrs = %{
      section_id: String.to_integer(section_id),
      position: position
    }

    case IssueEditor.move_section(socket.assigns.issue, prepared_attrs) do
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

  @impl true
  def handle_info({:section_deleted, section}, socket) do
    issue = Newsletters.get_issue_with_sections!(socket.assigns.issue.id)

    {:noreply,
     socket
     |> assign(issue: issue)
    }
  end

  @impl true
  def handle_info({:section_added, section}, socket) do
    issue = Newsletters.get_issue_with_sections!(socket.assigns.issue.id)

    {:noreply,
     socket
     |> assign(issue: issue)
    }
  end
end
