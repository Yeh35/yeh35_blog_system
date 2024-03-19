defmodule Yeh35BlogWeb.Layouts do
  use Yeh35BlogWeb, :html

  embed_templates "layouts/*"
  embed_sface "layouts/root.sface"
  embed_sface "layouts/app.sface"
end
