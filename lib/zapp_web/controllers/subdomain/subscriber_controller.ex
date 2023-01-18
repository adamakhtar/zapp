defmodule ZappWeb.Subdomain.SubscriberController do
  use ZappWeb, :controller

  alias ZappWeb.Subdomain
  alias Zapp.Audience
  alias Zapp.Audience.Subscriber
  alias ZappWeb.Plugs.NavigationHistory

  def new(conn, _params) do
    changeset = Audience.change_subscriber(%Subscriber{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"subscriber" => subscriber_params}) do
    case Audience.create_newsletter_subscriber(conn.assigns.newsletter.id, subscriber_params) do
      {:ok, subscriber} ->
        IO
        conn
        |> put_flash(:info, "Thank you! You are now subscribed.")
        |> redirect(to: NavigationHistory.previous_path(conn, default: "/"))

      {:error, %Ecto.Changeset{} = changeset} ->
        # TODO - improve flash message formatting. "Email has already been registered" would be better
        # as "Sorry it looks like you have already registered for this email. Check your Inbox and Spam"
        conn
        |> put_flash(:error, Audience.join_changeset_errors(changeset))
        |> redirect(to: NavigationHistory.previous_path(conn, default: "/"))
    end
  end
end
