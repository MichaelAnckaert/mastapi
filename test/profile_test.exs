defmodule ProfileTest do
  use ExUnit.Case

  test "get url for profile" do
    url = Mastapi.Profile.get_url(99)
    assert url == "https://fosstodon.org/api/v1/accounts/99"
  end
end
