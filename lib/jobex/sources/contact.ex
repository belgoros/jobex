defmodule Jobex.Sources.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    belongs_to :company, Jobex.Sources.Company

    timestamps(type: :utc_datetime)
  end

  @accepted_attributes [
    :first_name,
    :last_name,
    :email,
    :company_id
  ]

  @required_attributes [
    :first_name,
    :last_name,
    :email,
    :company_id
  ]

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, @accepted_attributes)
    |> validate_required(@required_attributes)
    |> unique_constraint(:email)
    |> assoc_constraint(:company)
  end
end
