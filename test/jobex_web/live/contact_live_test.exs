defmodule JobexWeb.ContactLiveTest do
  use JobexWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jobex.SourcesFixtures

  @create_attrs %{
    "company_id" => nil,
    "email" => "test@example.com",
    "first_name" => "Some first name",
    "last_name" => "Some last name"
  }

  @update_attrs %{
    "company_id" => nil,
    "email" => "updated-test@example.com",
    "first_name" => "updated first name",
    "last_name" => "updated last name"
  }

  @invalid_attrs %{
    "company_id" => nil,
    "email" => nil,
    "first_name" => nil,
    "last_name" => nil
  }

  defp create_contact(_) do
    contact = contact_fixture()
    %{contact: contact}
  end

  def create_company(_) do
    company = company_fixture()
    %{company: company}
  end

  describe "Index" do
    setup [:create_contact, :create_company]

    test "lists all contacts", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/contacts")

      assert html =~ "Listing Contacts"
    end

    test "saves new contact", %{conn: conn, company: company} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Contact")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/new")

      assert render(form_live) =~ "New Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#contact-form", contact: %{@create_attrs | "company_id" => company.id})
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact created successfully"
      assert html =~ "Some first name"
    end

    test "updates contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#contacts-#{contact.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/#{contact}/edit")

      assert render(form_live) =~ "Edit Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#contact-form",
                 contact: %{@update_attrs | "company_id" => contact.company_id}
               )
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact updated successfully!"
      assert html =~ "updated last name"
    end

    test "deletes contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert index_live |> element("#contacts-#{contact.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#contacts-#{contact.id}")
    end
  end

  describe "Show" do
    setup [:create_contact]

    test "displays contact", %{conn: conn, contact: contact} do
      {:ok, _show_live, html} = live(conn, ~p"/contacts/#{contact}")

      assert html =~ "Show Contact"
      assert html =~ contact.first_name
    end

    test "updates contact and returns to contacts", %{conn: conn, contact: contact} do
      {:ok, show_live, _html} = live(conn, ~p"/contacts/#{contact}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/#{contact}/edit")

      assert render(form_live) =~ "Edit Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#contact-form",
                 contact: %{@update_attrs | "company_id" => contact.company_id}
               )
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(show_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "updated last name"
    end
  end
end
