defmodule Mix.Tasks.Import.Csv.Data do
  require Logger

  @moduledoc """
    This task imports CSV data into the application.

    Usage:
      mix import.csv.data path/to/file.csv

    Example:
      mix import.csv.data data/users.csv
  """
  use Mix.Task

  alias Jobex.Csv.DataLoader

  @shortdoc "Calls the DataLoader.load/1 function."
  @impl Mix.Task
  def run(args) do
    # This will start our application
    Mix.Task.run("app.start")

    result = DataLoader.load(Enum.join(args))

    case result do
      {:ok, data} -> Logger.info("Data loaded successfully: #{Enum.count(data)} rows processed")
      {:error, reason} -> Logger.warning(reason)
    end
  end
end
