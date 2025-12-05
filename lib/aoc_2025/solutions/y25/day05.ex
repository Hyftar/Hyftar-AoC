defmodule Aoc2025.Solutions.Y25.Day05 do
  alias AoC.Input

  def parse(input, _part) do
    [ranges, ids] =
      Input.read!(input)
      |> String.split("\n\n", trim: true)

    ids =
      ids
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    ranges =
      ranges
      |> String.split("\n")
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(fn [a, b] -> String.to_integer(a)..String.to_integer(b) end)

    {ranges, ids}
  end

  def part_one({ranges, ids}) do
    ids
    |> Enum.filter(fn id -> Enum.any?(ranges, &(id in &1)) end)
    |> Enum.count()
  end

  def part_two({ranges, _}) do
    ranges
    |> Enum.reduce(
      [],
      fn range, acc ->
        insert_range(acc, range)
      end
    )
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  def insert_range(ranges, range) do
    ranges
    |> Enum.find_index(fn x -> not Range.disjoint?(x, range) end)
    |> case do
      nil ->
        [range | ranges]

      index ->
        {previous, rest} =
          ranges
          |> List.pop_at(index)

        previous
        |> combine_ranges(range)
        |> then(&insert_range(rest, &1))
    end
  end

  def combine_ranges(a, b) do
    min_a..max_a//_ = a
    min_b..max_b//_ = b

    min(min_a, min_b)..max(max_a, max_b)
  end
end
