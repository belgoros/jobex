defmodule JobexWeb.CompanyLive.Index do
  use JobexWeb, :live_view

  alias Jobex.Sources
  alias Jobex.Sources.Company

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
      |> assign(options: options)
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :edit_company, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Sources.get_company!(id))
  end

  defp apply_action(socket, :new_company, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
    |> assign(:company_count, Sources.company_count())
    |> assign(:companies, Sources.list_companies(socket.assigns.options))
  end

  @impl true
  def handle_info({JobexWeb.CompanyLive.FormComponent, {:saved, company}}, socket) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Sources.get_company!(id)
    {:ok, _} = Sources.delete_company(company)

    socket =
      socket
      |> put_flash(:info, "Company deleted successfully")
      |> assign(:company_count, Sources.company_count())
      |> assign(:companies, Sources.list_companies(socket.assigns.options))

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
