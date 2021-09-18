# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Orkan.Repo.insert!(%Orkan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias Orkan.Repo
alias Orkan.Forecasts.Place

Repo.insert(%Place{longitude: "54.7147", latitude: "18.5581", name: "Jastarnia"})
