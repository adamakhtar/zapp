defmodule Zapp.Newsletters do
  @moduledoc """
  The Newsletters context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo

  alias Zapp.Accounts.{Account, User}
  alias Zapp.Newsletters.{Newsletter, Issue, TweetSection}

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

  # TODO - test
  # Currently accounts can only have one newsletter
  def get_account_newsletter!(%Account{} = account) do
    query =
      from n in Newsletter,
        where: n.account_id == ^account.id
    Repo.one!(query)
  end

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
  Creates demo newsletter

  ## Examples

      iex> create_demo_newsletter(%Account{} = account)
      {:ok, %{newsletter: %Newsletter{}, issue: %Issue{}}

      iex> create_demo_newsletter()
      {:error, :newsletter, changeset, _}

  """
  def create_demo_newsletter(%Account{} = account) do
    newsletter_attrs = %{name: "Amazing Newsletter", account_id: account.id}
    issue_attrs = %{title: "The Maiden Issue", account_id: account.id}
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:newsletter, change_newsletter(%Newsletter{}, newsletter_attrs))
    |> Ecto.Multi.insert(:issue, fn %{newsletter: newsletter} ->
      change_newsletter_issue(newsletter, %Issue{},issue_attrs)
    end)
    |> Repo.transaction()
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

  def list_newsletter_issues(%Newsletter{} = newsletter) do
    query =
      from i in Issue,
        where: i.account_id == ^newsletter.account_id,
        where: i.newsletter_id == ^newsletter.id

    Repo.all(query)
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

  # TODO test
  def get_issue_with_tweet_sections!(id) do
    IO.inspect(id)
    query =
      from i in Issue,
        distinct: i.id,
        where: i.id == ^id,
        left_join: ts in assoc(i, :tweet_sections),
        preload: [:tweet_sections]

    Repo.one!(query)
  end

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

  def change_newsletter_issue(%Newsletter{} = newsletter, %Issue{} = issue, attrs \\ %{}) do
    attrs = Enum.into(attrs, %{newsletter_id: newsletter.id, account_id: newsletter.account_id})
    Issue.changeset(issue, attrs)
  end

  def change_tweet_section(%Issue{} = issue, %TweetSection{} = twitter_section, attrs \\ %{}) do
    twitter_section
    |> TweetSection.changeset(Enum.into(attrs, %{issue_id: issue.id}))
  end

  def create_issue_tweet_section(%Issue{} = issue, attrs \\ %{}) do
    issue
    |> change_tweet_section(%TweetSection{}, attrs)
    |> Repo.insert()
  end

  ## POLICIES

  def can?(%User{}, :index, Newsletter) do
    true
  end

  def can?(%User{} = user, :show, %Newsletter{} = newsletter) do
    user.account_id == newsletter.account_id
  end

  def can?(%User{}, :index, Issue) do
    true
  end

  def can?(%User{} = user, :show, %Issue{} = issue) do
    user.account_id == issue.account_id
  end
end
