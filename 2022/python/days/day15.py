import math
import re

from ortools.sat.python import cp_model

COORDS = re.compile(r'Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)')

# sensors = '''
# Sensor at x=2, y=18: closest beacon is at x=-2, y=15
# Sensor at x=9, y=16: closest beacon is at x=10, y=16
# Sensor at x=13, y=2: closest beacon is at x=15, y=3
# Sensor at x=12, y=14: closest beacon is at x=10, y=16
# Sensor at x=10, y=20: closest beacon is at x=10, y=16
# Sensor at x=14, y=17: closest beacon is at x=10, y=16
# Sensor at x=8, y=7: closest beacon is at x=2, y=10
# Sensor at x=2, y=0: closest beacon is at x=2, y=10
# Sensor at x=0, y=11: closest beacon is at x=2, y=10
# Sensor at x=20, y=14: closest beacon is at x=25, y=17
# Sensor at x=17, y=20: closest beacon is at x=21, y=22
# Sensor at x=16, y=7: closest beacon is at x=15, y=3
# Sensor at x=14, y=3: closest beacon is at x=15, y=3
# Sensor at x=20, y=1: closest beacon is at x=15, y=3
# '''.strip().splitlines()
sensors = '''
Sensor at x=325337, y=2568863: closest beacon is at x=-518661, y=2000000
Sensor at x=3988825, y=837820: closest beacon is at x=4305648, y=2127118
Sensor at x=1611311, y=2053174: closest beacon is at x=2827226, y=1579510
Sensor at x=101890, y=3940049: closest beacon is at x=955472, y=3457514
Sensor at x=3962702, y=2558425: closest beacon is at x=4226981, y=2604726
Sensor at x=2957890, y=2160813: closest beacon is at x=2827226, y=1579510
Sensor at x=3907456, y=3325610: closest beacon is at x=3696221, y=3226373
Sensor at x=3354177, y=3435919: closest beacon is at x=3696221, y=3226373
Sensor at x=3997379, y=3071868: closest beacon is at x=3696221, y=3226373
Sensor at x=145143, y=1714962: closest beacon is at x=-518661, y=2000000
Sensor at x=611563, y=3148864: closest beacon is at x=955472, y=3457514
Sensor at x=3080405, y=3904777: closest beacon is at x=3696221, y=3226373
Sensor at x=644383, y=10732: closest beacon is at x=364635, y=-294577
Sensor at x=3229566, y=1694167: closest beacon is at x=2827226, y=1579510
Sensor at x=1600637, y=3984884: closest beacon is at x=955472, y=3457514
Sensor at x=2959765, y=2820860: closest beacon is at x=2491502, y=2897876
Sensor at x=2235330, y=3427797: closest beacon is at x=2491502, y=2897876
Sensor at x=2428996, y=210881: closest beacon is at x=2827226, y=1579510
Sensor at x=369661, y=687805: closest beacon is at x=364635, y=-294577
Sensor at x=3558476, y=2123614: closest beacon is at x=4305648, y=2127118
Sensor at x=3551529, y=2825104: closest beacon is at x=3696221, y=3226373
Sensor at x=64895, y=3577: closest beacon is at x=364635, y=-294577
Sensor at x=3079531, y=1538659: closest beacon is at x=2827226, y=1579510
'''.strip().splitlines()
sensors = [[int(n) for n in COORDS.match(sensor).groups()] for sensor in sensors]


def part1():
    beacons = set()
    start, end = math.inf, 0
    for [ax, ay, bx, by] in sensors:
        h = abs(ay - 2000000)
        r = abs(bx - ax) + abs(by - ay)
        if h > r:
            continue

        if by == 2000000:
            beacons.add((bx, by))

        w = 2 * r + 1 - 2 * h
        w //= (2 if w > 1 else 1)

        start, end = min(start, ax - w), max(end, ax + w)

    return end + 1 - start - sum(1 for x, y in beacons if start <= x <= end)


def part2():
    model = cp_model.CpModel()  # math is cool but SAT solvers (that drop down to C++) are cooler (and fast)
    m = 4000000
    x = model.NewIntVar(0, m, 'x')
    y = model.NewIntVar(0, m, 'y')

    for i, [ax, ay, bx, by] in enumerate(sensors):
        r = abs(bx - ax) + abs(by - ay)
        c = model.NewBoolVar(f'c{i}')  # deconstruct absolute values into their two XOR branches, then use an activator
        d = model.NewBoolVar(f'd{i}')  # that flips one of the branches on or off
        model.Add((x - ax + (m + r) * c + y - ay + (m + r) * d) > r)
        model.Add((x - ax + (m + r) * c - y + ay + (m + r) * (1 - d)) > r)
        model.Add((-x + ax + (m + r) * (1 - c) + y - ay + (m + r) * d) > r)
        model.Add((-x + ax + (m + r) * (1 - c) - y + ay + (m + r) * (1 - d)) > r)

    solver = cp_model.CpSolver()
    solver.Solve(model)
    return solver.Value(x) * 4000000 + solver.Value(y)
