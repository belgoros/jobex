defmodule Jobex.Applications.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "replies" do
    field :date, :date
    field :feedback, :string
    field :go_forward, :boolean, default: false
    belongs_to :position, Jobex.Applications.Position

    timestamps(type: :utc_datetime)
  end

  @accepted_attributes [:date, :feedback, :go_forward, :position_id]
  @required_attributed [:date, :feedback, :go_forward, :position_id]
  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, @accepted_attributes)
    |> validate_required(@required_attributed)
    |> assoc_constraint(:position)
  end
end
