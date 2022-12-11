defmodule Zapp.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo
  alias Twitter
  alias Zapp.Accounts.OauthCredential

  # TODO test
  def get_tweet(id) do
    Enum.find(@tweets, fn tweet ->
      tweet.id == id
    end)
  end

  def list_timeline(%OauthCredential{} = credential) do
    list = List.first(Twitter.get_lists(credential.service_id))
    Twitter.get_list_timeline(list.id)
  end

  def get_lists(%OauthCredential{} = credential) do
    Twitter.get_lists(credential.service_id)
  end

  def configure_twitter_client(%OauthCredential{} = credential) do
    Twitter.configure(credential.token, credential.secret)
  end
end
