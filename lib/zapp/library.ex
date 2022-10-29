defmodule Zapp.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Zapp.Repo

  @tweets [
    %{
      id: 1,
      body: "How come I’ve never seen this video before? My mom just sent it to me. They’re dancers in wheelchairs dancing with arm movements during the 2020 Tokyo Paralympics…"
    },
    %{
      id: 2,
      body: "One of my posts is at the top of Indie Hackers right now and there's virtually zero additional traffic to my site 😬"
    },
    %{
      id: 3,
      body: "BREAKING NEWS: Sunak has decided “in the interests of party unity” to appoint Johnson as Secretary of State for Justice and Truss as Chancellor "
    },
    %{
      id: 4,
      body: "Pro-tip: just dress like a tourist even if you’ve lived here 1/3 of your life like me."
    },
    %{
      id: 5,
      body: "I know it can’t be helped, but it’s so annoying that most (English) international families cool activities are located in Minato ward. Any time I see a “sensory classes”, “fun afternoon at the playground”, “parent meetup” I bet it’s in Minato. We’re not all loaded expats yo."
    },
  ]


  # TODO test
  def get_tweet(id) do
    Enum.find(@tweets, fn tweet ->
      tweet.id == id
    end)
  end

  def list_tweets() do
    @tweets
  end
end