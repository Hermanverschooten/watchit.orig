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
    time: ~T[06:30:00],
    sound: "presence.wav",
    dest: ""
  ]

import_config "#{Mix.env}.exs"

