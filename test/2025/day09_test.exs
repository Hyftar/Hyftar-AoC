defmodule Aoc2025.Solutions.Y25.Day09Test do
  alias AoC.Input, warn: false
  alias Aoc2025.Solutions.Y25.Day09, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "part one example" do
    input = ~S"""
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    assert 50 == solve(input, :part_one)
  end

  # Once your part one was successfully sumbitted, you may uncomment this test
  # to ensure your implementation was not altered when you implement part two.

  @part_one_solution 4_749_838_800

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 9, :part_one)
  end

  test "part two example" do
    input = ~S"""
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    assert 24 == solve(input, :part_two)
  end

  test "part two edge-case" do
    input = ~S"""
    7,1
    11,1
    11,8
    9,8
    9,5
    2,5
    2,3
    7,3
    """

    assert 24 == solve(input, :part_two)
  end

  @part_two_solution 1_624_057_680

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 9, :part_two)
  end
end
