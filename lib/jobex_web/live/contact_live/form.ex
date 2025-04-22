defmodule JobexWeb.ContactLive.Form do
  alias Jobex.Sources.Contact
  alias Jobex.Sources
  use JobexWeb, :live_view

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:company_options, Sources.company_names_and_ids())
      |> apply_action(socket.assigns.live_action, params)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form for={@form} id="contact-form" phx-submit="save" phx-change="validate">
      <.input field={@form[:first_name]} required label="First name" />
      <.input field={@form[:last_name]} required label="Last name" />
      <.input field={@form[:email]} type="email" required label="Email" />

      <.input
        field={@form[:company_id]}
        type="select"
        label="Company"
        prompt="Choose a company"
        options={@company_options}
      />
      <:actions>
        <.button phx-disable-with="Saving...">Save Contact</.button>
      </:actions>
    </.simple_form>
    <.back navigate={~p"/contacts"}>
      Back
    </.back>
    """
  end

  defp apply_action(socket, :new, _params) do
    contact = %Contact{}
    changeset = Sources.change_contact(contact)

    socket
    |> assign(:page_title, "New Contact")
    |> assign(:form, to_form(changeset))
    |> assign(:contact, contact)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    contact = Sources.get_contact_with_company!(id)

    changeset = Sources.change_contact(contact)

    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:form, to_form(changeset))
    |> assign(:contact, contact)
  end

  def handle_event("save", %{"contact" => contact_params}, socket) do
    save_contact(socket, socket.assigns.live_action, contact_params)
  end

  def handle_event("validate", %{"contact" => contact_params}, socket) do
    changeset = Sources.change_contact(socket.assigns.contact, contact_params)

    socket = assign(socket, :form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  defp save_contact(socket, :new, contact_params) do
    case Sources.create_contact(contact_params) do
      {:ok, _contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact created successfully!")
          |> push_navigate(to: ~p"/contacts")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end

  defp save_contact(socket, :edit, contact_params) do
    case Sources.update_contact(socket.assigns.contact, contact_params) do
      {:ok, _contact} ->
        socket =
          socket
          |> put_flash(:info, "Contact updated successfully!")
          |> push_navigate(to: ~p"/contacts")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> assign(:form, to_form(changeset))

        {:noreply, socket}
    end
  end
end
