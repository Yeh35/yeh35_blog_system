import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blog_web, BlogWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lCLYBxW9ekdPaSSribJHEl1lvJ9M7vzS5XaYrKb8lLAYX+sr0KT8BvDmBDaGRaaL",
  server: false
