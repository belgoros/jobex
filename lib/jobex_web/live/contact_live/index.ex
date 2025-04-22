defmodule JobexWeb.ContactLive.Index do
  use JobexWeb, :live_view

  alias Jobex.Sources
  alias Jobex.Sources.Contact

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :contacts, Sources.list_contacts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:contact, Sources.get_contact!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Contact")
    |> assign(:contact, %Contact{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Contacts")
    |> assign(:contact, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = Sources.get_contact!(id)
    {:ok, _} = Sources.delete_contact(contact)

    {:noreply, stream_delete(socket, :contacts, contact)}
  end
end
