from copy import copy

ME = [12, 40, 50, 4, 24, 15, 22, 43, 18, 21, 2, 42, 27, 36, 6, 31, 35, 20, 32, 1, 41, 14, 9, 44, 8]
CRAB = [30, 10, 47, 29, 13, 11, 49, 7, 25, 37, 33, 48, 16, 5, 45, 19, 17, 26, 46, 23, 34, 39, 28, 3, 38]


def part1():
    while len(ME) > 0 and len(CRAB) > 0:
        a, b = ME.pop(0), CRAB.pop(0)
        if a >= b:
            ME.extend([a, b])
        else:
            CRAB.extend([b, a])
    winner = CRAB if len(CRAB) > 0 else ME
    return sum((i + 1) * v for (i, v) in enumerate(reversed(winner)))


def recurse(p1, p2):
    prev = []
    while len(p1) > 0 and len(p2) > 0:
        if hash((tuple(p1), tuple(p2))) in prev:
            return 'p1'
        prev.append(hash((tuple(p1), tuple(p2))))
        a, b = p1.pop(0), p2.pop(0)
        if len(p1) >= a and len(p2) >= b:
            winner = recurse(copy(p1)[:a], copy(p2)[:b])
        else:
            winner = ('p1' if a >= b else 'p2')
        if winner == 'p1':
            p1.extend([a, b])
        else:
            p2.extend([b, a])
    return 'p2' if len(p2) > 0 else 'p1'


def part2():
    return sum((i + 1) * v for (i, v) in enumerate(reversed(ME if recurse(ME, CRAB) == 'p1' else CRAB)))
