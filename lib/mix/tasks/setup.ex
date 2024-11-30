defmodule Mix.Tasks.Setup do
  @moduledoc """
  Sets up the initial structure for a new puzzle, including templates and first description
  """
  use Mix.Task

  alias AdventOfCode.Template
  alias AdventOfCode.Utils

  @impl Mix.Task
  def run([year, day]) do
    Utils.setup_env!()

    base_path = Utils.get_base_path(year, day)
    File.mkdir_p!(base_path)

    test_path = Utils.get_test_path(year, day)
    File.mkdir_p!(test_path)

    create_files(base_path, test_path, year, day)
    download_files(base_path, year, day)
  end

  defp create_files(base_path, test_path, year, day) do
    # Create solution file
    content = Template.build_solution(year, day)
    File.write!("#{base_path}/solution.ex", content)
    Mix.shell().info("Created solution template")

    # Create test file
    content = Template.build_test(year, day)
    File.write!("#{test_path}/solution_test.exs", content)
    Mix.shell().info("Created test template")
  end

  defp download_files(base_path, year, day) do
    # Download input
    case download_input(year, day) do
      {:ok, content} ->
        File.write!("#{base_path}/input.txt", content)
        Mix.shell().info("Downloaded input")

      {:error, reason} ->
        Mix.shell().error("Failed to fetch input - #{reason}")
    end

    # Download first description
    case Utils.download_description(year, day, 1) do
      {:ok, content} ->
        File.write!("#{base_path}/part1.md", content)
        Mix.shell().info("Downloaded part 1 description")

      {:error, reason} ->
        Mix.shell().error("Failed to fetch description - #{reason}")
    end
  end

  defp download_input(year, day) do
    url = "https://adventofcode.com/#{year}/day/#{day}/input"
    Utils.http_get(url)
  end
end
