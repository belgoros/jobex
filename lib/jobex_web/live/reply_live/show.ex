defmodule JobexWeb.ReplyLive.Show do
  use JobexWeb, :live_view

  alias Jobex.Applications

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:reply, Applications.get_reply!(id))}
  end

  defp page_title(:show), do: "Show Reply"
  defp page_title(:edit), do: "Edit Reply"
end
