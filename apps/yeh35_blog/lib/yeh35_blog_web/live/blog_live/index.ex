defmodule Yeh35BlogWeb.PostLive.Index do
  use Yeh35BlogWeb, :surface_live_view

  def render(assigns) do
    ~F"""
    <button
      type="button"
      phx-click="random_post"
      class="text-white bg-gradient-to-br from-green-400 to-blue-600 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-green-200 dark:focus:ring-green-800 font-medium rounded-lg text-base px-5 py-2.5 text-center me-2 mb-2"
    >
      🎰 아무 페이지 읽기 (Random)
    </button>
    <ol class="relative border-s border-gray-200 dark:border-gray-700">
      <li :for={post <- @posts} class="ms-4 py-4">
        <article>
          <div class="absolute w-3 h-3 bg-gray-200 rounded-full mt-1.5 -start-1.5 border border-white dark:border-gray-900 dark:bg-gray-700">
          </div>
          <time
            datetime={post.date}
            class="mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500"
          >
            {post.date |> Yeh35BlogWeb.Timeformat.format_date()}
          </time>
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white">
            <.link navigate={~p"/posts/#{post.id}"}>
              {post.title}
              {#if post.id == List.first(@posts).id}
                <span class="bg-blue-100 text-blue-800 text-sm font-medium me-2 px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300 ms-3">
                  Latest
                </span>
              {/if}
            </.link>
          </h3>
          <p class="text-base font-normal text-gray-500 dark:text-gray-400">
            <.link navigate={~p"/posts/#{post.id}"}>
              {post.description}
            </.link>
          </p>
          <.tag_bar>
            <li :for={tag <- post.tags}>
              <.tag tag={tag} navigate={~p"/?tag=#{tag}"} />
            </li>
          </.tag_bar>
        </article>
      </li>
    </ol>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"tag" => tag}, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, tag)
     |> assign(:posts, Yeh35Blog.Blog.get_posts_by_tag!(tag))
     |> assign(:tag, tag)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, :posts, Yeh35Blog.Blog.all_posts())}
  end
end
