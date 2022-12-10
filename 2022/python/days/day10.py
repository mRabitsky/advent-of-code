lines = '''
addx 1
noop
addx 29
addx -24
addx 4
addx 3
addx -2
addx 3
addx 1
addx 5
addx 3
addx -2
addx 2
noop
noop
addx 7
noop
noop
noop
addx 5
addx 1
noop
addx -38
addx 21
addx 8
noop
addx -19
addx -2
addx 2
addx 5
addx 2
addx -12
addx 13
addx 2
addx 5
addx 2
addx -18
addx 23
noop
addx -15
addx 16
addx 7
noop
noop
addx -38
noop
noop
noop
noop
noop
noop
addx 8
addx 2
addx 3
addx -2
addx 4
noop
noop
addx 5
addx 3
noop
addx 2
addx 5
noop
noop
addx -2
noop
addx 3
addx 6
noop
addx -38
addx -1
addx 35
addx -6
addx -19
addx -2
addx 2
addx 5
addx 2
addx 3
noop
addx 2
addx 3
addx -2
addx 2
noop
addx -9
addx 16
noop
addx 9
addx -3
addx -36
addx -2
addx 11
addx 22
addx -28
noop
addx 3
addx 2
addx 5
addx 2
addx 3
addx -2
addx 2
noop
addx 3
addx 2
noop
addx -11
addx 16
addx 2
addx 5
addx -31
noop
addx -6
noop
noop
noop
noop
noop
addx 7
addx 30
addx -24
addx -1
addx 5
noop
noop
noop
noop
noop
addx 5
noop
addx 5
noop
addx 1
noop
addx 2
addx 5
addx 2
addx 1
noop
noop
noop
noop
'''.strip().splitlines()


def part1():
    signal = 0
    tick = 0
    X = 1
    while tick <= 220:
        if (tick - 19) % 40 == 0:
            signal += (tick + 1) * X
        match lines[tick].split():
            case ['addx', n]:
                lines.insert(tick + 1, f'add {n}')
            case ['add', n]:
                X += int(n)
            case ['noop']:
                pass
        tick += 1

    return signal


def part2():
    crt = ''
    tick = 0
    X = 1
    while tick < 240:
        tick += 1

        if abs((tick - 1) % 40 - X) <= 1:
            crt += '#'
        else:
            crt += '.'

        if tick % 40 == 0:
            crt += '\n'

        match lines[tick - 1].split():
            case ['addx', n]:
                lines.insert(tick, f'add {n}')
            case ['add', n]:
                X += int(n)
            case ['noop']:
                lines.append('noop')

    return crt
