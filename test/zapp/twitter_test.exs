defmodule Zapp.TwitterTest do
  use Zapp.DataCase

  alias Zapp.Twitter

  describe "lists" do
    alias Zapp.Twitter.List

    import Zapp.TwitterFixtures

    @invalid_attrs %{name: nil, twitter_id: nil}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Twitter.list_lists() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      list = list_fixture()
      assert Twitter.get_list!(list.id) == list
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{name: "some name", twitter_id: "some twitter_id"}

      assert {:ok, %List{} = list} = Twitter.create_list(valid_attrs)
      assert list.name == "some name"
      assert list.twitter_id == "some twitter_id"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Twitter.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{name: "some updated name", twitter_id: "some updated twitter_id"}

      assert {:ok, %List{} = list} = Twitter.update_list(list, update_attrs)
      assert list.name == "some updated name"
      assert list.twitter_id == "some updated twitter_id"
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, %Ecto.Changeset{}} = Twitter.update_list(list, @invalid_attrs)
      assert list == Twitter.get_list!(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, %List{}} = Twitter.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Twitter.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Twitter.change_list(list)
    end
  end
end
