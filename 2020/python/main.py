import sys

from days import day1, day2, day3, day4, day5, day6, day7, day8, day9, day10, day11, day12, day13, day14, day15, day16, day17, day18, day19, day20, day21, day22, day23, day24, day25

days = [[day1.part1, day1.part2],
        [day2.part1, day2.part2],
        [day3.part1, day3.part2],
        [day4.part1, day4.part2],
        [day5.part1, day5.part2],
        [day6.part1, day6.part2],
        [day7.part1, day7.part2],
        [day8.part1, day8.part2],
        [day9.part1, day9.part2],
        [day10.part1, day10.part2],
        [day11.part1, day11.part2],
        [day12.part1, day12.part2],
        [day13.part1, day13.part2],
        [day14.part1, day14.part2],
        [day15.part1, day15.part2],
        [day16.part1, day16.part2],
        [day17.part1, day17.part2],
        [day18.part1, day18.part2],
        [day19.part1, day19.part2],
        [day20.part1, day20.part2],
        [day21.part1, day21.part2],
        [day22.part1, day22.part2],
        [day23.part1, day23.part2],
        [day24.part1, day24.part2],
        [day25.part1, day25.part2]]

if __name__ == '__main__':
    day: int = int(sys.argv[1].strip()) - 1
    part: str = sys.argv[2]
    if part == 'both':
        print(days[day][0]())
        print(days[day][1]())
    else:
        print(days[day][int(part.strip()) - 1]())
