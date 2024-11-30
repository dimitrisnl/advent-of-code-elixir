defmodule AdventOfCode.Utils do
  @moduledoc """
  Common utilities for tasks
  """
  def setup_env! do
    Dotenvy.source!(".env") |> System.put_env()
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
