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
    company = Map.get(attrs, :company) || company_fixture()

    {:ok, position} =
      attrs
      |> Enum.into(%{
        applied_on: ~D[2025-04-13],
        location: "some location",
        published_on: ~D[2025-04-13],
        title: "some title",
        company_id: company.id
      })
      # Prevent passing :company as an unexpected key
      |> Map.delete(:company)
      |> Jobex.Applications.create_position()

    position
  end

  @doc """
  Generate a reply.
  """
  def reply_fixture(attrs \\ %{}) do
    position = position_fixture()

    {:ok, reply} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-04-13],
        feedback: "some feedback",
        go_forward: true,
        position_id: position.id
      })
      |> Jobex.Applications.create_reply()

    reply
  end
end
