defmodule Zapp.AudienceFixtures do

  alias Zapp.Newsletters.Newsletter
  alias Zapp.Audience

  def valid_subscriber_attributes(attrs \\ %{}) do
     Enum.into(attrs, %{
      email: "subscriber@example.com"
    })
  end

  def subscriber_fixture(%Newsletter{} = newsletter, attrs \\ %{}) do
    attrs = valid_subscriber_attributes(attrs)
    {:ok, subscriber} = Audience.create_newsletter_subscriber(newsletter.id, attrs)

    subscriber
  end
end
