defmodule AdventOfCode.Utils do
  @moduledoc """
  Common utilities for tasks
  """
  def setup_env! do
    ".env"
    |> Dotenvy.source!()
    |> System.put_env()

    Application.ensure_all_started(:httpoison)
  end

  def pad_day(day) do
    String.pad_leading(day, 2, "0")
  end

  def get_base_path(year, day) do
    "lib/advent_of_code/#{year}/#{pad_day(day)}"
  end

  def get_test_path(year, day) do
    "test/#{year}/#{pad_day(day)}"
  end

  def download_description(year, day, part) do
    url = "https://adventofcode.com/#{year}/day/#{day}"

    with {:ok, body} <- http_get(url),
         {:ok, document} <- Floki.parse_document(body) do
      case document
           |> Floki.find("article.day-desc")
           |> Enum.at(part - 1) do
        nil ->
          {:error, "Description part #{part} not found"}

        article ->
          {:ok,
           article
           |> Floki.raw_html()
           |> String.trim()
           |> Html2Markdown.convert()}
      end
    end
  end

  def http_get(url) do
    case HTTPoison.get(url, get_request_headers(), follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "HTTP #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def http_post(url, body) do
    headers = get_request_headers() ++ [{"Content-Type", "application/x-www-form-urlencoded"}]

    case HTTPoison.post(url, body, headers, follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "HTTP #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_request_headers do
    [{"Cookie", "session=#{System.get_env("AOC_SESSION")}"}]
  end
end
