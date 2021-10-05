defmodule Orkan.Subscriptions do
  import Ecto.Query

  alias Orkan.Repo
  alias Orkan.Subscriptions.Place
  alias Orkan.Subscriptions.Subscription
  alias Orkan.Subscriptions.User

  def places(user_id) do
    Repo.all(
      from p in Place,
        join: s in Subscription,
        on: p.id == s.place_id,
        join: u in User,
        on: s.user_id == u.id,
        where: u.id == ^user_id,
        select: p
    )
  end

  def users() do
    Repo.all(User)
  end

  def get(user_id) do
    Repo.all(from s in Subscription, where: s.user_id == ^user_id)
  end

  def create(%{email: email, longitude: longitude, latitude: latitude, name: name}) do
    user = get_or_create_user(email)
    place = get_or_create_place(longitude, latitude, name)

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

  def get_or_create_place(longitude, latitude, name) do
    case Repo.one(from p in Place, where: p.longitude == ^longitude and p.latitude == ^latitude) do
      nil ->
        {:ok, place} =
          Repo.insert(
            Place.changeset(%Place{}, %{longitude: longitude, latitude: latitude, name: name}),
            on_conflict: [set: [name: name]],
            conflict_target: [:longitude, :latitude]
          )

        place

      place ->
        place
    end
  end
end
