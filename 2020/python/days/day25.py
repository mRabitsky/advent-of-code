keys = [13233401, 6552760]


def part1():
    loop_size = 10000000
    while pow(7, loop_size, 20201227) != keys[0]:
        loop_size += 1
    return pow(keys[1], loop_size, 20201227)


def part2():
    return 'Done!'
