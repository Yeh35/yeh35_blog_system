defmodule PhxBlogTest do
  use ExUnit.Case
  doctest PhxBlog

  test "greets the world" do
    assert PhxBlog.hello() == :world
  end
end
