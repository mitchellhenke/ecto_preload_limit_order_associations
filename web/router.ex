defmodule PreloadLimitOrderAssociation.Router do
  use PreloadLimitOrderAssociation.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PreloadLimitOrderAssociation do
    pipe_through :api
  end
end
