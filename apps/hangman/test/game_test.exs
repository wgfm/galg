defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0

    assert Enum.all?(game.letters, fn letter ->
             letter =~ ~r/[a-z]/
           end)
  end

  test "state isn't changed for :won or :lost games" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    {game, _} =
      Game.new_game()
      |> Game.make_move("x")

    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    {game, _} =
      Game.new_game("wibble")
      |> Game.make_move("w")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("wibble")

    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    Enum.reduce(moves, game, fn {letter, state}, game ->
      {game, _} = Game.make_move(game, letter)
      assert game.game_state == state
      assert game.turns_left == 7
      game
    end)
  end

  test "a bad guess is recognized" do
    {game, _} =
      Game.new_game("wibble")
      |> Game.make_move("x")

    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "running out of turns loses the game" do
    game = Game.new_game("wibble")

    moves = [
      {"x", :bad_guess},
      {"q", :bad_guess},
      {"r", :bad_guess},
      {"t", :bad_guess},
      {"y", :bad_guess},
      {"p", :bad_guess},
      {"k", :lost}
    ]

    lost_game =
      Enum.reduce(moves, game, fn {letter, state}, game ->
        {game, _} = Game.make_move(game, letter)
        assert game.game_state == state
        game
      end)
  end
end
