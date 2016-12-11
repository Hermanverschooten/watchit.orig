defmodule Watchit.Play do
  require Logger

  @sipserver Application.get_env(:watchit, :sipserver)
  @user      Application.get_env(:watchit, :user)
  @password  Application.get_env(:watchit, :password)

  def sound(opts) do
    r = System.cmd "#{curpath}/bin/caller", [
      "--sound", path(opts[:sound]),
      "--id", id,
      "--reg_uri", "sip:" <> @sipserver,
      "--proxy", "sip:" <> @sipserver,
      "--user", @user,
      "--pwd", @password,
      "--dst_uri", "sip:" <> opts[:dest]
    ]
    Logger.debug inspect(r)
  end

  defp path(snd) do
    [ curpath, "/sounds/", snd ] |> Enum.join
  end

  def id do
    [ "sip:", @user, "@", @sipserver ] |> Enum.join
  end

  def curpath do
   {:ok, path} = File.cwd
   path
  end
end
