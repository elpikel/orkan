defmodule Orkan.Subscriptions do
  alias Orkan.Forecasts
  alias Orkan.Repo
  alias Orkan.Subscriptions.Mail
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User

  import Ecto.Query

  def create(%{email: email, longitude: longitude, latitude: latitude, name: name}) do
    user = get_or_create_user(email)
    place = Forecasts.get_or_create_place(longitude, latitude, name)

    case Repo.insert(
           Subscription.changeset(%Subscription{}, %{
             place_id: place.id,
             user_id: user.id
           })
         ) do
      {:ok, subscription} ->
        {:ok, subscription}

      {:error, _changeset} ->
        {:error, "Already subscribed."}
    end
  end

  defp get_or_create_user(email) do
    case Repo.one(from u in User, where: u.email == ^email) do
      nil ->
        {:ok, user} = Repo.insert(User.changeset(%User{}, %{email: email}), on_conflict: :nothing)
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
    forecasts = Forecasts.get(user)
    Mail.send(user, forecasts)
  end
end
