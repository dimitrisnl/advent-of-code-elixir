defmodule Mix.Tasks.Download do
  use Mix.Task
  alias AdventOfCode.Utils

  @shortdoc "Downloads puzzle input and descriptions"
  @impl Mix.Task
  def run([year, day]) do
    Utils.setup_env!()
    base_path = Utils.get_base_path(year, day)
    File.mkdir_p!(base_path)

    download_input(base_path, year, day)
    download_descriptions(base_path, year, day)
    create_solution_file(base_path, year, day)
  end

  defp download_input(base_path, year, day) do
    url = "https://adventofcode.com/#{year}/day/#{day}/input"

    case Utils.http_get(url) do
      {:ok, body} ->
        File.write!("#{base_path}/input.txt", body)
        Mix.shell().info("Downloaded input")

      {:error, reason} ->
        Mix.shell().error("Failed to fetch input - #{reason}")
    end
  end

  defp download_descriptions(base_path, year, day) do
    url = "https://adventofcode.com/#{year}/day/#{day}"

    with {:ok, body} <- Utils.http_get(url),
         {:ok, document} <- Floki.parse_document(body) do
      document
      |> Floki.find("article.day-desc")
      |> Enum.with_index(1)
      |> Enum.each(fn {article, i} ->
        content = article |> Floki.text() |> String.trim()
        File.write!("#{base_path}/part#{i}.md", content)
      end)

      Mix.shell().info("Downloaded descriptions")
    else
      {:error, reason} ->
        Mix.shell().error("Failed to fetch descriptions - #{reason}")
    end
  end

  defp create_solution_file(base_path, year, day) do
    content = AdventOfCode.Template.build_solution(year, day)
    File.write!("#{base_path}/solution.ex", content)
    Mix.shell().info("Created solution template")
  end
end
