defmodule Aoc2025.Solutions.Y25.Day01 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> Regex.run(~r/(R|L)(\d+)/, line) end)
    |> Enum.map(fn [_, direction, distance] -> {direction, String.to_integer(distance)} end)
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> Enum.reduce(
      {50, 0},
      fn {direction, distance}, {current, zero_count} ->
        new_current = apply_rotation(direction, distance, current)
        {new_current, if(new_current == 0, do: zero_count + 1, else: zero_count)}
      end
    )
    |> elem(1)
  end

  def part_two(problem) do
    problem
    |> Enum.reduce(
      {50, 0},
      fn {direction, distance}, {current, zero_count} ->
        new_current = apply_rotation(direction, distance, current)
        zeroes = count_zeroes(direction, current, distance)
        {new_current, zero_count + zeroes}
      end
    )
    |> elem(1)
  end

  defp apply_rotation("R", amount, current), do: Integer.mod(current + amount, 100)
  defp apply_rotation("L", amount, current), do: Integer.mod(current - amount, 100)

  def count_zeroes(direction, current, amount) do
    count_zeroes(direction, current, amount, 0)
  end

  def count_zeroes(_direction, _current, amount, count) when amount == 0, do: count

  def count_zeroes("R", current, amount, count) do
    if current + amount >= 100 do
      count_zeroes("R", 0, amount - (100 - current), count + 1)
    else
      final = current + amount
      if final == 0, do: count + 1, else: count
    end
  end

  def count_zeroes("L", current, amount, count) do
    if current - amount < 0 do
      new_count = if current == 0, do: count, else: count + 1
      count_zeroes("L", 99, amount - current - 1, new_count)
    else
      final = current - amount
      if final == 0, do: count + 1, else: count
    end
  end
end
