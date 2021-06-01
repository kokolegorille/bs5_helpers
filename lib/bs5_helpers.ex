defmodule Bs5Helpers do
  @moduledoc """
  Documentation for `Bs5Helpers`.
  """

  alias __MODULE__.{
    Dropdown,
    Form
  }

  defdelegate dropdown(label, links_or_dividers, opts \\ []), to: Dropdown

  defdelegate input(form, field, opts \\ []), to: Form

  defdelegate multiselect_checkboxes(form, field, options, opts \\ []), to: Form
end
