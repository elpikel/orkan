defmodule Orkan.OpenMeteo.Client do
  use Tesla

  def get_data(longitude, latitude) do
    {:ok, %Tesla.Env{body: body}} =
      get(
        "https://api.open-meteo.com/v1/forecast?latitude=#{latitude}&longitude=#{longitude}&hourly=windspeed_10m,winddirection_10m"
      )

    Jason.decode!(body)
  end
end
