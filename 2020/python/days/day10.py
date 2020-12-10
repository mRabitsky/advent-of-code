from collections import Counter

import networkx as nx

string = """77
10
143
46
79
97
54
116
60
91
80
132
20
154
53
14
103
31
65
110
43
38
47
120
112
87
24
95
33
104
73
22
66
137
21
109
118
63
55
124
146
148
84
86
147
125
23
85
117
71
48
136
151
130
83
56
140
9
49
113
131
133
74
37
127
34
32
106
1
78
11
72
40
96
17
64
92
102
123
126
90
105
57
99
27
70
98
111
30
50
67
2
155
5
119
8
39"""
ls = string.strip().split('\n')
ls = sorted([int(l) for l in ls])

dg = nx.DiGraph()
ls.insert(0, 0)
for l in ls:
    dg.add_node(l)
for i in range(len(ls)):
    neighbours = []
    j = i + 1
    while (j < len(ls)) and ((v := ls[j]) - ls[i] <= 3):
        neighbours.append(ls[j])
        j += 1
    for n in neighbours:
        dg.add_edge(ls[i], n, weight=(n - ls[i]))


def part1():
    c = Counter([x[1] - x[0] for x in zip(ls, ls[1:])])
    return c[1] * (c[3] + 1)


def part2():
    ns = list(reversed(list(nx.topological_sort(dg))))
    lookup = {ls[-1]: 1}

    for i in range(1, len(ns), 1):
        lookup[ns[i]] = sum([lookup[n] for n in dg[ns[i]]])

    return lookup[0]
