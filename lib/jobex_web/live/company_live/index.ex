defmodule JobexWeb.CompanyLive.Index do
  use JobexWeb, :live_view

  alias Jobex.Sources

  @impl true
  def mount(_params, _session, socket) do
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
