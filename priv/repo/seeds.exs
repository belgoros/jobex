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
alias Jobex.Repo
alias Jobex.Sources.Company

Repo.delete_all(Company)

Enum.each(1..5, fn _ ->
  %Company{
    name: Faker.Company.bs() |> String.upcase(),
    country: Faker.Address.country()
  }
  |> Repo.insert!()
end)
