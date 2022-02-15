defmodule HotCodeReloadingWeb.Socket.UserTracker do
  use Phoenix.Presence,
    otp_app: :hot_code_reloading,
    pubsub_server: HotCodeReloading.PubSub

  def track_user(pid, topic, id, user_info) do
    track(pid, topic, id, %{user_info: user_info})
  end

  def update_user(pid, topic, id, user_info) do
    update(pid, topic, id, %{user_info: user_info})
  end

  def untrack_user(pid, topic, id) do
    untrack(pid, topic, id)
  end

  def user_list(topic) do
    list(topic)
    |> user_info()
  end

  def user_info(presense) do
    presense
    |> Stream.map(fn {_id, %{metas: metas}} ->
      metas
      |> Stream.map(fn meta -> meta[:user_info] end)
      |> Stream.filter(fn userinfo -> userinfo end)
      |> target()
      |> Enum.to_list()
    end)
    |> Enum.to_list()
  end

  defp target(list) do
    list
    |> Stream.map(fn l -> l end)
  end
end
