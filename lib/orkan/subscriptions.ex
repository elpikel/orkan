defmodule Orkan.Subscriptions do
  alias Orkan.Forecasts.Forecast
  alias Orkan.Forecasts.Place
  alias Orkan.Repo
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User

  import Ecto.Query

  def create(subscription_params) do
    user = get_or_create_user(subscription_params["email"])

    place =
      get_or_create_place(
        subscription_params["longitude"],
        subscription_params["latitude"],
        subscription_params["name"]
      )

    case Repo.insert(
           Subscription.changeset(%Subscription{}, %{
             place_id: place.id,
             user_id: user.id
           })
         ) do
      {:ok, subscription} ->
        {:ok, subscription}

      {:error, _} ->
        {:error, "Already subscribed."}
    end
  end

  defp get_or_create_place(longitude, latitude, name) do
    case Repo.one(from p in Place, where: p.longitude == ^longitude and p.latitude == ^latitude) do
      nil ->
        {:ok, place} =
          Repo.insert(
            Place.changeset(%Place{}, %{longitude: longitude, latitude: latitude, name: name})
          )

        place

      place ->
        place
    end
  end

  defp get_or_create_user(email) do
    case Repo.one(from u in User, where: u.email == ^email) do
      nil ->
        {:ok, user} = Repo.insert(User.changeset(%User{}, %{email: email}))
        user

      user ->
        user
    end
  end

  def send() do
    User
    |> Repo.all()
    |> Enum.each(fn user -> send(user) end)
  end

  defp send(user) do
    user
    |> get_forecasts()
  end

  def get_forecasts(user) do
    today = DateTime.new!(Date.utc_today(), ~T[00:00:00.000], "Etc/UTC")
    tomorrow = add_days(today, 1)
    in_two_days = add_days(tomorrow, 2)

    query =
      from s in Subscription,
        join: p in Place,
        on: p.id == s.place_id,
        join: f in Forecast,
        on: f.place_id == p.id,
        select: {p.name, f.datetime, f.wind_speed, f.wind_direction},
        where: s.user_id == ^user.id and f.datetime >= ^tomorrow and f.datetime < ^in_two_days,
        order_by: [p.name, f.datetime]

    Repo.all(query)
    |> Enum.group_by(fn {name, _, _, _} -> name end)
    |> Enum.map(fn {name, forecasts} ->
      %{
        place: name,
        forecasts:
          Enum.map(forecasts, fn {_, datetime, wind_speed, wind_direction} ->
            %{
              datetime: datetime,
              wind_speed: wind_speed,
              wind_direction: wind_direction
            }
          end)
      }
    end)
    |> IO.inspect()
  end

  defp add_days(datetime, days) do
    DateTime.add(datetime, days * 24 * 60 * 60, :seconds)
  end
end
