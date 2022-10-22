defmodule Zapp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Zapp.Accounts` context.
  """

  alias Zapp.Accounts.Account
  alias Zapp.Repo

  def unique_identity_email, do: "identity#{System.unique_integer()}@example.com"
  def valid_identity_password, do: "hello world!"

  def valid_identity_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_identity_email(),
      password: valid_identity_password()
    })
  end

  def identity_fixture(attrs \\ %{}) do
    {:ok, identity} =
      attrs
      |> valid_identity_attributes()
      |> Zapp.Accounts.register_identity()

    identity
  end

  # def user_fixture(attrs \\ %{}) do
  #   {:ok, user} =
  #     attrs
  #     |> Zapp.Accounts.
  # end

  def account_fixture(attrs \\ %{}) do
    {:ok, account} = %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()

    account
  end

  def owner_and_account_fixture(identity_attrs \\ %{}) do
    identity_attrs
    |> valid_identity_attributes()
    |> Zapp.Accounts.register_owner_with_account()
  end

  def extract_identity_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
