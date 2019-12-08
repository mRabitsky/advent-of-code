use std::fs::File;
use std::io::{BufRead, BufReader, Error};
use ndarray::arr1;
use itertools::Itertools;

pub(crate) fn main() -> Result<(), Error> {
    let input = BufReader::new(File::open("inputs/day8.txt")?).lines().fold(String::new(), |acc, x| acc + x.unwrap().as_str());

    println!("--- Day 8: Space Image Format ---");
    println!("Part One: {}", part_one(input.clone()));
    println!("Part Two:\n {}", part_two(input.clone()));

    Ok(())
}

fn part_one(s: String) -> usize {
    let list = arr1(&s.chars().map(|c| c.to_digit(10).unwrap()).collect::<Vec<u32>>()[..]).into_shape((s.len() / (25 * 6), 6, 25)).unwrap();
    let mut dims: Vec<(usize, usize)> = vec![];

    list.outer_iter().for_each(|d| {
        let zero_count = d.iter().filter(|&&x| x == 0).count();
        let one_count = d.iter().filter(|&&x| x == 1).count();
        let two_count = d.iter().filter(|&&x| x == 2).count();

        dims.push((zero_count, one_count * two_count));
    });

    dims.sort_unstable_by(|a, b| a.0.cmp(&b.0));
    dims[0].1
}
fn part_two(s: String) -> String {
    let mut list = arr1(&s.chars().map(|c| c.to_digit(10).unwrap()).collect::<Vec<u32>>()[..]).into_shape((s.len() / (25 * 6), 6, 25)).unwrap();

    format!("{:#?}", list.outer_iter_mut().fold1(|mut a, b| {
        for i in 0..a.shape()[0] {
            for j in 0..a.shape()[1] {
                if a[[i, j]] == 2 {
                    a[[i, j]] = b[[i, j]];
                }
            }
        }
        a
    }).unwrap())
        .split("]],")
        .nth(0).unwrap()
        .chars()
        .filter(|&c| c == '1' || c == '0' || c == '\n')
        .map(|c| match c {
            '0' => ' ',
            '1' => '█',
            x @ _ => x
        })
        .join(" ")
}
