defmodule Jobex.ApplicationsFixtures do
  import Jobex.SourcesFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jobex.Applications` context.
  """

  @doc """
  Generate a position.
  """
  def position_fixture(attrs \\ %{}) do
    company = company_fixture()

    {:ok, position} =
      attrs
      |> Enum.into(%{
        applied_on: ~D[2025-04-13],
        location: "some location",
        published_on: ~D[2025-04-13],
        title: "some title",
        company_id: company.id
      })
      |> Jobex.Applications.create_position()

    position
  end
end
