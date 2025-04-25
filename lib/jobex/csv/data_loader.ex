defmodule Jobex.Csv.DataLoader do
  require Logger

  alias Jobex.Csv.FileReader
  alias Jobex.Csv.EctoMapper

  def load(file) do
    Logger.info("Loading data from file: #{file}")

    case FileReader.read_csv(file) do
      {:ok, data} ->
        EctoMapper.map(data)
        {:ok, data}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
