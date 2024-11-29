defmodule Mix.Tasks.Solve do
  @moduledoc """
  Runs and optionally submits solution for specified year, day, and part
  """
  use Mix.Task
  alias AdventOfCode.Utils

  @impl Mix.Task
  def run(args) do
    {opts, [year, day, part], _} =
      OptionParser.parse(args,
        switches: [submit: :boolean],
        aliases: [s: :submit]
      )

    Utils.setup_env!()
    base_path = Utils.get_base_path(year, day)
    input = File.read!("#{base_path}/input.txt")

    module = Module.concat(["AdventOfCode", "Year#{year}", "Day#{String.to_integer(day)}"])
    function = String.to_atom("part#{part}")

    result = apply(module, function, [input])
    IO.puts("Solution for Year #{year} Day #{day} Part #{part}: #{result}")

    if opts[:submit] do
      submit_solution(year, day, part, result)
    end
  end

  defp submit_solution(year, day, part, answer) do
    url = "https://adventofcode.com/#{year}/day/#{day}/answer"
    body = URI.encode_query(%{level: part, answer: answer})

    case Utils.http_post(url, body) do
      {:ok, response_body} ->
        {:ok, document} = Floki.parse_document(response_body)
        message = document |> Floki.find("article") |> Floki.text() |> String.trim()
        IO.puts("\nSubmission response:\n#{message}")

      {:error, reason} ->
        Mix.shell().error("Failed to submit - #{reason}")
    end
  end
end
