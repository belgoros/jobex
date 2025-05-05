defmodule Jobex.Csv.EctoMapper do
  alias Jobex.Sources
  alias Jobex.Sources.Contact
  alias Jobex.Applications

  def map(data_rows) do
    data_rows
    |> Enum.each(&map_entry_row/1)
  end

  defp map_entry_row(row) do
    [
      company,
      contact_person,
      email,
      position_title,
      location,
      applied_on,
      go_forward,
      feedback
    ] =
      row

    with {:ok, company} <- create_company(company),
         {:ok, _contact} <- maybe_create_contact(contact_person, email, company.id),
         {:ok, position} <-
           maybe_create_position(position_title, location, company.id, applied_on),
         {:ok, reply} <- create_reply(position.id, go_forward, feedback),
         do: {:ok, reply}
  end

  defp create_reply(position_id, go_forward, feedback) do
    attrs = %{
      date: Date.utc_today(),
      position_id: position_id,
      go_forward: map_go_forward(go_forward),
      feedback: feedback
    }

    Applications.create_reply(attrs)
  end

  defp maybe_create_position(position_title, location, company_id, applied_on)
       when position_title == "" and location == "" do
    create_position("Interest in Elixir Engineer Position", "Remote", company_id, applied_on)
  end

  defp maybe_create_position(position_title, location, company_id, applied_on)
       when position_title == "" do
    create_position("Interest in Elixir Engineer Position", location, company_id, applied_on)
  end

  defp maybe_create_position(position_title, location, company_id, applied_on)
       when location == "" do
    create_position(position_title, "Remote", company_id, applied_on)
  end

  defp create_position(
         position_title,
         location,
         company_id,
         applied_on
       ) do
    attrs = %{
      title: position_title,
      location: location,
      applied_on: convert_to_iso_date(applied_on),
      published_on: convert_to_iso_date(applied_on),
      company_id: company_id
    }

    Applications.create_position(attrs)
  end

  defp convert_to_iso_date(date_as_string) do
    with [day, month, year] <- String.split(date_as_string, "/"),
         {month, ""} <- Integer.parse(month),
         {day, ""} <- Integer.parse(day),
         {year, ""} <- Integer.parse(year),
         {:ok, date} <- Date.new(year, month, day) do
      date
    end
  end

  defp create_company(name, country \\ "remote") do
    Sources.find_or_create_company_by_name(%{name: name, country: country})
  end

  defp map_go_forward(go_forward) when go_forward == "", do: false
  defp map_go_forward(go_forward) when go_forward == "No", do: false
  defp map_go_forward(_), do: true

  defp maybe_create_contact("", _, _), do: {:ok, nil}
  defp maybe_create_contact(_, "", _), do: {:ok, nil}
  defp maybe_create_contact(name, email, company_id), do: create_contact(name, email, company_id)

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
