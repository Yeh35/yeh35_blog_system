defmodule Mix.Tasks.Arb do
  @moduledoc """

  """
  use Mix.Task
  import ArticleBuilder

  @shortdoc "Build Articles"
  def run(_) do
    build("./articles", "./_build_articles")
  end
end
