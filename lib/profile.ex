defmodule Mastapi.Profile do
  @instance "https://fosstodon.org"

  def get_profile(id) do
    get_url(id)
    |> get_data
    |> decode_data
    |> print_profile
  end

  def get_url(id) do
    "#{@instance}/api/v1/accounts/#{id}"
  end

  defp get_data(url) do
    case HTTPoison.get(url, ["Accept": "Application/json; Charset=utf-8"]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def decode_data(body) do
    case Jason.decode(body, %{keys: :atoms}) do
      {:ok, data} ->
        data
      {:error, _error} ->
        IO.puts "Failed to decode JSON data"
        :error
    end
  end

  defp print_profile(data) do
    note = HtmlSanitizeEx.strip_tags(data.note)

    IO.puts "#{data.display_name} (#{data.url})"
    IO.puts " followers: #{data.followers_count}"
    IO.puts " following: #{data.following_count}"
    IO.puts " #{note}"
  end

end
