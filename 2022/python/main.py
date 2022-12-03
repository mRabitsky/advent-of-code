import sys

from days import *

if __name__ == '__main__':
    if len(sys.argv) > 1:
        [day, part] = sys.argv[2:]
    else:
        problem = input('{day} {part}: ')
        [day, part] = problem.split(' ')
    if part == 'all' or part == 'both':
        print(
            '=== p1 ===',
            '\n',
            eval(f'day{day}.part1()'),
            '\n\n',
            '=== p2 ===',
            '\n',
            eval(f'day{day}.part2()'),
            sep=''
        )
    else:
        eval(f'print(day{day}.part{part}())')
