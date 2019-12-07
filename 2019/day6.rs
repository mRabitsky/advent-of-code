use std::fs::File;
use std::io::{BufRead, BufReader, Error};

use petgraph::algo::astar;
use petgraph::graphmap::{DiGraphMap, UnGraphMap};

fn main() -> Result<(), Error> {
    let strings: Vec<(String, String)> = BufReader::new(File::open("input-day6.txt")?)
        .lines()
        .map(|l| l.unwrap()
            .split(")")
            .map(|s| String::from(s))
            .collect::<Vec<String>>()
        )
        .map(|v| (v[0].clone(), v[1].clone()))
        .collect();
    let digraph = DiGraphMap::<&str, ()>::from_edges(strings.iter().map(|&(ref x, ref y)| (x.as_str(), y.as_str())));
    let ungraph = UnGraphMap::<&str, ()>::from_edges(strings.iter().map(|&(ref x, ref y)| (x.as_str(), y.as_str())));

    println!("--- Day 6: Universal Orbit Map ---");
    println!("Part One: {}", part_one(&digraph));
    println!("Part Two: {}", part_two(&ungraph));

    Ok(())
}

fn part_one(graph: &DiGraphMap<&str, ()>) -> usize {
    let f = |x| _descendants(graph, x);
    graph.nodes().map(f).sum::<usize>()
}

fn part_two(graph: &UnGraphMap<&str, ()>) -> usize {
    let finish = graph.neighbors("SAN").nth(0).unwrap();
    astar(&graph, graph.neighbors("YOU").nth(0).unwrap(), |f| f == finish, |_| 1, |_| 0).unwrap().0
}

fn _descendants(g: &DiGraphMap<&str, ()>, n: &str) -> usize {
    let f = |x| _descendants(g, x);
    g.neighbors(n).count() + g.neighbors(n).map(f).sum::<usize>()
}
