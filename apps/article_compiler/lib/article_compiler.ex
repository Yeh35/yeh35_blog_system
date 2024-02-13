defmodule ArticleCompiler do
  @moduledoc """
  Documentation for `ArticleCompiler`.
  """

  alias ArticleCompiler.MarkdownModifier
  alias Uniq.UUID

  defstruct id: "",
            title: "",
            created_date: "",
            last_modified_date: "",
            publish: false,
            tags: [],
            file_path: "",
            content: ""

  @spec compile(%ArticleCompiler{}) :: String.t()
  def compile(article) do
    article.content
    |> Earmark.as_html!()
  end

  @spec load_article(String.t()) :: %ArticleCompiler{}
  def load_article(file_path) do
    create_article(file_path)
    |> fetch_article()
  end

  @spec create_article(String.t()) :: %ArticleCompiler{}
  defp create_article(file_path) do
    markdown_context = File.read!(file_path)
    metadata = MarkdownModifier.load_yaml_front_matter(markdown_context)

    %ArticleCompiler{
      id: metadata["id"] || UUID.uuid7(),
      title: metadata["title"] || "",
      created_date: metadata["created_date"] || DateTime.utc_now(),
      last_modified_date: metadata["last_modified_date"] || DateTime.utc_now(),
      publish: metadata["publish"] || false,
      tags: metadata["tags"] || [],
      file_path: file_path,
      content: markdown_context
    }
  end

  @spec fetch_article(%ArticleCompiler{}) :: %ArticleCompiler{}
  defp fetch_article(article) do
    MarkdownModifier.save_yaml_front_matter(article.file_path, %{
      "id" => article.id,
      "title" => article.title,
      "created_date" => article.created_date,
      "last_modified_date" => article.last_modified_date,
      "publish" => article.publish,
      "tags" => article.tags
    })

    article
  end
end
