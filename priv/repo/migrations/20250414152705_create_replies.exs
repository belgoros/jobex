defmodule Jobex.Repo.Migrations.CreateReplies do
  use Ecto.Migration

  def change do
    create table(:replies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :feedback, :string
      add :go_forward, :boolean, default: false, null: false

      add :position_id, references(:positions, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:replies, [:position_id])
  end
end
