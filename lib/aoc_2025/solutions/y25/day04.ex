defmodule Aoc2025.Solutions.Y25.Day04 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.with_index()
    |> Stream.flat_map(fn {row, y_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {char, x_index} ->
        {x_index, y_index, char}
      end)
    end)
    |> Enum.reduce(%{}, fn {x, y, char}, acc -> Map.put(acc, {x, y}, char) end)
  end

  def part_one(problem) do
    problem
    |> Enum.count(fn
      {{x, y}, "@"} ->
        get_neighbours(problem, {x, y})
        |> Enum.count(&(&1 == "@"))
        |> then(&(&1 < 4))

      {{_x, _y}, _} ->
        false
    end)
  end

  def part_two(problem) do
    problem
    |> remove_all(0)
    |> elem(1)
  end

  def get_neighbours(grid, {x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1}
    ]
    |> Enum.map(fn {x, y} -> Map.get(grid, {x, y}) end)
  end

  def remove_all(grid, removed_count) do
    positions_to_remove =
      grid
      |> Enum.filter(fn {{x, y}, _char} -> can_remove?(grid, {x, y}) end)

    if Enum.any?(positions_to_remove) do
      positions_to_remove
      |> Enum.reduce(grid, fn {{x, y}, _}, acc -> Map.put(acc, {x, y}, ".") end)
      |> remove_all(removed_count + Enum.count(positions_to_remove))
    else
      {grid, removed_count}
    end
  end

  def can_remove?(grid, {x, y}) do
    if Map.get(grid, {x, y}) != "@" do
      false
    else
      get_neighbours(grid, {x, y})
      |> Enum.count(&(&1 == "@"))
      |> then(&(&1 < 4))
    end
  end
end
