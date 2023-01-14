defmodule ZappWeb.Subomain.NewsletterAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias ZappWeb.Router.Helpers, as: Routes

  def require_newsletter_exists_for_subdomain(conn, _opts) do
    if conn.assigns[:newsletter] do
      conn
    else
      conn
      |> put_flash(:error, "Sorry there is no newsletter matching this url address. Either there's a typo in the URL or the newsletter no longer exists.")
      |> redirect(external: Routes.root_url(conn, :index))
      |> halt()
    end
  end
end