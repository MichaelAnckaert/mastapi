defmodule Mastapi.Statuses do
  @instance "https://fosstodon.org"

  def get_statuses_for_profile(id) do
    get_url(id)
    |> get_data
    |> decode_data
    |> filter_threads
    |> exclude_reblogs
    |> print_statuses
  end

  defp get_url(id) do
    "#{@instance}/api/v1/accounts/#{id}/statuses"
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

  defp decode_data(body) do
    case Jason.decode(body, %{keys: :atoms}) do
      {:ok, data} ->
        data
      {:error, _error} ->
        IO.puts "Failed to decode JSON data"
    end
  end

  def filter_threads(data) do
    is_thread? = &(is_nil &1.in_reply_to_id)
    Enum.filter(data, is_thread?)
  end

  def exclude_reblogs(data) do
    is_not_reblog? = &(is_nil &1.reblog)
    Enum.filter(data, is_not_reblog?)
  end

  defp print_statuses(data) do
    Enum.map(data, fn status -> print_status(status) end)
  end

  defp print_status(status) do
    content = HtmlSanitizeEx.strip_tags(status.content)

    IO.puts "#{status.account.username} (#{status.created_at})"
    IO.puts "#{content}"
    IO.puts "============================================="
  end

end
