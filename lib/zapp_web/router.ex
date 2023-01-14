defmodule ZappWeb.Router do
  use ZappWeb, :router

  import ZappWeb.IdentityAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ZappWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_identity
    plug ZappWeb.Plugs.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZappWeb do
    pipe_through :browser

    get "/", PageController, :index, as: :root
  end

  # Other scopes may use custom stacks.
  # scope "/api", ZappWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ZappWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ZappWeb do
    pipe_through [:browser, :redirect_if_identity_is_authenticated]

    get "/identities/register", IdentityRegistrationController, :new
    post "/identities/register", IdentityRegistrationController, :create
    get "/identities/log_in", IdentitySessionController, :new
    post "/identities/log_in", IdentitySessionController, :create
    get "/identities/reset_password", IdentityResetPasswordController, :new
    post "/identities/reset_password", IdentityResetPasswordController, :create
    get "/identities/reset_password/:token", IdentityResetPasswordController, :edit
    put "/identities/reset_password/:token", IdentityResetPasswordController, :update
  end

  scope "/", ZappWeb do
    pipe_through [:browser, :require_authenticated_identity]

    get "/identities/settings", IdentitySettingsController, :edit
    put "/identities/settings", IdentitySettingsController, :update
    get "/identities/settings/confirm_email/:token", IdentitySettingsController, :confirm_email


    ## Uberauth OAuth
    get "/auth/:provider", OauthController, :request
    get "/auth/:provider/callback", OauthController, :callback

    live_session :default, on_mount: ZappWeb.LiveAuth do
      live "/issues", IssueLive.Index, :index
      live "/issues/new", IssueLive.Index, :new

      live "/issues/:id", IssueLive.Show, :show

      live "/issue_editor/:id/", IssueEditorLive.Show, :show
    end
  end


  scope "/", ZappWeb do
    pipe_through [:browser]

    delete "/identities/log_out", IdentitySessionController, :delete
    get "/identities/confirm", IdentityConfirmationController, :new
    post "/identities/confirm", IdentityConfirmationController, :create
    get "/identities/confirm/:token", IdentityConfirmationController, :edit
    post "/identities/confirm/:token", IdentityConfirmationController, :update
  end
end
