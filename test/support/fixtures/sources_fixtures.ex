defmodule Jobex.SourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jobex.Sources` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: Faker.Company.En.name()
      })
      |> Jobex.Sources.create_company()

    company
  end

  @doc """
  Generate a unique contact email.
  """
  def unique_contact_email, do: "some-email#{System.unique_integer([:positive])}@example.com"

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    company = company_fixture()

    {:ok, contact} =
      attrs
      |> Enum.into(%{
        email: unique_contact_email(),
        first_name: Faker.Person.first_name(),
        last_name: Faker.Person.last_name(),
        company_id: company.id
      })
      |> Jobex.Sources.create_contact()

    contact
  end
end
