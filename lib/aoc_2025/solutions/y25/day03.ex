defmodule Aoc2025.Solutions.Y25.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  def part_one(problem) do
    problem
    |> Enum.map(&find_max_of_length(&1, 2))
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> Enum.map(&find_max_of_length(&1, 12))
    |> Enum.sum()
  end

  def combine(left, right), do: left * 10 + right

  def max_with_index(enumerable) do
    enumerable
    |> Enum.with_index()
    |> Enum.reduce(
      %{index: 0, max_value: nil},
      fn {x, index}, acc ->
        if is_nil(acc.max_value) or x > acc.max_value do
          %{index: index, max_value: x}
        else
          acc
        end
      end
    )
  end

  def find_max_of_length(row, max_count) do
    find_max_of_length(row, max_count, "")
  end

  def find_max_of_length(_row, 0, result), do: String.to_integer(result)

  def find_max_of_length([], _, result), do: String.to_integer(result)

  def find_max_of_length(row, max_count, result) do
    length = length(row)

    %{max_value: max_value, index: max_index} =
      row
      |> Enum.take(length - max_count + 1)
      |> max_with_index()

    find_max_of_length(
      Enum.slice(row, max_index + 1, length),
      max_count - 1,
      result <> Integer.to_string(max_value)
    )
  end
end
