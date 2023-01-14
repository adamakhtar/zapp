defmodule ZappWeb.Plugs.Subdomain.LoadNewsletterFromSubdomain do
  import Plug.Conn

  alias Zapp.Newsletters

  def init(options) do
    options
  end

  def call(conn, _opts) do
    newsletter = Newsletters.get_newsletter_from_subdomain(conn.private[:subdomain])

    if newsletter do
      conn
      |> assign(:newsletter, newsletter)
    else
      conn
    end
  end
end


