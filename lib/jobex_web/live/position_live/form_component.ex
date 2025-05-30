defmodule JobexWeb.PositionLive.FormComponent do
  use JobexWeb, :live_component

  alias Jobex.Applications
  alias Jobex.Sources

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@page_title}
      </.header>

      <.simple_form
        for={@form}
        id="position-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input
          field={@form[:company_id]}
          type="select"
          label="Company"
          prompt="Choose a company"
          options={@company_options}
        />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:published_on]} type="date" label="Published on" />
        <.input field={@form[:applied_on]} type="date" label="Applied on" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Position</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{position: position} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:company_options, Sources.company_names_and_ids())
     |> assign_new(:form, fn ->
       to_form(Applications.change_position(position))
     end)}
  end

  @impl true
  def handle_event("validate", %{"position" => position_params}, socket) do
    changeset = Applications.change_position(socket.assigns.position, position_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"position" => position_params}, socket) do
    save_position(socket, socket.assigns.action, position_params)
  end

  defp save_position(socket, :edit, position_params) do
    case Applications.update_position(socket.assigns.position, position_params) do
      {:ok, position} ->
        notify_parent({:saved, position})

        {:noreply,
         socket
         |> put_flash(:info, "Position updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_position(socket, :new, position_params) do
    case Applications.create_position(position_params) do
      {:ok, position} ->
        notify_parent({:saved, position})

        {:noreply,
         socket
         |> put_flash(:info, "Position created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
