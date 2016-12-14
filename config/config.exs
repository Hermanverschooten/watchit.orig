# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :watchit,
  sipserver: "fill in",
  user: "fill in",
  password: "fill in",
  door: [
    sound: "emergency.wav",
    pin: 22,
    dest: ""
  ],
  fire: [
    sound: "fire.wav",
    pin: 27,
    dest: ""
  ],
  alarm: [
    time: ~T[07:30:00],
    sound: "presence.wav",
    dest: ""
  ]

config :logger,
  backends: [{LoggerFileBackend, :info}]

config :logger, :info,
  path: "/var/log/watchit.log",
  level: :debug

config :distillery,
  no_warn_missing: [ :elixir_make ]

config :rollbax,
  access_token: "91a971a2496947889fa0f52c2abb382f",
  environment: "production"

import_config "#{Mix.env}.exs"

