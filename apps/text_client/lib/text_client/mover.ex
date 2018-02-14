defmodule TextClient.Mover do
  alias TextClient.State

  def make_move(state = %State{}) do
    tally = Hangman.make_move(state.game_service, state.guess)
    %State{state | tally: tally}
  end
end
