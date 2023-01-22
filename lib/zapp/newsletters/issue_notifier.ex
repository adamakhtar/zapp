defmodule Zapp.Newsletters.IssueNotifier do
  use Phoenix.Swoosh, view: ZappWeb.Mailers.IssueNotifierView

  alias Zapp.Newsletters.Issue
  alias Zapp.Audience.Subscriber

  def deliver_issue(%Issue{} = issue, %Subscriber{} = subscriber) do
    new()
    |> to({"", subscriber.email})
    |> from({"Phoenix Team", "team@example.com"})
    |> subject(issue.title)
    |> render_body("issue.html", %{issue: issue})
    |> render_mjml()
  end

  def render_mjml(email) do
    {:ok, html_body} = Mjml.to_html(Map.get(email, :html_body))
    Map.put(email, :html_body, html_body)
  end

  defp premail(email) do
    html = Premailex.to_inline_css(email.html_body)
    text = Premailex.to_text(email.html_body)

    email
    |> html_body(html)
    |> text_body(text)
  end
end
