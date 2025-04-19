# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jobex.Repo.insert!(%Jobex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeder do
  alias Jobex.Repo
  alias Jobex.Sources.Company
  alias Jobex.Applications.Position

  @job_titles [
    "Front-End Engineer",
    "Elixir developer",
    "Senior Java developer",
    "DevOps engineer",
    "Ruby Engineer"
  ]

  @locations ["Remote", "On-Site", "Hybrid"]

  def run() do
    Repo.delete_all(Company)

    create_companies()
    |> Enum.each(fn company -> create_position_for(company) end)
  end

  def create_companies do
    for _ <- 1..5 do
      %Company{
        name: Faker.Company.En.name(),
        country: Faker.Address.country()
      }
      |> Repo.insert!()
    end
  end

  def create_positions(companies) do
    Enum.each(
      companies,
      &create_position_for(&1)
    )
  end

  defp create_position_for(company) do
    Enum.each(
      1..3,
      fn _ ->
        %Position{
          company_id: company.id,
          title: Enum.random(@job_titles),
          location: Enum.random(@locations),
          published_on: Faker.Date.backward(4),
          applied_on: Faker.Date.backward(2)
        }
        |> Repo.insert!()
      end
    )
  end
end

Seeder.run()
