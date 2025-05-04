defmodule JobexWeb.PositionLive.Show do
  use JobexWeb, :live_view

  alias Jobex.Applications
  alias Jobex.Applications.Reply
  import JobexWeb.CustomComponents

  @impl true
  def mount(%{"position_id" => id} = params, _session, socket) when is_uuid(id) do
    position = Applications.get_position_with_replies!(id)

    if position do
      {:ok,
       assign(socket,
         position: position
       )
       |> apply_action(params)}
    else
      socket =
        socket
        |> put_flash(:error, "Position not found")
        |> redirect(to: ~p"/positions")

      {:ok, socket}
    end
  end

  def mount(_invalid_id, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "Position not found")
      |> redirect(to: ~p"/positions")

    {:ok, socket}
  end

  def apply_action(%{assigns: %{live_action: :edit_reply}} = socket, %{
        "reply_id" => reply_id
      }) do
    reply = Enum.find(socket.assigns.position.replies, &(&1.id == reply_id))

    if reply do
      assign(socket, reply: reply)
    else
      socket
      |> put_flash(:error, "Reply not found")
      |> redirect(to: ~p"/positions/#{socket.assigns.position}")
    end
  end

  def apply_action(socket, _), do: socket

  @impl true
  def handle_event("delete_reply", %{"id" => reply_id}, socket) do
    reply = Enum.find(socket.assigns.position.replies, &(&1.id == reply_id))

    if reply do
      case Applications.delete_reply(reply) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Reply deleted")
            |> push_navigate(to: ~p"/positions/#{socket.assigns.position.id}", replace: true)

          {:noreply, socket}

        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Failed to delete reply")}
      end
    else
      {:noreply, put_flash(socket, :error, "Reply not found")}
    end
  end

  defp default_reply do
    %Reply{
      date: Date.utc_today(),
      feedback: "No open positions yet"
    }
  end
end
