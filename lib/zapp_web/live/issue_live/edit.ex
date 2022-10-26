defmodule ZappWeb.IssueLive.Edit do
  use ZappWeb, :live_view

  alias Zapp.Newsletters

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    # TODO - authorise
    issue = Newsletters.get_issue!(id)

    tweets = [
      %{
        id: 1,
        content: "How come I’ve never seen this video before? My mom just sent it to me. They’re dancers in wheelchairs dancing with arm movements during the 2020 Tokyo Paralympics…"
      },
      %{
        id: 2,
        content: "One of my posts is at the top of Indie Hackers right now and there's virtually zero additional traffic to my site 😬"
      },
      %{
        id: 3,
        content: "BREAKING NEWS: Sunak has decided “in the interests of party unity” to appoint Johnson as Secretary of State for Justice and Truss as Chancellor "
      },
      %{
        id: 4,
        content: "Pro-tip: just dress like a tourist even if you’ve lived here 1/3 of your life like me."
      },
      %{
        id: 5,
        content: "I know it can’t be helped, but it’s so annoying that most (English) international families cool activities are located in Minato ward. Any time I see a “sensory classes”, “fun afternoon at the playground”, “parent meetup” I bet it’s in Minato. We’re not all loaded expats yo."
      },
    ]


    {:ok,
    socket
    |> assign(:page_title, "Edit Issue")
    |> assign(:issue, issue)
    |> assign(:tweets, tweets)
    |> assign(:dropzone, [])
    }
  end

  @impl true
  def handle_params(_params, _session, socket) do

    {:noreply, socket}
  end
end
