# Watchit

Watch a GPIO pin on a raspberry pi and if triggered, call a SIP number and play a message.
Set a daily alarm and call a SIP number, play a message at that time.

## Installation

This currently depends on python with pjsua installed.

  1. clone the repo
  2. Fill in the missing information in config/config.exs
  3. start with:
     ```
     MIX_ENV=prod mix compile
     MIX_ENV=prod elixir --detached -S mix run --no-halt
     ```
