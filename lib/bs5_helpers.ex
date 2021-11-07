defmodule Bs5Helpers do
  @moduledoc """
  Documentation for `Bs5Helpers`.
  """

  alias __MODULE__.{
    Alert,
    Dropdown,
    Form
  }

  defdelegate alert(message, mode), to: Alert

  defdelegate live_alert(message, mode), to: Alert

  defdelegate dropdown(label, links_or_dividers, opts \\ []), to: Dropdown

  defdelegate input(form, field, opts \\ []), to: Form

  defdelegate multiselect_checkboxes(form, field, options, opts \\ []), to: Form
end
