defmodule HyftarAoc.Solutions.Y25.Day11 do
  alias AoC.Input

  use Memoize

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(
      fn [input, output] ->
        output
        |> String.split(" ")
        |> then(fn output -> {input, output} end)
      end
    )
    |> Enum.into(%{})
  end

  def part_one(graph) do
    count_paths("you", graph, "out", true, true)
  end

  def part_two(graph) do
    count_paths("svr", graph, "out", false, false)
  end

  defmemo count_paths(current, _graph, exit, visited_dac, visited_fft) when current == exit do
    if visited_dac and visited_fft, do: 1, else: 0
  end

  defmemo count_paths(current, graph, exit, visited_dac, visited_fft) do
    Map.get(graph, current, [])
    |> Enum.map(&count_paths(&1, graph, exit, visited_dac || &1 == "dac", visited_fft || &1 == "fft"))
    |> Enum.sum()
  end
end
