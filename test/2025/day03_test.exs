defmodule Aoc2025.Solutions.Y25.Day03Test do
  alias AoC.Input, warn: false
  alias Aoc2025.Solutions.Y25.Day03, as: Solution, warn: false
  use ExUnit.Case, async: true

  defp solve(input, part) do
    problem =
      input
      |> Input.as_file()
      |> Solution.parse(part)

    apply(Solution, part, [problem])
  end

  test "max with index should return indexed max" do
    assert %{index: 2, max_value: 9} == Solution.max_with_index([1, 3, 9, 7, 3, 2, 6])
  end

  test "find max of length should work as expected" do
    assert 987_654_321_111 ==
             Solution.find_max_of_length([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 12)

    assert 811_111_111_119 ==
             Solution.find_max_of_length([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9], 12)

    assert 434_234_234_278 ==
             Solution.find_max_of_length([2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8], 12)
  end

  test "part one example" do
    input = ~S"""
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

    assert 357 == solve(input, :part_one)
  end

  @part_one_solution 17694

  test "part one solution" do
    assert {:ok, @part_one_solution} == AoC.run(2025, 3, :part_one)
  end

  test "part two example" do
    input = ~S"""
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

    assert 3_121_910_778_619 == solve(input, :part_two)
  end

  @part_two_solution 175_659_236_361_660

  test "part two solution" do
    assert {:ok, @part_two_solution} == AoC.run(2025, 3, :part_two)
  end
end
