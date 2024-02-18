defmodule Yeh35Blog.Blog.MarkdownConverter do
  def convert(extname, body, _attrs, opts) when extname in [".md", ".markdown"] do
    highlighters = Keyword.get(opts, :highlighters, [])
    body |> Md.generate() |> NimblePublisher.highlight(highlighters)
  end
end
