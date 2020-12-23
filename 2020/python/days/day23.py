from collections import deque

ns = [5, 2, 3, 7, 6, 4, 8, 1, 9]


class Node:
    next = None

    def __init__(self, n):
        self.n = n

    def __sub__(self, other):
        return self.n - other

    def __mul__(self, other):
        return self.n * (other.n if isinstance(other, Node) else other)


def part1():
    n = deque(ns)
    mini, maxi = min(n), max(n)
    current = n[0]
    for i in range(100):
        n.rotate(-1)
        a, b, c = n.popleft(), n.popleft(), n.popleft()
        dest = current - 1 if (current - 1 >= mini) else maxi
        while dest in [a, b, c]:
            dest = dest - 1 if (dest - 1 >= mini) else maxi
        dest = n.index(dest) + 1
        for x in [c, b, a]:
            n.insert(dest, x)
        current = n[(n.index(current) + 1) % len(n)]
    while n[0] != 1:
        n.rotate(-1)
    n.popleft()
    return ''.join(map(str, n))


def part2():
    mini = min(ns)
    maxi = max(ns)
    for i in range(maxi + 1, 1000001):
        ns.append(i)
    maxi = ns[-1]

    nodes = [Node(n) for n in ns]
    for i in range(1, len(nodes)):
        nodes[i - 1].next = nodes[i]
    nodes[-1].next = nodes[0]

    nmap = {n.n: n for n in nodes}
    current = nodes[0]
    for i in range(10000000):
        a = current.next
        b = a.next
        c = b.next
        d = c.next
        dest = current - 1 if (current - 1) >= mini else maxi
        while dest in [a.n, b.n, c.n]:
            dest = dest - 1 if (dest - 1 >= mini) else maxi

        dest = nmap[dest]
        tmp = dest.next

        current.next = d
        dest.next = a
        c.next = tmp
        current = d

    return nmap[1].next * nmap[1].next.next
