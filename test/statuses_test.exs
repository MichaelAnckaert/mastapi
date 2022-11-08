defmodule StatusesTest do
  use ExUnit.Case

  test "filter top level threads" do
    mock_data = [
      %{id: 1, in_reply_to_id: nil},
      %{id: 2, in_reply_to_id: 1}
    ]

    filtered_threads = Mastapi.Statuses.filter_threads(mock_data)
    assert length(filtered_threads) == 1
    assert List.first(filtered_threads).id == 1
  end

  test "exclude reblogs" do
    mock_data = [
      %{id: 1, reblog: nil},
      %{id: 2, reblog: %{id: 1}}
    ]

    filtered_threads = Mastapi.Statuses.exclude_reblogs(mock_data)
    assert length(filtered_threads) == 1
    assert List.first(filtered_threads).id == 1
  end
end
