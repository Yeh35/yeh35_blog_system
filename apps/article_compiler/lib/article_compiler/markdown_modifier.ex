defmodule ArticleCompiler.MarkdownModifier do
  @moduledoc """
  This module provides functions to add, remove, and load YAML front matter from a markdown file.
  """

  def save_yaml_front_matter(file_path, metadata) do
    if has_yaml_front_matter_from_file?(file_path) do
      remove_yaml_front_matter(file_path)
    end

    add_yaml_front_matter(file_path, metadata)
  end

  def add_yaml_front_matter(file_path, metadata) do
    original_content = File.read!(file_path)
    yaml_front_matter = convert_metadata_to_yaml(metadata)

    new_content =
      """
      ---
      #{yaml_front_matter}
      ---

      #{original_content}
      """

    File.write!(file_path, new_content)
  end

  def remove_yaml_front_matter(file_path) do
    original_content = File.read!(file_path)
    new_content = Regex.replace(~r/^---\s*.*?\n---\s*/s, original_content, "", global: false)

    File.write!(file_path, new_content)
  end

  @doc """
  Load the YAML front matter from a markdown file and return it as a list of key-value pairs.

  @Examples
    iex> load_yaml_front_matter("./articles/test.md")
    [{"title", "My First Blog Post"}, {"date", "2020-01-01"}]
  """
  def load_yaml_front_matter_from_file(file_path) do
    File.read!(file_path)
    |> load_yaml_front_matter()
  end

  @doc """
  Load the YAML front matter from a markdown and return it as a list of key-value pairs.
  """
  @spec load_yaml_front_matter(String.t()) :: %{}
  def load_yaml_front_matter(file_content) do
    if has_yaml_front_matter?(file_content) do
      # YAML front matter 추출
      [yaml_front_matter | _] =
        Regex.scan(~r/---\s*\n(.*?)\n---/ms, file_content)
        |> List.first()

      # 추출된 YAML front matter를 줄 단위로 분리하고, 각 줄을 파싱하여 키-값 쌍으로 변환
      yaml_front_matter
      # 앞뒤 ---를 제거
      |> String.replace(~r/^\s*---|---\s*$/, "")
      |> String.split("\n")
      # 비어있지 않은 줄만 선택
      |> Enum.filter(&(&1 != ""))
      |> Enum.reduce(%{}, fn line, acc ->
        [key, value] = String.split(line, ":", parts: 2)
        Map.put(acc, String.trim(key), infer_type(String.trim(value)))
      end)
    else
      %{}
    end
  end

  def has_yaml_front_matter_from_file?(file_path) do
    File.read!(file_path)
    |> has_yaml_front_matter?()
  end

  @spec has_yaml_front_matter?(String.t()) :: boolean
  def has_yaml_front_matter?(file_content) do
    Regex.match?(~r/^\s*---\s*\n.*?\n---/ms, file_content)
  end

  defp convert_metadata_to_yaml(metadata) do
    metadata
    |> Enum.sort(fn {k1, _}, {k2, _} -> String.length(k1) < String.length(k2) end)
    |> Enum.map(fn {key, value} -> "#{key}: #{value}" end)
    |> Enum.join("\n")
  end

  defp infer_type(value) do
    cond do
      # 날짜
      is_date?(value) -> DateTime.from_iso8601(value) |> elem(1)
      # 숫자
      Regex.match?(~r/^\d+$/, value) -> String.to_integer(value)
      # 부동소수점 숫자
      Regex.match?(~r/^\d+\.\d+$/, value) -> String.to_float(value)
      # 불리언
      value in ["true", "false"] -> value == "true"
      # 기본적으로 문자열
      true -> value
    end
  end

  @spec is_date?(String.t()) :: boolean
  defp is_date?(value) do
    case DateTime.from_iso8601(value) do
      {:ok, _, _} -> true
      _ -> false
    end
  end
end
