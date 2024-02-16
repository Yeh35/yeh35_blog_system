defmodule Yeh35BlogWeb.BlogController do
  use Yeh35BlogWeb, :controller

  alias Yeh35Blog.Blog

  def index(conn, _params) do
    render(conn, "index.html", posts: Blog.published_posts())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", post: Blog.get_post_by_id!(id))
  end
end
