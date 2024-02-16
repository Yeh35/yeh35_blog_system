defmodule Yeh35BlogWeb.ErrorJSONTest do
  use Yeh35BlogWeb.ConnCase, async: true

  test "renders 404" do
    assert Yeh35BlogWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Yeh35BlogWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
