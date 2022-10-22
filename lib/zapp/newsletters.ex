defmodule Zapp.Newsletters do
  @moduledoc """
  The Newsletters context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo

  alias Zapp.Accounts.Account
  alias Zapp.Newsletters.Newsletter

  @doc """
  Returns the list of newsletters.

  ## Examples

      iex> list_newsletters()
      [%Newsletter{}, ...]

  """
  def list_newsletters do
    Repo.all(Newsletter)
  end

  @doc """
  Gets a single newsletter.

  Raises `Ecto.NoResultsError` if the Newsletter does not exist.

  ## Examples

      iex> get_newsletter!(123)
      %Newsletter{}

      iex> get_newsletter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_newsletter!(id), do: Repo.get!(Newsletter, id)

  @doc """
  Creates a newsletter.

  ## Examples

      iex> create_newsletter(%{field: value})
      {:ok, %Newsletter{}}

      iex> create_newsletter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_newsletter(%Account{} = account, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{account_id: account.id})

    %Newsletter{}
    |> Newsletter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a newsletter.

  ## Examples

      iex> update_newsletter(newsletter, %{field: new_value})
      {:ok, %Newsletter{}}

      iex> update_newsletter(newsletter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_newsletter(%Newsletter{} = newsletter, attrs) do
    newsletter
    |> Newsletter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a newsletter.

  ## Examples

      iex> delete_newsletter(newsletter)
      {:ok, %Newsletter{}}

      iex> delete_newsletter(newsletter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_newsletter(%Newsletter{} = newsletter) do
    Repo.delete(newsletter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking newsletter changes.

  ## Examples

      iex> change_newsletter(newsletter)
      %Ecto.Changeset{data: %Newsletter{}}

  """
  def change_newsletter(%Newsletter{} = newsletter, attrs \\ %{}) do
    Newsletter.changeset(newsletter, attrs)
  end

  alias Zapp.Newsletters.Issue

  @doc """
  Returns the list of issues.

  ## Examples

      iex> list_issues()
      [%Issue{}, ...]

  """
  def list_issues do
    Repo.all(Issue)
  end

  @doc """
  Gets a single issue.

  Raises `Ecto.NoResultsError` if the Issue does not exist.

  ## Examples

      iex> get_issue!(123)
      %Issue{}

      iex> get_issue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_issue!(id), do: Repo.get!(Issue, id)

  @doc """
  Creates a issue.

  ## Examples

      iex> create_issue(%{field: value})
      {:ok, %Issue{}}

      iex> create_issue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_issue(%Newsletter{} = newsletter, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{newsletter_id: newsletter.id, account_id: newsletter.account_id})

    %Issue{}
    |> Issue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a issue.

  ## Examples

      iex> update_issue(issue, %{field: new_value})
      {:ok, %Issue{}}

      iex> update_issue(issue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_issue(%Issue{} = issue, attrs) do
    issue
    |> Issue.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a issue.

  ## Examples

      iex> delete_issue(issue)
      {:ok, %Issue{}}

      iex> delete_issue(issue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_issue(%Issue{} = issue) do
    Repo.delete(issue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking issue changes.

  ## Examples

      iex> change_issue(issue)
      %Ecto.Changeset{data: %Issue{}}

  """
  def change_issue(%Issue{} = issue, attrs \\ %{}) do
    Issue.changeset(issue, attrs)
  end
end
