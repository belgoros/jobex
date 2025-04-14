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

  describe "replies" do
    alias Jobex.Applications.Reply

    import Jobex.ApplicationsFixtures

    @invalid_attrs %{date: nil, feedback: nil, go_forward: nil}

    test "list_replies/0 returns all replies" do
      reply = reply_fixture()
      assert Applications.list_replies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert Applications.get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      position = position_fixture()

      valid_attrs = %{
        date: ~D[2025-04-13],
        feedback: "some feedback",
        go_forward: true,
        position_id: position.id
      }

      assert {:ok, %Reply{} = reply} = Applications.create_reply(valid_attrs)
      assert reply.date == ~D[2025-04-13]
      assert reply.feedback == "some feedback"
      assert reply.go_forward == true
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      update_attrs = %{date: ~D[2025-04-14], feedback: "some updated feedback", go_forward: false}

      assert {:ok, %Reply{} = reply} = Applications.update_reply(reply, update_attrs)
      assert reply.date == ~D[2025-04-14]
      assert reply.feedback == "some updated feedback"
      assert reply.go_forward == false
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_reply(reply, @invalid_attrs)
      assert reply == Applications.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{}} = Applications.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = Applications.change_reply(reply)
    end
  end
end
