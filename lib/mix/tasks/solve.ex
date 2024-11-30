defmodule Mix.Tasks.Solve do
  @moduledoc """
  Runs solution and optionally submits it, downloading part 2 description if part 1 succeeds
  """
  use Mix.Task
  alias AdventOfCode.Utils

  @valid_parts [:part1, :part2]

  @impl Mix.Task
  def run(args) do
    {opts, [year, day, part], _} =
      OptionParser.parse(args,
        switches: [submit: :boolean],
        aliases: [s: :submit]
      )

    Utils.setup_env!()
    result = execute_solution(year, day, part)

    case result do
      nil ->
        :ok

      result ->
        display_result(year, day, part, result)
        if opts[:submit], do: handle_submission(year, day, part, result)
    end
  end

  defp execute_solution(year, day, part) do
    base_path = Utils.get_base_path(year, day)
    input = File.read!("#{base_path}/input.txt")

    try do
      module =
        Module.safe_concat([
          "AdventOfCode",
          "Year#{year}",
          "Day#{String.to_integer(day)}",
          "Solution"
        ])

      function = :"part#{part}"

      if function in @valid_parts do
        apply(module, function, [input])
      else
        Mix.shell().error("Invalid part number: #{part}")
        nil
      end
    rescue
      error in [ArgumentError, UndefinedFunctionError] ->
        Mix.shell().error("Error: #{Exception.message(error)}")
        nil
    end
  end

  defp display_result(year, day, part, result) do
    Mix.shell().info("Solution for Year #{year} Day #{day} Part #{part}: #{result}")
  end

  defp handle_submission(_year, _day, _part, result) when is_nil(result) do
    Mix.shell().error("Cannot submit nil result")
  end

  defp handle_submission(year, day, part, result) do
    case submit_solution(year, day, part, result) do
      {:ok, message} ->
        Mix.shell().info("\nSubmission response:\n#{message}")
        maybe_download_part2(year, day, part)

      {:error, message} ->
        Mix.shell().error("\nSubmission failed:\n#{message}")
    end
  end

  defp submit_solution(year, day, part, answer) do
    url = "https://adventofcode.com/#{year}/day/#{day}/answer"
    body = URI.encode_query(%{level: part, answer: answer})

    with {:ok, response_body} <- Utils.http_post(url, body),
         {:ok, document} <- Floki.parse_document(response_body) do
      message =
        document
        |> Floki.find("article")
        |> Floki.text()
        |> String.trim()

      if String.contains?(message, "That's the right answer") do
        {:ok, message}
      else
        {:error, message}
      end
    end
  end

  defp maybe_download_part2(year, day, "1") do
    base_path = Utils.get_base_path(year, day)

    if Mix.shell().yes?("\nWould you like to download part 2 description?") do
      case Utils.download_description(year, day, 2) do
        {:ok, content} ->
          File.write!("#{base_path}/part2.md", content)
          Mix.shell().info("Downloaded part 2 description")

        {:error, reason} ->
          Mix.shell().error("Failed to fetch part 2 description - #{reason}")
      end
    end
  end

  defp maybe_download_part2(_, _, _), do: :ok
end
