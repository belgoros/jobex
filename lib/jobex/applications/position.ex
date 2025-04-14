defmodule Jobex.Applications.Position do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "positions" do
    field :title, :string
    field :location, :string
    field :published_on, :date
    field :applied_on, :date
    belongs_to :company, Jobex.Sources.Company

    timestamps(type: :utc_datetime)
  end

  @accepted_attributes [:title, :location, :published_on, :applied_on, :company_id]
  @required_attributed [:title, :location, :published_on, :applied_on, :company_id]
  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, @accepted_attributes)
    |> validate_required(@required_attributed)
    |> assoc_constraint(:company)
  end
end
