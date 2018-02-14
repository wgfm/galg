defmodule TextClient.Prompter do
  alias TextClient.State

  def accept(game = %State{}) do
    IO.gets("Your guess: ")
    |> check_input(game)
  end

  defp check_input({:error, reason}, _) do
    IO.puts("Game ended: #{reason}")
    exit(:normal)
  end

  defp check_input(:eof, _) do
    IO.puts("Looks like you gave up...")
    exit(:normal)
  end

  defp check_input(input, game) do
    input = input |> String.trim
    cond do
      input =~ ~r/\A[a-zA-Z]\z/ ->
        %{ game | guess: String.downcase(input) }
      true ->
        IO.puts "Please enter a single lowercase letter"
        accept(game)
    end
  end
end
