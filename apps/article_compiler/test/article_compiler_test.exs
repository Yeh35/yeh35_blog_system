defmodule ArticleCompilerTest do
  use ExUnit.Case
  doctest ArticleCompiler

  test "greets the world" do
    assert ArticleCompiler.hello() == :world
  end
end
