defmodule Zapp.Newsletters.IssueNotifier do
  use Phoenix.Swoosh, view: ZappWeb.Mailers.IssueNotifierView,
                      layout: {ZappWeb.Mailers.LayoutView, :layout}

  alias Zapp.Newsletters.Issue
  alias Zapp.Audience.Subscriber

  def deliver_issue(%{name: name, email: email}) do
    new()
    |> to({name, email})
    |> from({"Phoenix Team", "team@example.com"})
    |> subject("Welcome to Phoenix, #{name}!")
    |> render_body("issue.html")
    |> premail()
  end

  defp premail(email) do
    html = Premailex.to_inline_css(email.html_body)
    text = Premailex.to_text(email.html_body)

    email
    |> html_body(html)
    |> text_body(text)
  end
end
