defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  def word_so_far(tally) do
    tally.letters
    |> Enum.join(" ")
  end

  @responses %{
    won: {:success, "Молодец, ты выиграл!"},
    lost: {:danger, "Пизка, ты проиграл!"},
    good_guess: {:success, "Хорошо!"},
    bad_guess: {:warning, "Плохо!"},
    already_used: {:info, "Так же самое"},
    initializing: {:info, "Добро пожаловать!"}
  }

  def game_ended?(%{game_state: game_state}) do
    game_state in [:lost, :won]
  end

  def new_game_button(conn) do
    button("New game", to: hangman_path(conn, :create))
  end

  def turn(left, n) when n >= left do
  end
  def turn(_left, _n), do: "dim"

  def used_letters(letters) do
    letters
    |> Enum.sort
    |> Enum.join(" ")
  end

  def game_state(state) do
    @responses[state]
    |> alert
  end

  defp alert({nil, _}), do: ""
  defp alert({class, message}) do
    """
    <div class="alert alert-#{class}">
      #{message}
    </div>
    """
    |> raw
  end
end
