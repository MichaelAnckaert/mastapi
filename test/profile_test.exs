defmodule ProfileTest do
  use ExUnit.Case

  test "get url for profile" do
    url = Mastapi.Profile.get_url(99)
    assert url == "https://fosstodon.org/api/v1/accounts/99"
  end

  test "decode data: success" do
    data = "{\"id\": 99, \"name\": \"Michael\"}"
    json = Mastapi.Profile.decode_data(data)
    assert json.id == 99
    assert json.name == "Michael"
  end

  test "decode data: failure" do
    data = "bad json data"
    json = Mastapi.Profile.decode_data(data)
    assert json == :error
  end
end
