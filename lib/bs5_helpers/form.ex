defmodule Bs5Helpers.Form do
  @moduledoc """
  Documentation for `Bs5Helpers.Form`.
  """

  use Phoenix.HTML
  alias Bs5Helpers.ErrorHelpers

  @doc """
  Form Input helper
  http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/

  ## Options

    * `:as` - set the field type, eg: as: :textarea.
    * `:html_opts` - additional input opts, eg: html_opts: [rows: 10].
    * `:error` - set asdditional error field, eg: title and slug.

  ### For select

    * `:options` - the list of options for a select input.

  """
  def input(form, field, opts \\ []) do
    type = opts[:as] || Phoenix.HTML.Form.input_type(form, field)
    error_field = opts[:error] || field
    do_input(type, error_field, form, field, opts)
  end

  @doc """
  Renders multiple checkboxes.

  ref: https://dev.to/ricardoruwer/many-to-many-associations-in-elixir-and-phoenix-21pm

  ## Example

      iex> multiselect_checkboxes(
             f,
             :amenities,
             Enum.map(@amenities, fn c -> { c.name, c.id } end),
             selected: Enum.map(@changeset.data.amenities,&(&1.id))
           )
      <div class="checkbox">
        <label>
          <input name="property[amenities][]" id="property_amenities_1" type="checkbox" value="1" checked>
          <input name="property[amenities][]" id="property_amenities_2" type="checkbox" value="2">
        </label>
      </div
  """

  def multiselect_checkboxes(form, field, options, opts \\ []) do
    {selected, _} = get_selected_values(form, field, opts)
    selected_as_strings = Enum.map(selected, &"#{&1}")

    # Use inline mode by default
    class = opts[:class] || "form-check form-check-inline"
    # By default, input is active (not disabled)
    disabled = opts[:disabled]

    for {value, key} <- options, into: [] do
      id = input_id(form, field, key)

      content_tag(:div, class: class) do
        [
          tag(:input,
            name: input_name(form, field) <> "[]",
            id: id,
            class: "form-check-input",
            type: "checkbox",
            value: key,
            checked: Enum.member?(selected_as_strings, "#{key}"),
            disabled: disabled
          ),
          content_tag(:label, value, class: "form-check-label", for: id)
        ]
      end
    end
  end

  # Checkbox
  defp do_input(:checkbox = type, error_field, form, field, opts) do
    error = get_error(error_field, form, field)
    html_opts = opts[:html_opts] || []
    label_txt = opts[:label] || humanize(field)
    wrapper_class = html_opts[:wrapper_class] || "form-group form-check"
    wrapper_opts = [class: wrapper_class]

    label_opts = label_options(html_opts[:required], "form-check-label")

    input_opts =
      html_opts ++
        [class: "form-check-input #{state_class(form, field, error_field)}"]

    content_tag :div, wrapper_opts do
      label = label(form, field, label_txt, label_opts)
      input = input(type, form, field, input_opts)
      error = error
      [input, label, error]
    end
  end

  # File input
  defp do_input(:file_input = type, error_field, form, field, opts) do
    error = get_error(error_field, form, field)
    html_opts = opts[:html_opts] || []
    label_txt = opts[:label] || humanize(field)
    # Add some margin at the bottom of wrapper!
    wrapper_class = html_opts[:wrapper_class] || "custom-file mb-4"

    wrapper_opts = [class: wrapper_class]
    label_opts = label_options(html_opts[:required], "custom-file-label")

    input_opts =
      html_opts ++
        [class: "custom-file-input #{state_class(form, field, error_field)}"]

    content_tag :div, wrapper_opts do
      label = label(form, field, label_txt, label_opts)
      input = input(type, form, field, input_opts)

      # Custom, check if previous attachment exists!
      previous = display_current_attachment(form.data, field)

      error = error
      [label, input, previous, error]
    end
  end

  # Select
  defp do_input(:select = type, error_field, form, field, opts) do
    error = get_error(error_field, form, field)
    html_opts = opts[:html_opts] || []
    options = opts[:options] || []
    label_txt = opts[:label] || humanize(field)
    wrapper_class = html_opts[:wrapper_class] || "form-group"

    wrapper_opts = [class: wrapper_class]
    label_opts = label_options(html_opts[:required])

    input_opts =
      html_opts ++
        [class: "form-select #{state_class(form, field, error_field)}"]

    content_tag :div, wrapper_opts do
      label = label(form, field, label_txt, label_opts)
      input = input(type, form, field, options, input_opts)
      error = error
      [label, input, error]
    end
  end

  # Textarea
  defp do_input(:textarea, error_field, form, field, opts) do
    error = get_error(error_field, form, field)
    html_opts = opts[:html_opts] || []
    label_txt = opts[:label] || humanize(field)
    wrapper_class = html_opts[:wrapper_class] || "form-group"

    wrapper_opts = [class: wrapper_class]
    label_opts = label_options(html_opts[:required])

    input_opts =
      html_opts ++
        [class: "form-control #{state_class(form, field, error_field)}"]

    content_tag :div, wrapper_opts do
      label = label(form, field, label_txt, label_opts)
      input = textarea(form, field, input_opts)
      error = error
      [label, input, error]
    end
  end

  # Hidden
  defp do_input(:hidden, _error_field, form, field, opts) do
    html_opts = opts[:html_opts] || []
    hidden_input(form, field, html_opts)
  end

  # Multi select checkboxes

  # Default

  # EXAMPLE USING FLOATING LABEL...

  # defp do_input(type, error_field, form, field, opts) do
  #   error = get_error(error_field, form, field)
  #   html_opts = opts[:html_opts] || []
  #   label_txt = opts[:label] || humanize(field)
  #   wrapper_class = html_opts[:wrapper_class] || "form-floating"

  #   wrapper_opts = [class: wrapper_class]
  #   label_opts = label_options(html_opts[:required])

  #   input_opts =
  #     html_opts ++
  #       [class: "form-control #{state_class(form, field, error_field)}"]

  #   content_tag :div, wrapper_opts do
  #     label = label(form, field, label_txt, label_opts)
  #     input = input(type, form, field, input_opts)
  #     error = error
  #     [input, label, error]
  #   end
  # end

  defp do_input(type, error_field, form, field, opts) do
    error = get_error(error_field, form, field)
    html_opts = opts[:html_opts] || []
    label_txt = opts[:label] || humanize(field)
    wrapper_class = html_opts[:wrapper_class] || "form-group"

    wrapper_opts = [class: wrapper_class]
    label_opts = label_options(html_opts[:required])

    input_opts =
      html_opts ++
        [class: "form-control #{state_class(form, field, error_field)}"]

    content_tag :div, wrapper_opts do
      label = label(form, field, label_txt, label_opts)
      input = input(type, form, field, input_opts)
      error = error
      [label, input, error]
    end
  end

  # Helpers
  defp label_options(required, class \\ "control-label")
  defp label_options(nil, class), do: [class: class]
  defp label_options(false, class), do: [class: class]
  defp label_options(_, class), do: [class: "#{class} required"]

  # Display previous file name for file input
  defp display_current_attachment(source, field) do
    attachment = Map.get(source, field)

    if attachment do
      content_tag(:small, "Current File : #{attachment.file_name}", class: "form-text text-muted")
    else
      # Should not returns nil! This is included in a content tag
      ""
    end
  end

  defp state_class(form, field, error_field) when field == error_field do
    cond do
      # The form was not yet submitted, or the source is not a changeset
      is_nil(Map.get(form.source, :action)) -> ""
      form.errors[field] -> "is-invalid"
      true -> "is-valid"
    end
  end

  # Check for multiple errors
  defp state_class(form, field, error_field) do
    cond do
      # The form was not yet submitted, or the source is not a changeset
      is_nil(Map.get(form.source, :action)) -> ""
      form.errors[field] -> "is-invalid"
      form.errors[error_field] -> "is-invalid"
      true -> "is-valid"
    end
  end

  defp get_error(error_field, form, field) do
    case error_field == field do
      true ->
        ErrorHelpers.error_tag(form, error_field)
      _ ->
        [error_field, field]
        |> Enum.flat_map(fn f ->
          ErrorHelpers.error_tag(form, f)
        end)
    end
  end

  # Implement clauses below for custom inputs.
  # defp input(:datepicker, form, field, input_opts) do
  #   raise "not yet implemented"
  # end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end

  # For select
  defp input(type, form, field, options, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, options, input_opts])
  end

  # For multiple checkboxes
  defp get_selected_values(form, field, opts) do
    {selected, opts} = Keyword.pop(opts, :selected)
    param = field_to_string(field)

    case form do
      %{params: %{^param => sent}} ->
        {sent, opts}

      _ ->
        {selected || input_value(form, field), opts}
    end
  end

  defp field_to_string(field) when is_atom(field), do: Atom.to_string(field)
  defp field_to_string(field) when is_binary(field), do: field
end
