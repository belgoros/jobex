defmodule JobexWeb.CompanyLiveTest do
  use JobexWeb.ConnCase
  import Phoenix.LiveViewTest
  import Jobex.SourcesFixtures
  import Jobex.ApplicationsFixtures

  defp create_company(_) do
    company = company_fixture()
    %{company: company}
  end

  describe "Index" do
    setup [:create_company]

    test "lists all companies", %{conn: conn, company: company} do
      {:ok, _index_live, html} = live(conn, ~p"/companies")

      assert html =~ "Listing Companies"
      assert html =~ company.name
    end
  end

  describe "Show" do
    setup [:create_company]

    test "displays company without positions", %{conn: conn, company: company} do
      {:ok, _show_live, html} = live(conn, ~p"/companies/#{company}")

      assert html =~ "Country"
      assert html =~ company.name
      assert html =~ "No open positions yet"
    end

    test "displays company with open positions", %{
      conn: conn,
      company: company
    } do
      position = position_fixture(%{company: company})
      {:ok, _show_live, html} = live(conn, ~p"/companies/#{company}")

      assert html =~ "Country"
      assert html =~ company.name
      assert html =~ position.title
    end
  end
end
