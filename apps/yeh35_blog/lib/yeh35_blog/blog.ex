defmodule Yeh35Blog.Blog do
  alias Yeh35Blog.Blog.Post
  alias NimblePublisher.MarkdownConverter

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:yeh35_blog, "priv/posts/**/*.md"),
    as: :posts,
    highlighters: [:makeup_elixir, :makeup_erlang]

  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.filter(@posts, &(&1.published == true))
         |> Enum.sort_by(& &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags
  def recent_posts(num \\ 5), do: Enum.take(all_posts(), num)

  defmodule NotFoundError, do: defexception([:message, plug_status: 404])

  def get_post_by_id!(id) do
    Enum.find(all_posts(), &(&1.id == id)) ||
      raise NotFoundError, "post with id=#{id} not found"
  end

  def get_posts_by_tag!(tag) do
    case Enum.filter(all_posts(), &(tag in &1.tags)) do
      [] -> raise NotFoundError, "posts with tag=#{tag} not found"
      posts -> posts
    end
  end
end
