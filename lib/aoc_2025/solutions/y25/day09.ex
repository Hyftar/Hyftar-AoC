defmodule Aoc2025.Solutions.Y25.Day09 do
  require Integer
  alias AoC.Input

  def parse(input, :part_one) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)
  end

  def parse(input, :part_two) do
    points =
      Input.read!(input)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn row -> row |> Enum.map(&String.to_integer/1) |> List.to_tuple() end)

    points
    |> Enum.concat(Enum.take(points, 1))
    |> Enum.chunk_every(2, 1, :discard)
    |> then(fn lines -> {points, lines} end)
  end

  def part_one(problem) do
    problem
    |> Enum.with_index()
    |> Enum.map(fn {a, i} ->
      problem
      |> Stream.drop(i)
      |> Stream.map(&{a, &1, square_size(a, &1)})
      |> Enum.max_by(&elem(&1, 2))
    end)
    |> Enum.max_by(&elem(&1, 2))
    |> elem(2)
  end

  def part_two(problem) do
    {points, lines} = problem

    points
    |> Enum.with_index()
    |> Enum.flat_map(fn {a, i} ->
      points
      |> Stream.drop(i)
      |> Stream.map(&{a, &1, square_size(a, &1)})
    end)
    |> Enum.sort_by(fn {_, _, size} -> size end, :desc)
    |> Enum.filter(fn {a1, a2, _} ->
      not Enum.any?(
        lines,
        fn [b1, b2] ->
          collision?({a1, a2}, {b1, b2}) or
            collision?({a1, a2}, {b1, b1}) or
            collision?({a1, a2}, {b2, b2})
        end
      )
    end)
    |> Enum.filter(fn {{x1, y1}, {x2, y2}, _} ->
      Enum.count(
        lines,
        fn [b1, b2] ->
          collision?({{min(x1, x2) + 1, 0}, {min(x1, x2) + 1, min(y1, y2) + 1}}, {b1, b2})
        end
      )
      |> Integer.is_odd()
    end)
    |> hd()
    |> elem(2)
  end

  def collision?({{x1, y1}, {x2, y2}}, {{x3, y3}, {x4, y4}}) do
    a_left = min(x1, x2)
    a_right = max(x1, x2)
    a_top = min(y1, y2)
    a_bottom = max(y1, y2)

    b_left = min(x3, x4)
    b_right = max(x3, x4)
    b_top = min(y3, y4)
    b_bottom = max(y3, y4)

    not (a_left >= b_right || a_right <= b_left || a_bottom <= b_top || a_top >= b_bottom)
  end

  defp square_size({x1, y1}, {x2, y2}) do
    (Kernel.abs(x2 - x1) + 1) * (Kernel.abs(y2 - y1) + 1)
  end
end
