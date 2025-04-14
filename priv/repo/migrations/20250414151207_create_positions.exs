defmodule Jobex.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :location, :string
      add :published_on, :date
      add :applied_on, :date

      add :company_id, references(:companies, on_delete: :delete_all, type: :binary_id),
        null: false

      timestamps(type: :utc_datetime)
    end

    create index(:positions, [:company_id])
  end
end
