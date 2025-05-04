defmodule Jobex.Csv.EctoMapper do
  alias Jobex.Sources
  alias Jobex.Sources.Contact

  def map(data_rows) do
    data_rows
    |> Enum.each(&map_entry_row/1)
  end

  defp map_entry_row(row) do
    [company_name, full_name, email, _applied_on, _replied_with] = row

    with {:ok, company} <- create_company(company_name),
         {:ok, contact} <- create_contact(full_name, email, company.id),
         do: {:ok, company: company, contact: contact}
  end

  defp create_company(name, country \\ "remote") do
    Sources.find_or_create_company_by_name(%{name: name, country: country})
  end

  defp create_contact(full_name, email, company_id) do
    [first_name | last_names] =
      full_name
      |> String.split(" ")

    Sources.find_or_create_contact_by_email(%Contact{
      first_name: first_name,
      last_name: Enum.join(last_names, " "),
      email: email,
      company_id: company_id
    })
  end
end
