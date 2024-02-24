defmodule Yeh35BlogWeb.HeaderComponents do
  use Phoenix.Component

  attr :href, :string, default: nil, doc: "The URL to navigate to"
  attr :label, :string, default: nil

  def nav_item(assigns) do
    ~H"""
    <li>
      <a
        href={@href}
        class="block py-2 pl-3 pr-4 text-gray-700 border-b border-gray-100 hover:bg-gray-50 lg:hover:bg-transparent lg:border-0 lg:hover:text-blue-700 lg:p-0 dark:text-gray-400 lg:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white lg:dark:hover:bg-transparent dark:border-gray-700"
      >
        <%= @label %>
      </a>
    </li>
    """
  end
end
