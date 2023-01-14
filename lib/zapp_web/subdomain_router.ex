defmodule ZappWeb.SubdomainRouter do
  use ZappWeb, :router

  import ZappWeb.IdentityAuth
  import ZappWeb.Subomain.NewsletterAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ZappWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_identity
    plug ZappWeb.Plugs.CurrentUserPlug
    plug ZappWeb.Plugs.Subdomain.LoadNewsletterFromSubdomain
  end

  scope "/", ZappWeb.Subdomain, as: :subdomain do
    pipe_through [:browser, :require_newsletter_exists_for_subdomain]

    get "/", IssueController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Subdomainer do
  #   pipe_through :api
  # end
end
