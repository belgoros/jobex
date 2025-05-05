defmodule Jobex.Sources do
  @moduledoc """
  The Sources context.
  """

  import Ecto.Query, warn: false
  alias Jobex.Repo

  alias Jobex.Sources.Company

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies()
      [%Company{}, ...]

  """
  def list_companies do
    from(c in Company, order_by: [asc: c.name])
    |> Repo.all()
  end

  @doc """
  Returns a list of companies based on the given `options`.

  Example options:

  %{page: 2, per_page: 5}
  """
  def list_companies(options) when is_map(options) do
    from(c in Company, order_by: [asc: c.name])
    |> paginate(options)
    |> Repo.all()
  end

  defp paginate(query, %{page: page, per_page: per_page}) do
    offset = max((page - 1) * per_page, 0)

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  defp paginate(query, _options), do: query

  def get_company_with_positions!(id) do
    case Ecto.UUID.cast(id) do
      {:ok, uuid} -> Repo.get!(Company, uuid) |> Repo.preload(:positions)
      :error -> raise Ecto.NoResultsError, queryable: Company
    end
  end

  def company_count do
    Repo.aggregate(Company, :count, :id)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Finds a company by name or creates a new company.

  ## Examples

      iex> find_or_create_company_by_name(%{name: value, country: value})
      {:ok, %Company{}}

      iex> find_or_create_company_by_name(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def find_or_create_company_by_name(%{name: name, country: country}) do
    case Repo.get_by(Company, name: name) do
      nil ->
        %Company{name: name, country: country}
        |> Repo.insert()

      company ->
        {:ok, company}
    end
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  alias Jobex.Sources.Contact

  @doc """
  Returns the list of contacts.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

  """
  def list_contacts do
    Repo.all(Contact)
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact!(id), do: Repo.get!(Contact, id)

  @doc """
  Gets a single contact with the company.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact_with_company!(id), do: Repo.get!(Contact, id) |> Repo.preload(:company)

  @doc """
  Finds a contact by email or creates a new one.

  ## Examples

      iex> find_or_create_contact_by_email(%{email: value})
      {:ok, %Contact{}}

      iex> find_or_create_contact_by_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def find_or_create_contact_by_email(%Contact{} = contact) do
    case Repo.get_by(Contact, email: contact.email) do
      nil ->
        contact
        |> Repo.insert()

      contact ->
        {:ok, contact}
    end
  end

  def company_names_and_ids do
    query =
      from c in Company,
        order_by: :name,
        select: {c.name, c.id}

    Repo.all(query)
  end

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{data: %Contact{}}

  """
  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end
end
