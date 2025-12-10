defmodule Aoc2025.Solutions.Y25.Day10 do
  alias AoC.Input

  def parse(input, _part) do
    Input.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    lights_pattern =
      Regex.run(~r/\[([.#]+)\]/, line)
      |> then(fn [_, pattern] -> pattern end)
      |> String.graphemes()
      |> Enum.map(&(&1 == "#"))

    joltage =
      Regex.run(~r/\{([0-9,]+)\}/, line)
      |> then(fn [_, joltage] -> joltage end)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    switches_patterns =
      Regex.scan(~r/\(([0-9,]+)\)/, line)
      |> Enum.map(fn [_, switch_pattern] ->
        switch_pattern |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)

    {lights_pattern, switches_patterns, joltage}
  end

  def part_one(problem) do
    problem
    |> Stream.map(&solve_with_bfs(&1))
    |> Stream.map(&length(&1))
    |> Enum.sum()
  end

  def solve_with_bfs({lights_pattern, switches_patterns, _joltage}) do
    initial_state = List.duplicate(false, length(lights_pattern))

    bfs([{initial_state, []}], MapSet.new([initial_state]), lights_pattern, switches_patterns)
  end

  def bfs([{current_state, path} | _], _visited, target, _switches) when current_state == target,
    do: path

  def bfs([], _visited, _target, _switches), do: nil

  def bfs([{current_state, path} | rest], visited, target, switches) do
    next_states =
      switches
      |> Enum.with_index()
      |> Enum.reduce(
        [],
        fn {switch, index}, acc ->
          new_state = apply_switch(current_state, switch)

          if MapSet.member?(visited, new_state) do
            acc
          else
            [{new_state, [index | path]} | acc]
          end
        end
      )

    next_visited =
      next_states
      |> Enum.reduce(
        visited,
        fn {state, _path}, visited ->
          MapSet.put(visited, state)
        end
      )

    bfs(rest ++ next_states, next_visited, target, switches)
  end

  def apply_switch(state, switch_pattern) do
    Enum.reduce(
      switch_pattern,
      state,
      fn index, acc ->
        List.replace_at(acc, index, not Enum.at(acc, index))
      end
    )
  end

  def part_two(problem) do
    problem
    |> Stream.map(
      fn {_lights_pattern, switches_patterns, joltage} ->
        base_pattern = List.duplicate(0, length(joltage))

        switches_patterns
        |> Enum.map(
          fn switch_pattern ->
            switch_pattern
            |> Enum.reduce(
              base_pattern,
              fn index, acc ->
                List.replace_at(acc, index, 1)
              end
            )
          end
        )
        |> then(fn patterns -> {patterns, joltage} end)
      end
    )
    |> Stream.map(&solve_with_highs(&1))
    |> Enum.sum()
  end

  defp solve_with_highs({patterns, joltage}) do
    lp_content = generate_lp(patterns, joltage)

    tmp_file = "tmp/highs_problem_#{:erlang.unique_integer([:positive])}.lp"

    File.write!(tmp_file, lp_content)

    {output, 0} = System.cmd("/opt/homebrew/bin/highs", [tmp_file], stderr_to_stdout: true)

    File.rm(tmp_file)

    case Regex.run(~r/Primal bound\s+(\d+)/, output) do
      [_, value] -> String.to_integer(value)
      nil -> 0
    end
  end

  defp generate_lp(patterns, joltage) do
    var_names =
      patterns
      |> Enum.with_index()
      |> Enum.map(fn {_pattern, idx} -> "x#{idx}" end)

    objective = "Minimize\n  " <> Enum.join(var_names, " + ") <> "\n"

    constraints =
      joltage
      |> Enum.with_index()
      |> Enum.map(fn {target, row_idx} ->
        terms =
          patterns
          |> Enum.zip(var_names)
          |> Enum.filter(fn {pattern, _var} -> Enum.at(pattern, row_idx) > 0 end)
          |> Enum.map(fn {pattern, var} -> "#{Enum.at(pattern, row_idx)} #{var}" end)
          |> Enum.join(" + ")

        "  c#{row_idx}: #{terms} = #{target}"
      end)
      |> Enum.join("\n")

    bounds =
      var_names
      |> Enum.map(fn var -> "  0 <= #{var}" end)
      |> Enum.join("\n")

    general = "  " <> Enum.join(var_names, " ")

    """
    #{objective}
    Subject To
    #{constraints}
    Bounds
    #{bounds}
    General
    #{general}
    End
    """
  end
end
