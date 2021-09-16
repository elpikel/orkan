defmodule Orkan.Windguru.ClientTest do
  use ExUnit.Case

  alias Orkan.Windguru.Client

  test "gets data" do
    data = Client.get_data()

    assert %{} = data
  end
end
