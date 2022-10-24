defmodule ZappWeb.IssueLive.Show do
  use ZappWeb, :live_view

  alias Zapp.Newsletters

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:issue, Newsletters.get_issue!(id))}
  end

  defp page_title(:show), do: "Show Issue"
  defp page_title(:edit), do: "Edit Issue"
end
