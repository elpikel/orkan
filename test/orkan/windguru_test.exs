defmodule Orkan.WindguruTest do
  use ExUnit.Case

  alias Orkan.Windguru

  test "gets data" do
    data = Windguru.get_data()

    assert data == "html"
  end
end
