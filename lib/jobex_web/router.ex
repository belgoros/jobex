defmodule JobexWeb.Router do
  use JobexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JobexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JobexWeb do
    pipe_through :browser

    live "/", HomeLive
    live "/companies", CompanyLive.Index, :index
    live "/companies/new", CompanyLive.Index, :new_company
    live "/companies/:id/edit", CompanyLive.Index, :edit_company
    live "/companies/:company_id", CompanyLive.Show, :show
    live "/companies/:company_id/new-position", CompanyLive.Show, :new_position
    live "/companies/:company_id/positions/:position_id/edit", CompanyLive.Show, :edit_position

    live "/contacts", ContactLive.Index, :index
    live "/contacts/new", ContactLive.Form, :new
    live "/contacts/:id/edit", ContactLive.Form, :edit

    live "/contacts/:id", ContactLive.Show, :show
    live "/contacts/:id/show/edit", ContactLive.Show, :edit

    live "/positions", PositionLive.Index, :index
    live "/positions/new", PositionLive.Index, :new
    live "/positions/:id/edit", PositionLive.Index, :edit

    live "/positions/:position_id", PositionLive.Show, :show
    live "/positions/:position_id/show/edit", PositionLive.Show, :edit
    live "/positions/:position_id/new-reply", PositionLive.Show, :new_reply
    live "/positions/:position_id/replies/:reply_id/edit", PositionLive.Show, :edit_reply
  end

  # Other scopes may use custom stacks.
  # scope "/api", JobexWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jobex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JobexWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
