defmodule Jobex.Csv.FileReader do
  def read_csv(file_path) do
    try do
      data =
        file_path
        |> File.stream!()
        # Skip the header
        |> Stream.drop(1)
        |> Stream.map(&parse_line/1)
        |> Enum.to_list()

      {:ok, data}
    rescue
      _ -> {:error, "Failed to access to the file: " <> file_path}
    end
  end

  defp parse_line(line) do
    line
    # Remove newline characters
    |> String.trim()
    # Split by semicolon
    |> String.split(";")
  end
end
