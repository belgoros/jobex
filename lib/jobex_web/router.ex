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
    live "/companies/:id", CompanyLive.Show, :show

    live "/contacts", ContactLive.Index, :index
    live "/contacts/new", ContactLive.Form, :new
    live "/contacts/:id/edit", ContactLive.Form, :edit

    live "/contacts/:id", ContactLive.Show, :show
    live "/contacts/:id/show/edit", ContactLive.Show, :edit

    live "/positions", PositionLive.Index, :index
    live "/positions/new", PositionLive.Index, :new
    live "/positions/:id/edit", PositionLive.Index, :edit

    live "/positions/:position_id", PositionLive.Show, :show
    live "/positions/:id/show/edit", PositionLive.Show, :edit

    live "/replies", ReplyLive.Index, :index
    live "/positions/:position_id/new-reply", PositionLive.Show, :new_reply

    live "/positions/:position_id/replies/:reply_id/edit",
         PositionLive.Show,
         :edit_reply

    # live "/replies/new", ReplyLive.Index, :new
    # live "/replies/:id/edit", ReplyLive.Index, :edit

    # live "/replies/:id", ReplyLive.Show, :show
    # live "/replies/:id/show/edit", ReplyLive.Show, :edit
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
