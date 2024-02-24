defmodule Yeh35BlogWeb.Live do
  use Yeh35BlogWeb, :live_view

  defmacro __using__(_opts) do
    quote do
      use Yeh35BlogWeb, :live_view
      import Yeh35BlogWeb.Live

      # 기타 공통 기능을 여기에 추가할 수 있습니다.
    end
  end
end
