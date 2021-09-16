defmodule Orkan.Windguru do
  @moduledoc """
    Exposes data
  """

  alias Orkan.Windguru.Client

  def get_data() do
    {:ok, document} = Floki.parse_document(Client.get_data())

    Floki.find(document, ".tr_dates") |> IO.inspect()
  end
end
