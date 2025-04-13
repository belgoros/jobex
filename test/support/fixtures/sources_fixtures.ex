defmodule Jobex.SourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jobex.Sources` context.
  """

  @doc """
  Generate a unique category name.
  """
  def unique_company_name, do: "company-#{System.unique_integer([:positive])}"

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: unique_company_name()
      })
      |> Jobex.Sources.create_company()

    company
  end
end
