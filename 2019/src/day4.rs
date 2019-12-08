use core::ops::RangeInclusive;

pub(crate) fn main() {
    let range = 359282..=820401;
    println!("--- Day 4: Secure Container ---");
    println!("Part One: {:#?}", part_one(&range));
    println!("Part Two: {:#?}", part_two(&range));
}

fn part_one(r: &RangeInclusive<usize>) -> usize {
    let mut counter: usize = 0;
    for a in 3..8 {
        for b in 3..10 {
            if b < a {
                continue;
            }
            for c in 3..10 {
                if c < b {
                    continue;
                }
                for d in 3..10 {
                    if d < c {
                        continue;
                    }
                    for e in 3..10 {
                        if e < d {
                            continue;
                        }
                        for f in 3..10 {
                            if f < e {
                                continue;
                            }
                            if (a == b || b == c || c == d || d == e || e == f) && r.contains(&(a * 100000 + b * 10000 + c * 1000 + d * 100 + e * 10 + f)) {
                                counter += 1;
                            }
                        }
                    }
                }
            }
        }
    }
    
    counter
}
fn part_two(r: &RangeInclusive<usize>) -> usize {
    let mut counter: usize = 0;
    for a in 3..8 {
        for b in 3..10 {
            if b < a {
                continue;
            }
            for c in 3..10 {
                if c < b {
                    continue;
                }
                for d in 3..10 {
                    if d < c {
                        continue;
                    }
                    for e in 3..10 {
                        if e < d {
                            continue;
                        }
                        for f in 3..10 {
                            if f < e {
                                continue;
                            }
                            if (
                                (a == b && a != c) || 
                                (b == c && b != d && b != a) || 
                                (c == d && c != e && c != b) || 
                                (d == e && d != f && d != c) || 
                                (e == f && e != d)
                                ) && 
                                r.contains(&(a * 100000 + b * 10000 + c * 1000 + d * 100 + e * 10 + f)) {
                                counter += 1;
                            }
                        }
                    }
                }
            }
        }
    }
    
    counter
}
