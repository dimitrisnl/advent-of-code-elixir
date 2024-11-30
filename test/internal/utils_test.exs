defmodule AdventOfCode.Internal.UtilsTest do
  use ExUnit.Case, async: false

  import Mock

  alias AdventOfCode.Utils

  describe "path helpers" do
    test "pad_day/1 pads single digit with zero" do
      assert Utils.pad_day("1") == "01"
      assert Utils.pad_day("9") == "09"
    end

    test "pad_day/1 doesn't pad double digits" do
      assert Utils.pad_day("10") == "10"
      assert Utils.pad_day("25") == "25"
    end

    test "get_base_path/2 returns correct path" do
      assert Utils.get_base_path("2023", "1") == "lib/advent_of_code/2023/01"
      assert Utils.get_base_path("2023", "15") == "lib/advent_of_code/2023/15"
    end

    test "get_test_path/2 returns correct path" do
      assert Utils.get_test_path("2023", "1") == "test/2023/01"
      assert Utils.get_test_path("2023", "15") == "test/2023/15"
    end
  end

  describe "download_description/3" do
    test "successfully downloads part 1 description" do
      html_response = """
      <html>
        <body>
          <article class="day-desc">Part 1 content</article>
          <article class="day-desc">Part 2 content</article>
        </body>
      </html>
      """

      with_mock HTTPoison,
        get: fn _, _, _ -> {:ok, %HTTPoison.Response{status_code: 200, body: html_response}} end do
        assert {:ok, "Part 1 content"} = Utils.download_description("2023", "1", 1)
      end
    end

    test "successfully downloads part 2 description" do
      html_response = """
      <html>
        <body>
          <article class="day-desc">Part 1 content</article>
          <article class="day-desc">Part 2 content</article>
        </body>
      </html>
      """

      with_mock HTTPoison,
        get: fn _, _, _ -> {:ok, %HTTPoison.Response{status_code: 200, body: html_response}} end do
        assert {:ok, "Part 2 content"} = Utils.download_description("2023", "1", 2)
      end
    end

    test "returns error when part doesn't exist" do
      html_response = """
      <html>
        <body>
          <article class="day-desc">Part 1 content</article>
        </body>
      </html>
      """

      with_mock HTTPoison,
        get: fn _, _, _ -> {:ok, %HTTPoison.Response{status_code: 200, body: html_response}} end do
        assert {:error, "Description part 2 not found"} =
                 Utils.download_description("2023", "1", 2)
      end
    end

    test "handles HTTP error" do
      with_mock HTTPoison, get: fn _, _, _ -> {:ok, %HTTPoison.Response{status_code: 404}} end do
        assert {:error, "HTTP 404"} = Utils.download_description("2023", "1", 1)
      end
    end
  end
end
