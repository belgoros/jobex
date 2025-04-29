defmodule JobexWeb.ReplyLive.Index do
  use JobexWeb, :live_view

  alias Jobex.Applications
  alias Jobex.Applications.Reply

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :replies, Applications.list_replies())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reply")
    |> assign(:reply, Applications.get_reply!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reply")
    |> assign(:reply, %Reply{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Replies")
    |> assign(:reply, nil)
  end

  @impl true
  def handle_info({JobexWeb.ReplyLive.FormComponent, {:saved, reply}}, socket) do
    {:noreply, stream_insert(socket, :replies, reply)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reply = Applications.get_reply!(id)
    {:ok, _} = Applications.delete_reply(reply)

    {:noreply, stream_delete(socket, :replies, reply)}
  end
end
