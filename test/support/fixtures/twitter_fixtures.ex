defmodule Zapp.TwitterFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zapp.Twitter` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        name: "some name",
        twitter_id: "some twitter_id"
      })
      |> Zapp.Twitter.create_list()

    list
  end
end
