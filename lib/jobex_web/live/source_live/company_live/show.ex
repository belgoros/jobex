defmodule JobexWeb.SourceLive.CompanyLive.Show do
  use JobexWeb, :live_view

  alias Jobex.Sources

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen p-6 bg-gray-50">
      <div class="w-full max-w-2xl p-6 space-y-4 bg-white shadow-lg rounded-2xl">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">{@company.name}</h1>
            <p :if={@company.country} class="text-gray-600">Country: {@company.country}</p>
          </div>
        </div>

        <%= if @company.positions == [] do %>
          <div class="py-6 text-center">
            <p class="mb-4 text-gray-600">No open positions yet</p>
            <button class="px-4 py-2 text-white transition bg-blue-600 rounded-xl hover:bg-blue-700">
              Create New Position
            </button>
          </div>
        <% else %>
          <div>
            <h2 class="mb-2 text-lg font-semibold text-gray-800">Open Positions</h2>
            <ul class="space-y-2">
              <li
                :for={position <- @company.positions}
                class="p-4 transition bg-gray-100 rounded-xl hover:bg-gray-200"
              >
                <p class="font-medium text-gray-900">{position.title}</p>
                <p class="text-sm text-gray-600">{position.location}</p>
              </li>
            </ul>
          </div>
        <% end %>
      </div>
    </div>

    <.back navigate={~p"/companies"}>Back to companies</.back>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    company = Sources.get_company_with_positions!(id)
    company_positions = company.positions |> Enum.count()

    {:ok,
     socket
     |> assign(:page_title, "#{company.name}")
     |> assign(:company, company)
     |> assign(:company_positions, company_positions)}
  end
end
