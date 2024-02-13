defmodule ArticleBuilder do
  alias ArticleCompiler

  def build(dir_article, dir_build) do
    # content = load_metadata("#{dir_build}/metadata.json")

    Path.wildcard("#{dir_article}/*.md")
    |> Stream.map(&ArticleCompiler.load_article(&1))
    |> Stream.filter(fn a -> a.publish end)
    |> Stream.map(fn a -> compile_article(a, "#{dir_build}/#{a.id}.html") end)
    |> Stream.run()
  end

  # @doc """

  # dir: the directory where the articles are located
  # dir_build: the directory where the compiled articles will be saved
  # """
  # def compile_article_dir(dir, dir_build) do
  #   content = load_metadata("#{dir_build}/metadata.json")

  #   Path.wildcard("#{dir}/*.md")
  #   |> Enum.map()

  #   Path.wildcard("#{dir}/*.md")
  #   |> Enum.map(&File.read!(&1))
  #   |> Enum.map(&compile_article/1)
  # end

  # def convert_file_to_html(input_file_path, output_file_path) do
  #   input_file_path
  #   |> File.stream!()
  #   |> Stream.map(&Earmark.as_html!/1)
  #   |> Enum.join("\n")
  #   |> write_to_file(output_file_path)
  # end

  @spec load_metadata(String.t()) :: map()
  defp load_metadata(file_path) do
    if File.exists?(file_path) do
      File.read!(file_path)
      |> Jason.decode()
      |> elem(1)
    else
      %{}
    end
  end

  @spec save_metadata(String.t(), map()) :: :ok | :error
  defp save_metadata(file_path, content) do
    case File.open(file_path, [:write]) do
      {:ok, file} ->
        case Jason.encode(content) do
          {:ok, encoded} ->
            IO.write(file, encoded)

          {:error, reason} ->
            IO.puts("Error: #{reason}")
        end

        File.close(file)
        :ok

      {:error, reason} ->
        IO.puts("Error: #{reason}")
        :error
    end
  end

  @spec compile_article(ArticleCompiler.t(), String.t()) :: ArticleCompiler.t()
  defp compile_article(article, saved_file_path) do
    article
    |> ArticleCompiler.compile()
    |> write_to_file(saved_file_path)

    article
  end

  defp write_to_file(content, file_path) do
    File.write(file_path, content)
  end
end
