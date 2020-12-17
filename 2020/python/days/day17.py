import itertools as it
import numpy as np

string = """..##.#.#
.#####..
#.....##
##.##.#.
..#...#.
.#..##..
.#...#.#
#..##.##"""
ls = string.strip().split('\n')
arr = np.asarray([[[1 if c == '#' else 0 for c in l] for l in ls]])


def neighbours(coords):
    ns = [tuple(sum(n) for n in zip(coords, offsets)) for offsets in it.product([-1, 0, 1], repeat=len(coords)) if any(offsets)]
    return [arr[n] for n in ns if all([0 <= n[dim] < (len(arr) if dim < 1 else len(arr[(0,) * dim])) for dim in range(0, len(coords))])]


def step(n_func, tolerance):
    changes = []
    for coords in map(tuple, np.argwhere(arr == 0)):
        if sum(n_func(coords)) == tolerance:
            changes.append((coords, 1))
    for coords in map(tuple, np.argwhere(arr == 1)):
        s = sum(n_func(coords))
        if (tolerance - 1) > s or s > tolerance:
            changes.append((coords, 0))
    for c in changes:
        arr[c[0]] = c[1]
    return len(changes)


def run():
    global arr
    for i in range(6):
        arr = np.pad(arr, 1, mode='constant')
        step(neighbours, 3)
    return np.count_nonzero(arr)


def part1():
    return run()


def part2():
    global arr
    arr = np.asarray([arr])
    return run()
