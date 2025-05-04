defmodule JobexWeb.ReplyLive.ReplyDialog do
  use JobexWeb, :live_component

  alias Jobex.Applications

  @impl true
  def update(assigns, socket) do
    changeset =
      Applications.change_reply(assigns.reply, %{})

    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"reply" => reply_params}, socket) do
    changeset =
      socket.assigns.reply
      |> Applications.change_reply(reply_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"reply" => reply_params}, socket) do
    save_reply(socket, socket.assigns.action, reply_params)
  end

  defp save_reply(socket, :new_reply, reply_params) do
    position = socket.assigns.position

    reply_params =
      Map.put(reply_params, "position_id", position.id)

    case Applications.create_reply(reply_params) do
      {:ok, _reply} ->
        socket =
          socket
          |> put_flash(:info, "Reply created")
          |> push_navigate(to: ~p"/positions/#{position}", replace: true)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = Map.put(changeset, :action, :validate)
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp save_reply(socket, :edit_reply, reply_params) do
    position = socket.assigns.position

    reply_params =
      Map.put(reply_params, "position_id", position.id)

    case Applications.update_reply(socket.assigns.reply, reply_params) do
      {:ok, _reply} ->
        socket =
          socket
          |> put_flash(:info, "Reply updated")
          |> push_navigate(to: ~p"/positions/#{position}", replace: true)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = Map.put(changeset, :action, :validate)
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: "reply"))
  end
end
