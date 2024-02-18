defmodule Yeh35BlogWeb.BlogLive do
  use Yeh35BlogWeb, :live_view

  embed_templates "blog_live/*"

  def mount(_params, _session, socket) do
    {:ok, assign(socket, blog: Yeh35Blog.Blog.all_posts())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # defp apply_action(socket, :index, %{"tag" => tag}) do
  #   socket
  #   |> assign(:page_title, tag)
  #   |> assign(:posts, Yeh35Blog.Blog.!(tag))
  #   |> assign(:tag, tag)
  # end

  defp apply_action(socket, :index, _params) do
    assign(socket, :posts, Yeh35Blog.Blog.all_posts())
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    post = Yeh35Blog.Blog.get_post_by_id!(id)

    socket
    |> assign(:page_title, post.title)
    |> assign(:post, post)
  end

  def render(assigns) do
    apply(__MODULE__, assigns.live_action, [assigns])
  end
end
