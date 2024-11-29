defmodule AdventOfCode.Template do
  @moduledoc """
  Template content for solution and test files
  """
  def build_solution(year, day) do
    """
    defmodule AdventOfCode.Year#{year}.Day#{day} do
      def part1(input) do
        input
        |> parse(:lines)
        |> solve_part1()
      end

      def part2(input) do
        input
        |> parse(:lines)
        |> solve_part2()
      end

      defp solve_part1(input) do

      end

      defp solve_part2(input) do

      end

      defp parse(input, :lines), do: String.split(input, "\n", trim: true)
      defp parse(input, :numbers), do: input |> parse(:lines) |> Enum.map(&String.to_integer/1)
      defp parse(input, :csv), do: input |> String.trim() |> String.split(",")
      defp parse(input, :grid), do: input |> parse(:lines) |> Enum.map(&String.graphemes/1)
    end
    """
  end

  def build_test(year, day) do
    """
    defmodule AdventOfCode.Year#{year}.Day#{day}Test do
      use ExUnit.Case
      alias AdventOfCode.Year#{year}.Day#{day}

      test "part1" do
        input = \"\"\"
        \"\"\"
        assert Day#{day}.part1(input) == nil
      end

      test "part2" do
        input = \"\"\"
        \"\"\"
        assert Day#{day}.part2(input) == nil
      end
    end
    """
  end
end
