pub(crate) fn main() {
    let input: Vec<usize> = vec![1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,13,19,2,9,19,23,1,23,6,27,1,13,27,31,1,31,10,35,1,9,35,39,1,39,9,43,2,6,43,47,1,47,5,51,2,10,51,55,1,6,55,59,2,13,59,63,2,13,63,67,1,6,67,71,1,71,5,75,2,75,6,79,1,5,79,83,1,83,6,87,2,10,87,91,1,9,91,95,1,6,95,99,1,99,6,103,2,103,9,107,2,107,10,111,1,5,111,115,1,115,6,119,2,6,119,123,1,10,123,127,1,127,5,131,1,131,2,135,1,135,5,0,99,2,0,14,0];
    println!("--- Day 2: 1202 Program Alarm ---");
    println!("Part One: {:#?}", part_one(input.clone(), 12, 2)[0]);
    println!("Part Two: {:#?}", part_two(input.clone()));
}

fn part_one(mut arr: Vec<usize>, x: usize, y: usize) -> Vec<usize> {
    arr[1] = x;
    arr[2] = y;
    let mut i = 0;
    while i < arr.len() {
        let a = arr[i+3].clone();
        let b = arr[i+2].clone();
        let c = arr[i+1].clone();
        match arr[i] {
            1 => arr[a] = arr[b] + arr[c],
            2 => arr[a] = arr[b] * arr[c],
            99 => i = arr.len(),
            _ => println!("ERROR!")
        }
        i += 4;
    }
    arr
}
fn part_two(arr: Vec<usize>) -> usize {
    for i in 1..100 {
        for j in 1..100 {
            let result = part_one(arr.clone(), i, j);
            if result[0] == 19690720 {
                return 100 * i + j
            }
        }
    }
    return 0;
}
