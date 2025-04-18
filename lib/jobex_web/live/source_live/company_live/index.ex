defmodule JobexWeb.SourceLive.CompanyLive.Index do
  use JobexWeb, :live_view

  alias Jobex.Sources

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Companies")
     |> stream(:companies, Sources.list_companies())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Companies
    </.header>

    <.table
      id="companies"
      rows={@streams.companies}
      row_click={fn {_id, company} -> JS.navigate(~p"/companies/#{company}") end}
    >
      <:col :let={{_id, company}} label="Name">{company.name}</:col>
      <:col :let={{_id, company}} label="Country">{company.country}</:col>
    </.table>
    """
  end
end
