import re
from typing import List, Tuple

import networkx as nx

VALVES = re.compile(r'Valve (\w{2}) has flow rate=(\d+); tunnels? leads? to valves? ((?:\w{2}(?:, )?)+)')

valves = '''
Valve AV has flow rate=0; tunnels lead to valves AX, PI
Valve JI has flow rate=0; tunnels lead to valves VD, HF
Valve FF has flow rate=0; tunnels lead to valves ZL, CG
Valve CG has flow rate=10; tunnels lead to valves TI, SU, RV, FF, QX
Valve RC has flow rate=18; tunnels lead to valves EQ, WR, AD
Valve ZJ has flow rate=0; tunnels lead to valves GJ, WI
Valve GJ has flow rate=21; tunnels lead to valves TG, YJ, EU, AZ, ZJ
Valve VJ has flow rate=0; tunnels lead to valves UJ, AA
Valve ER has flow rate=0; tunnels lead to valves QO, ZK
Valve QO has flow rate=24; tunnels lead to valves MF, ER
Valve LN has flow rate=0; tunnels lead to valves ZR, TI
Valve SU has flow rate=0; tunnels lead to valves CG, LM
Valve AJ has flow rate=12; tunnels lead to valves QX, JW, TR, MK
Valve YJ has flow rate=0; tunnels lead to valves GJ, EQ
Valve JW has flow rate=0; tunnels lead to valves YI, AJ
Valve WI has flow rate=13; tunnels lead to valves XO, ZJ, ZL
Valve VS has flow rate=0; tunnels lead to valves XL, VD
Valve TI has flow rate=0; tunnels lead to valves LN, CG
Valve VD has flow rate=17; tunnels lead to valves TR, VS, JI, GQ, VO
Valve TX has flow rate=0; tunnels lead to valves FV, WR
Valve HP has flow rate=0; tunnels lead to valves AX, ET
Valve BK has flow rate=0; tunnels lead to valves PI, AD
Valve ET has flow rate=0; tunnels lead to valves ZR, HP
Valve VY has flow rate=0; tunnels lead to valves KU, LM
Valve DZ has flow rate=0; tunnels lead to valves VO, AA
Valve ZK has flow rate=0; tunnels lead to valves FR, ER
Valve TG has flow rate=0; tunnels lead to valves GJ, AX
Valve YI has flow rate=0; tunnels lead to valves JW, LM
Valve XO has flow rate=0; tunnels lead to valves ZR, WI
Valve ZR has flow rate=11; tunnels lead to valves KX, AZ, ET, LN, XO
Valve EQ has flow rate=0; tunnels lead to valves RC, YJ
Valve PI has flow rate=4; tunnels lead to valves BK, KX, VQ, EU, AV
Valve VO has flow rate=0; tunnels lead to valves VD, DZ
Valve WR has flow rate=0; tunnels lead to valves TX, RC
Valve TF has flow rate=0; tunnels lead to valves FR, KU
Valve FR has flow rate=22; tunnels lead to valves ZK, TF
Valve MK has flow rate=0; tunnels lead to valves AJ, YW
Valve AZ has flow rate=0; tunnels lead to valves GJ, ZR
Valve TC has flow rate=0; tunnels lead to valves KU, RO
Valve GQ has flow rate=0; tunnels lead to valves MF, VD
Valve YW has flow rate=0; tunnels lead to valves MK, KU
Valve AA has flow rate=0; tunnels lead to valves RO, EI, VJ, VQ, DZ
Valve MF has flow rate=0; tunnels lead to valves QO, GQ
Valve ZL has flow rate=0; tunnels lead to valves WI, FF
Valve LM has flow rate=3; tunnels lead to valves YI, SU, UJ, VY, HF
Valve KU has flow rate=9; tunnels lead to valves XL, TC, TF, VY, YW
Valve FV has flow rate=23; tunnels lead to valves KV, TX
Valve EU has flow rate=0; tunnels lead to valves PI, GJ
Valve KV has flow rate=0; tunnels lead to valves FV, OF
Valve QX has flow rate=0; tunnels lead to valves AJ, CG
Valve RO has flow rate=0; tunnels lead to valves AA, TC
Valve TR has flow rate=0; tunnels lead to valves VD, AJ
Valve VQ has flow rate=0; tunnels lead to valves AA, PI
Valve HF has flow rate=0; tunnels lead to valves JI, LM
Valve RV has flow rate=0; tunnels lead to valves EI, CG
Valve KX has flow rate=0; tunnels lead to valves PI, ZR
Valve UJ has flow rate=0; tunnels lead to valves LM, VJ
Valve AX has flow rate=5; tunnels lead to valves TG, AV, HP
Valve XL has flow rate=0; tunnels lead to valves KU, VS
Valve AD has flow rate=0; tunnels lead to valves BK, RC
Valve EI has flow rate=0; tunnels lead to valves RV, AA
Valve OF has flow rate=19; tunnel leads to valve KV
'''.strip().splitlines()
valves = [((gs := VALVES.match(valve).groups())[0], int(gs[1]), gs[2].split(', ')) for valve in valves]

G = nx.Graph()
for u, flow, vs in valves:
    G.add_node(u, flow=flow)
    G.add_edges_from([(u, v) for v in vs])

distances = dict(nx.all_pairs_shortest_path_length(G))
for e in list(nx.edge_boundary(G, [n for n, flow in G.nodes(data='flow') if flow > 0 or n == 'AA'])):
    try:
        nx.contracted_edge(G, e, copy=False, self_loops=False)  # all the uninteresting chains are of length 2 or less
    except ValueError:  # if the chain is of length one then the two sides will duel
        continue
for e in G.edges:
    G.edges[e]['weight'] = distances[e[0]][e[1]]  # why doesn't contraction do this automatically?
distances = dict(nx.all_pairs_dijkstra(G, cutoff=30))


def _all_paths_of_length(l: int) -> Tuple[int, List[Tuple[int, set[str]]]]:
    # After contraction, the number of possible paths of length 30 is actually so small that I can just iterate through
    # all of them and simply assume that I open a valve on each step. The truly correct graph search for this with an
    # optimal admissible heuristic is really difficult, and the alternative would probably be some kind of tweak on a
    # Steiner TSP solution, so I think this is fine. Branch and bound is cool but burning CPUs are hot 😎

    max_pressure = 0
    states = []
    frontier = [(l, 0, 'AA', {'AA'})]
    while frontier:
        t, p, u, seen = frontier.pop()
        if (neighbours := [
            (
                (tt := t - d - 1),
                p + G.nodes[v]['flow'] * tt,
                v,
                {v} | seen,
            )
            for v, d in distances[u][0].items()
            if d <= t - 2 and v not in seen
        ]):
            frontier.extend(neighbours)
        else:
            max_pressure = max(max_pressure, p)
            states.append((p, seen - {'AA'}))

    return max_pressure, sorted(states, reverse=True)


def part1():
    return _all_paths_of_length(30)[0]


def part2():
    _, states = _all_paths_of_length(26)

    max_pressure = 0
    end = len(states)  # worst case it's at the very end somehow
    for i in range(end):
        for j in range(i + 1, end + 1):
            n, a = states[i]
            m, b = states[j]
            if not a & b:  # but once we find a single valid point it can't get worse
                max_pressure = max(max_pressure, n + m)
                end = min(end, j)  # since the list is monotonically decreasing by pressures

    return max_pressure
