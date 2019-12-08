#![feature(int_error_matching)]
mod day1;
mod day2;
mod day3;
mod day4;
mod day5;
mod day6;
mod day7;
mod day8;

use glob;
use structopt::StructOpt;
use std::num::ParseIntError;

fn parse_day(src: &str) -> Result<u8, ParseIntError> {
    let result = src.parse::<u8>();
    if result.is_ok() {
        let val = result.unwrap();
        if val <= glob::glob("**/day*.rs").expect("Could not find glob files").count() as u8 {
            Ok(val)
        } else {
            "100000".parse::<u8>()
        }
    } else {
        result
    }
}

#[derive(Debug, StructOpt)]
#[structopt(name = "aoc", about = "Advent of Code solutions for 2019.")]
struct Opt {
    #[structopt(parse(try_from_str = parse_day))]
    /// Which day you would like to run (both parts will be run)
    day: u8
}

fn main() {
    let opt = Opt::from_args();
    match opt.day {
        1 => day1::main(),
        2 => day2::main(),
        3 => day3::main(),
        4 => day4::main(),
        5 => day5::main(),
        6 => day6::main().expect("Day 6 failed"),
        7 => day7::main(),
        8 => day8::main().expect("Day 8 failed"),
        _ => eprintln!("Nope, bad day")
    };
}
