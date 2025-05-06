defmodule JobexWeb.CompanyLive.Show do
  use JobexWeb, :live_view

  alias Jobex.Sources
  alias Jobex.Applications
  alias Jobex.Applications.Position

  @impl true
  def mount(%{"company_id" => id} = params, _session, socket) when is_uuid(id) do
    company = Sources.get_company_with_positions!(id)

    if company do
      {:ok,
       assign(socket,
         company: company,
         page_title: company.name
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

  def apply_action(%{assigns: %{live_action: :edit_position}} = socket, %{
        "position_id" => position_id
      }) do
    position = Enum.find(socket.assigns.company.positions, &(&1.id == position_id))

    if position do
      assign(socket, position: position)
    else
      socket
      |> put_flash(:error, "Position not found")
      |> redirect(to: ~p"/companies/#{socket.assigns.company}")
    end
  end

  def apply_action(socket, _), do: socket

  @impl true
  def handle_event("delete_position", %{"id" => position_id}, socket) do
    position = Enum.find(socket.assigns.company.positions, &(&1.id == position_id))

    if position do
      case Applications.delete_position(position) do
        {:ok, _} ->
          socket =
            socket
            |> put_flash(:info, "Position deleted")
            |> push_navigate(to: ~p"/companies/#{socket.assigns.company.id}", replace: true)

          {:noreply, socket}

        {:error, _} ->
          {:noreply, put_flash(socket, :error, "Failed to delete position")}
      end
    else
      {:noreply, put_flash(socket, :error, "Reply not found")}
    end
  end

  defp default_position do
    %Position{
      title: "Software Engineer",
      location: "Remote",
      published_on: Date.utc_today(),
      applied_on: Date.utc_today()
    }
  end
end
