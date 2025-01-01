defmodule Yeh35BlogWeb.BlogLive do
  use Yeh35BlogWeb.Live
  # use Yeh35BlogWeb, :live_view

  embed_templates "blog_live/*"

  def mount(_params, _session, socket) do
    {:ok, assign(socket, blog: Yeh35Blog.Blog.all_posts())}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @spec render(atom() | %{:live_action => atom(), optional(any()) => any()}) :: any()
  def render(assigns) do
    apply(__MODULE__, assigns.live_action, [assigns])
  end

  def handle_event("random_post", _params, socket) do
    post = Yeh35Blog.Blog.get_post_by_random!()

    {:noreply, push_patch(socket, to: ~p"/posts/#{post.id}")}
  end

  defp apply_action(socket, :index, %{"tag" => tag}) do
    socket
    |> assign(:page_title, tag)
    |> assign(:posts, Yeh35Blog.Blog.get_posts_by_tag!(tag))
    |> assign(:tag, tag)
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :posts, Yeh35Blog.Blog.all_posts())
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    post = Yeh35Blog.Blog.get_post_by_id!(id)

    socket
    |> assign(:page_title, post.title)
    |> assign(:post, post)
  end

  defp apply_action(socket, :archives, _params) do
    post_gorup_by_year =
      Yeh35Blog.Blog.all_posts()
      |> Enum.group_by(& &1.date.year, & &1)

    socket
    |> assign(:post_years, Map.keys(post_gorup_by_year) |> Enum.sort(&(&1 > &2)))
    |> assign(:post_gorup_by_year, post_gorup_by_year)
  end
end
