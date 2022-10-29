defmodule Zapp.NewslettersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zapp.Newsletters` context.
  """

  def valid_newsletter_attributes(attrs \\ %{}) do
     Enum.into(attrs, %{
      name: "Elixir Weekly"
    })
  end

  def valid_issue_attributes(attrs \\ %{}) do
     Enum.into(attrs, %{
      title: "This Weeks Big News"
    })
  end

  def valid_tweet_section_attributes(attrs \\ %{}) do
     Enum.into(attrs, %{
      body: "My first tweet"
    })
  end

  @doc """
  Generate a newsletter.
  """
  def newsletter_fixture(account, attrs \\ %{}) do
    attrs = valid_newsletter_attributes(attrs)
    {:ok, newsletter} = Zapp.Newsletters.create_newsletter(account, attrs)

    newsletter
  end

  @doc """
  Generate a issue.
  """
  def issue_fixture(newsletter, attrs \\ %{}) do
    attrs =  valid_issue_attributes(attrs)

    {:ok, issue} = Zapp.Newsletters.create_issue(newsletter, attrs)

    issue
  end

  def tweet_section_fixture(issue, attrs \\ %{}) do
    attrs =  valid_tweet_section_attributes(attrs)

    {:ok, tweet_section} = Zapp.Newsletters.create_issue_tweet_section(issue, attrs)

    tweet_section
  end
end
