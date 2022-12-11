import math
from collections import namedtuple
from typing import Callable

import numpy as np

Monkey = namedtuple('Monkey', ['items', 'op', 'condition', 'consequent', 'alternative'])
monkeys = [
    Monkey([59, 74, 65, 86], lambda old: old * 19, 7, 6, 2),
    Monkey([62, 84, 72, 91, 68, 78, 51], lambda old: old + 1, 2, 2, 0),
    Monkey([78, 84, 96], lambda old: old + 8, 19, 6, 5),
    Monkey([97, 86], lambda old: old * old, 3, 1, 0),
    Monkey([50], lambda old: old + 6, 13, 3, 1),
    Monkey([73, 65, 69, 65, 51], lambda old: old * 17, 11, 4, 7),
    Monkey([69, 82, 97, 93, 82, 84, 58, 63], lambda old: old + 5, 5, 5, 7),
    Monkey([81, 78, 82, 76, 79, 80], lambda old: old + 3, 17, 3, 4),
]


def _engage_in_monkey_business(rounds: int, relieve_worry: Callable[[int], int]) -> int:
    inspections = np.zeros(len(monkeys), dtype=int)
    for _ in range(rounds):
        for i, m in enumerate(monkeys):
            inspections[i] += len(m.items)
            for item in m.items:
                worry = relieve_worry(m.op(item))
                monkeys[m.consequent if worry % m.condition == 0 else m.alternative].items.append(worry)
            m.items.clear()

    return inspections[np.argpartition(inspections, -2)[-2:]].prod()


def part1():
    return _engage_in_monkey_business(20, lambda x: x // 3)


def part2():
    lcm = math.lcm(*[m.condition for m in monkeys])
    return _engage_in_monkey_business(10000, relieve_worry=lambda x: x % lcm)
