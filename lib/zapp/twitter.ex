defmodule Zapp.Twitter do
  @moduledoc """
  The Twitter context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo

  alias Zapp.Accounts.{User, OauthCredential}
  alias Zapp.Newsletters.Newsletter
  alias Zapp.Twitter.{List, Client}

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists()
      [%List{}, ...]

  """
  def list_lists(account_id, newsletter_id) do
    Repo.all(
      from l in List,
      where: l.account_id == ^account_id,
      where: l.newsletter_id == ^newsletter_id
    )
  end

  def sync_lists(client, %User{} = user, %Newsletter{} = newsletter, %OauthCredential{} = credentials) do
    lists = client.get_lists(credentials.service_id)

    results = Enum.map(lists, fn x ->
      find_or_create_list(
        x.id,
        %{
          name: x.name,
          twitter_id: x.id,
          account_id: user.account_id,
          newsletter_id: newsletter.id
        }
      )
    end)

    results
  end

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list(account_id, id) do
    Repo.one(
      from l in List,
        where: l.account_id == ^account_id,
        where: l.id == ^id
    )
  end

  def get_list_by_twitter_id(twitter_list_id) do
    Repo.one(from l in List, where: l.twitter_id == ^twitter_list_id)
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  def find_or_create_list(twitter_list_id, attrs) do
    list = get_list_by_twitter_id(twitter_list_id)

    if list do
      {:ok, list}
    else
      create_list(attrs)
    end
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(%List{} = list, attrs) do
    list
    |> List.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end

  #
  #  T W E E T S
  #================================

  def fetch_list_timeline(client, twitter_user_id, twitter_list_id, options \\ []) do
    client.get_list_timeline(twitter_user_id, twitter_list_id, options)
  end
end
