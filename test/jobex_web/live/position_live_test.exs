defmodule JobexWeb.PositionLiveTest do
  use JobexWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jobex.ApplicationsFixtures
  import Jobex.SourcesFixtures

  @create_attrs %{
    location: "some location",
    title: "some title",
    published_on: "2025-04-26",
    applied_on: "2025-04-26",
    company_id: nil
  }
  @update_attrs %{
    location: "some updated location",
    title: "some updated title",
    published_on: "2025-04-27",
    applied_on: "2025-04-27",
    company_id: nil
  }
  @invalid_attrs %{location: nil, title: nil, published_on: nil, applied_on: nil}

  defp create_position(_) do
    position = position_fixture()
    %{position: position}
  end

  def create_company(_) do
    company = company_fixture()
    %{company: company}
  end

  describe "Index" do
    setup [:create_position, :create_company]

    test "lists all positions", %{conn: conn, position: position} do
      {:ok, _index_live, html} = live(conn, ~p"/positions")

      assert html =~ "Listing Positions"
      assert html =~ position.location
    end

    test "saves new position", %{conn: conn, company: company} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      assert index_live |> element("a", "New Position") |> render_click() =~
               "New Position"

      assert_patch(index_live, ~p"/positions/new")

      assert index_live
             |> form("#position-form", position: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#position-form", position: %{@create_attrs | company_id: company.id})
             |> render_submit()

      assert_patch(index_live, ~p"/positions")

      html = render(index_live)
      assert html =~ "Position created successfully"
      assert html =~ "some location"
    end

    test "updates position in listing", %{conn: conn, position: position} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      assert index_live |> element("#positions-#{position.id} a", "Edit") |> render_click() =~
               "Edit Position"

      assert_patch(index_live, ~p"/positions/#{position}/edit")

      assert index_live
             |> form("#position-form", position: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#position-form",
               position: %{@update_attrs | company_id: position.company_id}
             )
             |> render_submit()

      assert_patch(index_live, ~p"/positions")

      html = render(index_live)
      assert html =~ "Position updated successfully"
      assert html =~ "some updated location"
    end

    test "deletes position in listing", %{conn: conn, position: position} do
      {:ok, index_live, _html} = live(conn, ~p"/positions")

      assert index_live |> element("#positions-#{position.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#positions-#{position.id}")
    end
  end

  describe "Show" do
    setup [:create_position]

    test "displays position", %{conn: conn, position: position} do
      {:ok, _show_live, html} = live(conn, ~p"/positions/#{position}")

      assert html =~ "Show Position"
      assert html =~ position.location
    end

    test "updates position within modal", %{conn: conn, position: position} do
      {:ok, show_live, _html} = live(conn, ~p"/positions/#{position}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Position"

      assert_patch(show_live, ~p"/positions/#{position}/show/edit")

      assert show_live
             |> form("#position-form", position: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#position-form",
               position: %{@update_attrs | company_id: position.company_id}
             )
             |> render_submit()

      assert_patch(show_live, ~p"/positions/#{position}")

      html = render(show_live)
      assert html =~ "Position updated successfully"
      assert html =~ "some updated location"
    end
  end
end
