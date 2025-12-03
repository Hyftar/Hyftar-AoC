defmodule Aoc2025.Solutions.Y25.Day02 do
  require Integer
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(
      &(String.split(&1, "-", trim: true)
        |> Enum.map(fn e -> String.to_integer(e) end))
    )
  end

  def part_one(problem) do
    problem
    |> Stream.flat_map(fn [min, max] ->
      min..max
      |> Stream.map(fn x -> Integer.to_string(x) end)
      |> Stream.filter(fn x -> String.length(x) |> Integer.is_even() end)
      |> Stream.filter(fn x ->
        half = String.length(x) |> div(2)
        {left, right} = String.split_at(x, half)
        left == right
      end)
      |> Enum.to_list()
    end)
    |> Stream.map(fn x -> String.to_integer(x) end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Stream.flat_map(fn [min, max] ->
      min..max
      |> Stream.map(fn x -> Integer.to_string(x) end)
      |> Stream.filter(fn x -> Regex.match?(~r/^(\d+)(\1)+$/, x) end)
      |> Enum.to_list()
    end)
    |> Stream.map(fn x -> String.to_integer(x) end)
    |> Enum.sum()
  end
end
