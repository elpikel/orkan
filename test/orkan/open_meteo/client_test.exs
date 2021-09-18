defmodule Orkan.OpenMeteo.ClientTest do
  use ExUnit.Case

  alias Orkan.OpenMeteo.Client

  test "gets data" do
    data = Client.get_data("", "")

    assert %{} = data
  end
end
