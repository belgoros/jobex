defmodule JobexWeb.SourceLive.CompanyLive.Show do
  use JobexWeb, :live_view

  alias Jobex.Sources

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      {@company.name}
      <:subtitle>This is a company record from your database.</:subtitle>
    </.header>

    <.list>
      <:item title="Name">{@company.name}</:item>
      <:item title="Country">{@company.country}</:item>
    </.list>
    <section :if={@company.positions != []} class="mt-12">
      <h4>Positions</h4>
      <ul class="positions">
        <li :for={position <- @company.positions}>{position.title}</li>
      </ul>
    </section>

    <.back navigate={~p"/companies"}>Back to companies</.back>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Company")
     |> assign(:company, Sources.get_company_with_positions!(id))}
  end
end
