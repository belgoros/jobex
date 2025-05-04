defmodule JobexWeb.CustomComponents do
  use JobexWeb, :html

  attr :go_forward, :boolean
  attr :class, :string, default: nil

  def go_forward_badge(assigns) do
    ~H"""
    <p class={[
      "inline-block px-2 py-1 text-xs font-medium uppercase border rounded-md",
      @go_forward == true && "text-green-600 border-green-600",
      @go_forward == false && "text-red-600 border-red-600",
      @class
    ]}>
      <.icon name="hero-shield-check" class="w-5 h-5" />
    </p>
    """
  end
end
