defmodule Jobex.SourcesTest do
  use Jobex.DataCase

  alias Jobex.Sources

  describe "companies" do
    alias Jobex.Sources.Company

    import Jobex.SourcesFixtures

    @invalid_attrs %{name: nil, country: nil}

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Sources.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Sources.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", country: "some country"}

      assert {:ok, %Company{} = company} = Sources.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.country == "some country"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sources.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", country: "some updated country"}

      assert {:ok, %Company{} = company} = Sources.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.country == "some updated country"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Sources.update_company(company, @invalid_attrs)
      assert company == Sources.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Sources.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Sources.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Sources.change_company(company)
    end
  end

  describe "contacts" do
    alias Jobex.Sources.Contact

    import Jobex.SourcesFixtures

    @invalid_attrs %{first_name: nil, last_name: nil, email: nil}

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Sources.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Sources.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      company = company_fixture()

      valid_attrs = %{
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some email",
        company_id: company.id
      }

      assert {:ok, %Contact{} = contact} = Sources.create_contact(valid_attrs)
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.email == "some email"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sources.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()

      update_attrs = %{
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        email: "some updated email"
      }

      assert {:ok, %Contact{} = contact} = Sources.update_contact(contact, update_attrs)
      assert contact.first_name == "some updated first_name"
      assert contact.last_name == "some updated last_name"
      assert contact.email == "some updated email"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Sources.update_contact(contact, @invalid_attrs)
      assert contact == Sources.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Sources.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Sources.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Sources.change_contact(contact)
    end
  end
end
