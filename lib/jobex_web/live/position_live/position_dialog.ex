defmodule JobexWeb.PositionLive.PositionDialog do
  use JobexWeb, :live_component

  alias Jobex.Applications

  @impl true
  def update(assigns, socket) do
    changeset =
      Applications.change_position(assigns.position, %{})

    socket =
      socket
      |> assign(assigns)
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"position" => position_params}, socket) do
    changeset =
      socket.assigns.position
      |> Applications.change_position(position_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"position" => position_params}, socket) do
    save_position(socket, socket.assigns.action, position_params)
  end

  defp save_position(socket, :new_position, position_params) do
    company = socket.assigns.company

    position_params =
      Map.put(position_params, "company_id", company.id)

    case Applications.create_position(position_params) do
      {:ok, _position} ->
        socket =
          socket
          |> put_flash(:info, "Position created")
          |> push_navigate(to: ~p"/companies/#{company}", replace: true)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = Map.put(changeset, :action, :validate)
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp save_position(socket, :edit_position, position_params) do
    company = socket.assigns.company

    position_params =
      Map.put(position_params, "company_id", company.id)

    case Applications.update_position(socket.assigns.position, position_params) do
      {:ok, _position} ->
        socket =
          socket
          |> put_flash(:info, "Position updated")
          |> push_navigate(to: ~p"/companies/#{company}", replace: true)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = Map.put(changeset, :action, :validate)
        {:noreply, socket |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: "position"))
  end
end
