defmodule Orkan.Windguru.Client do
  use Tesla

  @api_key System.get_env("api_key")

  def get_data() do
    {:ok, %Tesla.Env{body: body}} =
      get("http://api.openweathermap.org/data/2.5/forecast?q=Jastarnia&appid=#{@api_key}")

    # get only wind info
    Jason.decode!(body)
  end
end
