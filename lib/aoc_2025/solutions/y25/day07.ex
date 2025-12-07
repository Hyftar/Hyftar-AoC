defmodule Aoc2025.Solutions.Y25.Day07 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> {char, {x, y}} end)
    end)
    |> Enum.reduce(%{}, fn {char, pos}, acc -> Map.put(acc, pos, char) end)
  end

  def part_one(problem) do
    propagate(problem, 0)
    |> then(fn {_grid, total} -> total end)
  end

  def part_two(problem) do
    problem
    |> Enum.find(fn {_pos, char} -> char == "S" end)
    |> then(fn {pos, _char} ->
      count_paths(problem, pos, %{})
    end)
    |> then(fn {count, _cache} -> count end)
  end

  def propagate(grid, total) do
    grid
    |> Enum.find(fn {_pos, char} -> char == "S" end)
    |> then(fn {pos, _char} -> propagate(grid, "S", pos, total) end)
  end

  def propagate(grid, nil, _, total), do: {grid, total}
  def propagate(grid, "|", _, total), do: {grid, total}

  def propagate(grid, "S", {x, y}, total) do
    propagate(grid, Map.get(grid, {x, y + 1}), {x, y + 1}, total)
  end

  def propagate(grid, ".", {x, y}, total) do
    grid
    |> Map.put({x, y}, "|")
    |> propagate(Map.get(grid, {x, y + 1}), {x, y + 1}, total)
  end

  def propagate(grid, "^", {x, y}, total) do
    total = total + 1

    if(
      Map.get(grid, {x + 1, y}) == ".",
      do: propagate(grid, ".", {x + 1, y}, total),
      else: {grid, total}
    )
    |> then(fn {grid, total} ->
      if(
        Map.get(grid, {x - 1, y}) == ".",
        do: propagate(grid, ".", {x - 1, y}, total),
        else: {grid, total}
      )
    end)
  end

  def count_paths(grid, {x, y}, cache) do
    pos = {x, y}

    case Map.get(cache, pos) do
      nil ->
        {count, new_cache} = count_paths(grid, Map.get(grid, pos), pos, cache)
        {count, Map.put(new_cache, pos, count)}

      cached_count ->
        {cached_count, cache}
    end
  end

  def count_paths(_grid, nil, _pos, cache), do: {1, cache}

  def count_paths(grid, "S", {x, y}, cache) do
    count_paths(grid, {x, y + 1}, cache)
  end

  def count_paths(grid, ".", {x, y}, cache) do
    count_paths(grid, {x, y + 1}, cache)
  end

  def count_paths(grid, "^", {x, y}, cache) do
    {left_paths, cache} = count_paths(grid, {x - 1, y}, cache)
    {right_paths, cache} = count_paths(grid, {x + 1, y}, cache)

    {left_paths + right_paths, cache}
  end
end
