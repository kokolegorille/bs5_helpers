defmodule Bs5Helpers.Alert do
  @moduledoc """
  Documentation for `Bs5Helpers.Alert`.
  """

  use Phoenix.HTML

  def alert(nil, _mode) do
    #noop
  end
  def alert(message, mode) do
    class = "alert alert-#{mode} alert-dismissible fade show"

    content_tag(:div, class: class, role: "alert") do
      [
        message,
        content_tag(:button,
          nil,
          type: :button,
          class: "btn-close",
          "data-bs-dismiss": :alert,
          "aria-label": "Close"
        )
      ]
    end
  end

  def live_alert(nil, _mode) do
    #noop
  end
  def live_alert(message, mode) do
    class = "alert alert-#{mode} alert-dismissible fade show"

    content_tag(:div,
      class: class,
      role: "alert",
      phx_click: "lv:clear-flash",
      phx_value_key: mode
    ) do
      [
        message,
        content_tag(:button,
          nil,
          type: :button,
          class: "btn-close",
          "data-bs-dismiss": :alert,
          "aria-label": "Close"
        )
      ]
    end
  end
end
