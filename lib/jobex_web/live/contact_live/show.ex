defmodule JobexWeb.ContactLive.Show do
  alias Jobex.Sources
  use JobexWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Contact {@contact.id}
      <:subtitle>This is a Contact record from your database.</:subtitle>
      <:actions>
        <.button phx-click={JS.dispatch("click", to: {:inner, "a"})}>
          <.link navigate={~p"/contacts/#{@contact}/edit"} class="button">
            Edit contact
          </.link>
        </.button>
      </:actions>
    </.header>

    <.list>
      <:item title="First Name">{@contact.first_name}</:item>
      <:item title="Last Name">{@contact.last_name}</:item>
      <:item title="Email">{@contact.email}</:item>
      <:item title="Company">{@contact.company.name}</:item>
    </.list>

    <.back navigate={~p"/contacts"}>Back to contacts</.back>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Contact")
     |> assign(:contact, Sources.get_contact_with_company!(id))}
  end
end
