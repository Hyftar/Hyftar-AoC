defmodule Aoc2025.Solutions.Y25.Day08 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part_one(problem, connections_amount \\ 1_000) do
    connections =
      smallest_distances(problem)
      |> Enum.take(connections_amount)

    build_groups(connections, length(problem))
    |> elem(1)
    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&(&1 * &2))
  end

  def part_two(problem) do
    number_of_points = length(problem)

    [seed | connections] =
      smallest_distances(problem)

    {initial_uf, groups} = build_groups([seed], number_of_points)

    connections
    |> Enum.reduce_while(
      {nil, initial_uf, groups},
      fn connection, {last, uf, groups} ->
        if groups |> hd() |> length() == number_of_points do
          {:halt, {last, uf, groups}}
        else
          {new_uf, new_groups} = build_groups([connection], uf)
          {:cont, {connection, new_uf, new_groups}}
        end
      end
    )
    |> then(fn {{a, b, _}, _, _} ->
      (problem |> Enum.at(a) |> elem(0)) * (problem |> Enum.at(b) |> elem(0))
    end)
  end

  defp smallest_distances(points) do
    points
    |> Stream.with_index()
    |> Stream.flat_map(fn {point1, i} ->
      points
      |> Stream.with_index()
      |> Stream.drop(i + 1)
      |> Enum.map(fn {point2, j} -> {i, j, distance(point1, point2)} end)
    end)
    |> Enum.sort_by(fn {_, _, distance} -> distance end)
  end

  defp build_groups(connections, num_points) when is_integer(num_points) do
    initial_uf =
      0..(num_points - 1)
      |> Enum.map(fn i -> {i, i} end)
      |> Map.new()

    build_groups(connections, initial_uf)
  end

  defp build_groups(connections, initial_uf) do
    uf =
      Enum.reduce(
        connections,
        initial_uf,
        fn {i, j, _distance}, acc ->
          union(acc, i, j)
        end
      )

    uf
    |> Enum.group_by(
      &find(uf, elem(&1, 0)),
      fn {point, _parent} -> point end
    )
    |> Map.values()
    |> then(fn groups -> {uf, groups} end)
  end

  defp union(uf, x, y) do
    root_x = find(uf, x)
    root_y = find(uf, y)

    if root_x == root_y do
      uf
    else
      Map.put(uf, root_x, root_y)
    end
  end

  defp find(uf, x) do
    parent = Map.get(uf, x)

    if parent == x do
      x
    else
      find(uf, parent)
    end
  end

  defp distance({x1, y1, z1}, {x2, y2, z2}) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2) + :math.pow(z2 - z1, 2))
  end
end
