defmodule Yeh35BlogWeb.DictionaryLive do
  # use Yeh35BlogWeb.Live
  use Yeh35BlogWeb, :live_view

  def mount(params, session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    apply(__MODULE__, assigns.live_action, [assigns])
  end
end
