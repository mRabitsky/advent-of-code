import numpy as np

timestamp = 1003240
busses = "19,x,x,x,x,x,x,x,x,41,x,x,x,37,x,x,x,x,x,787,x,x,x,x,x,x,x,x,x,x,x,x,13,x,x,x,x,x,x,x,x,x,23,x,x,x,x,x,29,x,571,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17"


def xgcd(a, b):
    x0, x1, y0, y1 = 0, 1, 1, 0
    while a != 0:
        (q, a), b = divmod(b, a), a
        y0, y1 = y1, y0 - q * y1
        x0, x1 = x1, x0 - q * x1
    return x0 if x0 > 0 else x0 + x1


def part1():
    bs = [int(b) for b in busses.strip().split(',') if b != 'x']
    ts = [np.ceil(timestamp / b) * b for b in bs]
    b = int(np.argmin([np.ceil(timestamp / b) * b for b in bs]))
    return bs[b] * (ts[b] - timestamp)


def part2():
    pairs = [(b[0], int(b[1])) for b in enumerate(busses.split(',')) if b[1] != 'x']
    pairs = [(p[1] - ((p[0] % p[1]) or p[1]), p[1]) for p in pairs]
    modprod = np.prod([p[1] for p in pairs])
    return sum([(a_i * (modprod // m_i) * xgcd(modprod // m_i, m_i)) for (a_i, m_i) in pairs]) % modprod
