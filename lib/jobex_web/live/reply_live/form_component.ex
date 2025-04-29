defmodule JobexWeb.ReplyLive.FormComponent do
  use JobexWeb, :live_component

  alias Jobex.Applications

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage reply records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reply-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" label="Reception date" />
        <.input field={@form[:feedback]} type="text" label="Feedback" />
        <.input field={@form[:go_forward]} type="checkbox" label="Go forward" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Reply</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reply: reply} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Applications.change_reply(reply))
     end)}
  end

  @impl true
  def handle_event("validate", %{"reply" => reply_params}, socket) do
    changeset = Applications.change_reply(socket.assigns.reply, reply_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"reply" => reply_params}, socket) do
    save_reply(socket, socket.assigns.action, reply_params)
  end

  defp save_reply(socket, :edit, reply_params) do
    case Applications.update_reply(socket.assigns.reply, reply_params) do
      {:ok, reply} ->
        notify_parent({:saved, reply})

        {:noreply,
         socket
         |> put_flash(:info, "Reply updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_reply(socket, :new, reply_params) do
    case Applications.create_reply(reply_params) do
      {:ok, reply} ->
        notify_parent({:saved, reply})

        {:noreply,
         socket
         |> put_flash(:info, "Reply created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
