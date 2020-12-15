input = [10, 16, 6, 0, 1, 17]
seen = {}


def do(stop):
    print_interval = stop / 10
    for i, n in enumerate(input):
        seen[n] = (i + 1, -1)
    turn = len(input)
    prev = input[-1]
    while turn != stop:
        turn += 1
        if turn % print_interval == 0:
            print(turn)
        if (prev not in seen) or seen[prev][1] == -1:
            prev = 0
            seen[prev] = (turn, seen[prev][0])
        else:
            prev = seen[prev][0] - seen[prev][1]
            if prev not in seen:
                seen[prev] = (turn, -1)
            else:
                seen[prev] = (turn, seen[prev][0])
    return prev


def part1():
    return do(2020)


def part2():
    return do(30000000)
