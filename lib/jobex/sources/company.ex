defmodule Jobex.Sources.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :country, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :country])
    |> validate_required([:name])
    |> validate_length(:name, max: 160)
    |> unique_constraint(:name)
  end
end
