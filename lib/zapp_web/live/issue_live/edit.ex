defmodule ZappWeb.IssueLive.Edit do
  use ZappWeb, :live_view

  alias Zapp.Newsletters

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    # TODO - authorise
    issue = Newsletters.get_issue!(id)

    {:ok,
    socket
    |> assign(:issue, issue)}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Edit Issue")}
  end
end
