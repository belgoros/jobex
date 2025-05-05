defmodule JobexWeb.CompanyLive.Index do
  use JobexWeb, :live_view

  alias Jobex.Sources

  @impl true
  def mount(_params, _session, socket) do
    # {:ok,
    # socket
    # |> assign(:page_title, "Listing Companies")
    # |> stream(:companies, Sources.list_companies())}
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "20") |> String.to_integer()

    options = %{
      page: page,
      per_page: per_page
    }

    socket =
      socket
      |> assign(
        options: options,
        page_title: "Listing Companies",
        company_count: Sources.company_count(),
        companies: Sources.list_companies(options)
      )

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Companies
    </.header>

    <.table
      id="companies"
      rows={@companies}
      row_click={fn company -> JS.navigate(~p"/companies/#{company}") end}
    >
      <:col :let={company} label="Name">{company.name}</:col>
      <:col :let={company} label="Country">{company.country}</:col>
    </.table>

    <div class="footer">
      <div class="pagination">
        <.link
          :for={{page_number, current_page?} <- pages(@options, @company_count)}
          class={if current_page?, do: "active"}
          patch={~p"/companies?#{%{@options | page: page_number}}"}
        >
          {page_number}
        </.link>
      </div>
    </div>
    """
  end

  # defp more_pages?(options, company_count) do
  #  options.page * options.per_page < company_count
  # end

  defp pages(options, company_count) do
    page_count = ceil(company_count / options.per_page)

    for page_number <- (options.page - 2)..(options.page + 2),
        page_number > 0 do
      if page_number <= page_count do
        current_page? = page_number == options.page
        {page_number, current_page?}
      end
    end
  end
end
