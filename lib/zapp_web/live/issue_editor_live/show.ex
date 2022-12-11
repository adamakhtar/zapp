defmodule ZappWeb.IssueEditorLive.Show do
  use ZappWeb, :live_view

  alias Zapp.Accounts
  alias Zapp.Newsletters
  alias Zapp.IssueEditor
  alias Zapp.Twitter

  def render(assigns) do
    ~H"""
      <div class="w-full h-full relative" phx-hook="Drag" id="drag">

        <h1>Edit Issue</h1>
        <h3><%= @issue.title %></h3>

        <div class="content h-full w-64 border border-gray-200"
             data-dropzone="issue">

          <%= live_component @socket, ZappWeb.IssueEditorLive.SectionCreatorComponent, id: "section-creator-0", insert_position: 0, issue: @issue %>

          <%= for section <- @sections do %>
            <%= live_component @socket, ZappWeb.IssueEditorLive.SectionComponent, id: "section-#{section.id}", section: section %>
            <%= live_component @socket, ZappWeb.IssueEditorLive.SectionCreatorComponent, id: "section-creator-#{section.id}", insert_position: (section.position + 1), issue: @issue %>
          <% end %>
        </div>

        <%= live_component(
          @socket,
          ZappWeb.IssueEditorLive.SidebarComponent,
          id: "sidebar",
          current_account: @current_account,
          issue: @issue,
          twitter_credentials: @twitter_credentials
        ) %>
      </div>
    """
  end

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    # TODO - authorise
    twitter_credentials = Accounts.get_oauth_credential_for_user(socket.assigns.current_user)
    issue = Newsletters.get_issue_with_sections!(id)

    {:ok,
    socket
    |> assign(:page_title, "Edit Issue")
    |> assign(:issue, issue)
    |> assign(:sections, issue.sections)
    |> assign(:dropzone, [])
    |> assign(:twitter_credentials, twitter_credentials)
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
         |> assign(sections: issue.sections)
        }

      {:error, result} ->
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
         |> assign(sections: issue.sections)
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
     |> assign(sections: issue.sections)
    }
  end

  @impl true
  def handle_info({:section_added, section}, socket) do
    issue = Newsletters.get_issue_with_sections!(socket.assigns.issue.id)

    {:noreply,
     socket
     |> assign(issue: issue)
     |> assign(sections: issue.sections)
    }
  end

  @impl true
  def handle_info({:text_section_updated, section}, socket) do
    issue = Newsletters.get_issue_with_sections!(socket.assigns.issue.id)

    {:noreply,
     socket
     |> assign(issue: issue)
     |> assign(sections: issue.sections)
    }
  end

  @impl true
  def handle_info({:heading_section_updated, section}, socket) do
    issue = Newsletters.get_issue_with_sections!(socket.assigns.issue.id)

    {:noreply,
     socket
     |> assign(issue: issue)
     |> assign(sections: issue.sections)
    }
  end
end
