defmodule Yeh35BlogWeb.PostLive.Archives do
  use Yeh35BlogWeb, :surface_live_view

  def render(assigns) do
    ~F"""
    <h1 class="text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-3xl sm:leading-10 md:text-4xl md:leading-14">
      모든 글
    </h1>
    <ul class="mt-4">
      <li :for={post_year <- @post_years} class="py-4">
        <h2 class="text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-3xl sm:leading-10 md:text-3xl md:leading-14">
          {post_year}
        </h2>
        <hr class="h-px mt-2 bg-gray-900 border-0 dark:bg-gray-300">
        <ul class="mt-4 ms-4 list-disc list-inside">
          <li :for={post <- @post_gorup_by_year[post_year]} class="py-2">
            <a
              href={~p"/posts/#{post.id}"}
              class="font-medium text-blue-600 dark:text-blue-500 hover:underline"
            >
              {post.title}
            </a>
          </li>
        </ul>
      </li>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    post_gorup_by_year =
      Yeh35Blog.Blog.all_posts()
      |> Enum.group_by(& &1.date.year, & &1)

    socket =
      socket
      |> assign(:post_years, Map.keys(post_gorup_by_year) |> Enum.sort(&(&1 > &2)))
      |> assign(:post_gorup_by_year, post_gorup_by_year)

    {:ok, socket}
  end
end
