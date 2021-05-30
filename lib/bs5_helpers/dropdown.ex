defmodule Bs5Helpers.Dropdown do
  @moduledoc """
  Documentation for `Bs5Helpers.Dropdown`.
  """

  use Phoenix.HTML

  def dropdown(label, links_or_dividers, opts \\ []) do
    wrapper = opts[:wrapper] || :div

    wrapper_html = Keyword.merge([class: "dropdown"], (opts[:wrapper_html] || []), fn _k, v1, v2 ->
      if v1, do: "#{v1} #{v2}", else: v2
    end)

    toggle_html = Keyword.merge(
      [
        class: "dropdown-toggle",
        href: "#",
        role: "button",
        data_bs_toggle: "dropdown",
        aria_expanded: false
      ],
      (opts[:toggle_html] || []),
      fn _k, v1, v2 ->
        if v1, do: "#{v1} #{v2}", else: v2
      end
    )

    menu_html = Keyword.merge([class: "dropdown-menu"], (opts[:menu_html] || []), fn _k, v1, v2 ->
      if v1, do: "#{v1} #{v2}", else: v2
    end)

    content_tag(wrapper, wrapper_html) do
      [
        dropdown_toggle(label, toggle_html),
        dropdown_menu(links_or_dividers, menu_html)
      ]
    end
  end

  defp dropdown_toggle(label, input_html) do
    content_tag(:a, input_html) do
      label
    end
  end

  defp dropdown_menu(links_or_dividers, input_html) do
    content_tag(:ul, input_html) do
      for link <- links_or_dividers do
        content_tag(:li) do
          case link do
            :divider -> divider()
            {caption, opts} -> link(caption, opts)
          end
        end
      end
    end
  end

  defp divider do
    content_tag(:div) do
      content_tag(:hr, nil, class: "dropdown-divider")
    end
  end
end
