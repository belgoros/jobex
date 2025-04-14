defmodule Jobex.ApplicationsTest do
  use Jobex.DataCase

  alias Jobex.Applications

  describe "positions" do
    alias Jobex.Applications.Position

    import Jobex.ApplicationsFixtures
    import Jobex.SourcesFixtures

    @invalid_attrs %{title: nil, location: nil, published_on: nil, applied_on: nil}

    test "list_positions/0 returns all positions" do
      position = position_fixture()
      assert Applications.list_positions() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Applications.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      company = company_fixture()

      valid_attrs = %{
        title: "some title",
        location: "some location",
        published_on: ~D[2025-04-13],
        applied_on: ~D[2025-04-13],
        company_id: company.id
      }

      assert {:ok, %Position{} = position} = Applications.create_position(valid_attrs)
      assert position.title == "some title"
      assert position.location == "some location"
      assert position.published_on == ~D[2025-04-13]
      assert position.applied_on == ~D[2025-04-13]
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()

      update_attrs = %{
        title: "some updated title",
        location: "some updated location",
        published_on: ~D[2025-04-14],
        applied_on: ~D[2025-04-14]
      }

      assert {:ok, %Position{} = position} = Applications.update_position(position, update_attrs)
      assert position.title == "some updated title"
      assert position.location == "some updated location"
      assert position.published_on == ~D[2025-04-14]
      assert position.applied_on == ~D[2025-04-14]
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_position(position, @invalid_attrs)
      assert position == Applications.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Applications.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Applications.change_position(position)
    end
  end
end
