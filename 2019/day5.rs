fn main() {
    let input: Vec<i32> = vec![3,225,1,225,6,6,1100,1,238,225,104,0,1002,148,28,224,1001,224,-672,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,1102,8,21,225,1102,13,10,225,1102,21,10,225,1102,6,14,225,1102,94,17,225,1,40,173,224,1001,224,-90,224,4,224,102,8,223,223,1001,224,4,224,1,224,223,223,2,35,44,224,101,-80,224,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,1101,26,94,224,101,-120,224,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1001,52,70,224,101,-87,224,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,1101,16,92,225,1101,59,24,225,102,83,48,224,101,-1162,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,80,10,225,101,5,143,224,1001,224,-21,224,4,224,1002,223,8,223,1001,224,6,224,1,223,224,223,1102,94,67,224,101,-6298,224,224,4,224,102,8,223,223,1001,224,3,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,108,677,677,224,102,2,223,223,1005,224,329,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,344,101,1,223,223,1107,226,226,224,102,2,223,223,1006,224,359,101,1,223,223,1108,677,677,224,102,2,223,223,1005,224,374,101,1,223,223,8,677,226,224,1002,223,2,223,1005,224,389,101,1,223,223,108,226,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,107,677,677,224,102,2,223,223,1006,224,419,101,1,223,223,1007,226,226,224,102,2,223,223,1005,224,434,101,1,223,223,1007,677,677,224,102,2,223,223,1005,224,449,1001,223,1,223,8,677,677,224,1002,223,2,223,1006,224,464,101,1,223,223,1108,677,226,224,1002,223,2,223,1005,224,479,101,1,223,223,7,677,226,224,1002,223,2,223,1005,224,494,101,1,223,223,1008,677,677,224,1002,223,2,223,1006,224,509,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,524,1001,223,1,223,107,226,226,224,1002,223,2,223,1006,224,539,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,554,101,1,223,223,1108,226,677,224,102,2,223,223,1006,224,569,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,584,1001,223,1,223,7,226,226,224,1002,223,2,223,1006,224,599,101,1,223,223,8,226,677,224,102,2,223,223,1005,224,614,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,629,101,1,223,223,1008,226,677,224,1002,223,2,223,1006,224,644,101,1,223,223,107,226,677,224,1002,223,2,223,1005,224,659,1001,223,1,223,1008,226,226,224,1002,223,2,223,1006,224,674,1001,223,1,223,4,223,99,226];
    println!("--- Day 5: Sunny with a Chance of Asteroids ---");
    println!("Part One:");
    PART_ONE(input.clone());
    println!("\nPart Two:");
    PART_TWO(input.clone());
}

fn PART_ONE(mut arr: Vec<i32>) -> Vec<i32> {
    let mut i = 0;
    while i < arr.len() {
        let mut parameters: Vec<i32> = vec![];
        let instruction = arr[i].clone();
        i += 1;
        
        let opcode = instruction % 100;
        if opcode < 3 {
            if instruction >= 1000 {
                if instruction / 10 > 100 {
                    parameters.push(arr[i].clone());
                } else {
                    parameters.push(arr[arr[i].clone() as usize].clone());
                }
                i += 1;
                parameters.push(arr[i].clone());
            } else if instruction >= 100 {
                parameters.push(arr[i].clone());
                i += 1;
                parameters.push(arr[arr[i].clone() as usize].clone());
            } else {
                parameters.push(arr[arr[i].clone() as usize].clone());
                i += 1;
                parameters.push(arr[arr[i].clone() as usize].clone());
            }
        } else if opcode != 99 {
            parameters.push(arr[i].clone());
        }
        i += 1;
        
        match opcode {
            1 => {
                let pointer = arr[i].clone();
                i += 1;
                arr[pointer as usize] = parameters.pop().unwrap() + parameters.pop().unwrap();
            },
            2 => {
                let pointer = arr[i].clone();
                i += 1;
                arr[pointer as usize] = parameters.pop().unwrap() * parameters.pop().unwrap();
            },
            3 => arr[parameters.pop().unwrap() as usize] = 1,
            4 => println!("Output: {}", arr[parameters.pop().unwrap() as usize]),
            99 => i = arr.len(),
            _ => panic!("Bad opcode!")
        }
    }
    arr
}
fn PART_TWO(mut arr: Vec<i32>) -> () {
    let mut i = 0;
    while i < arr.len() {
        let mut parameters: Vec<i32> = vec![];
        let instruction = arr[i].clone();
        i += 1;
        
        let opcode = instruction % 100;
        if opcode < 3 || opcode > 4 {
            if instruction >= 1000 {
                if instruction / 10 > 100 {
                    parameters.push(arr[i].clone());
                } else {
                    parameters.push(arr[arr[i].clone() as usize].clone());
                }
                i += 1;
                parameters.push(arr[i].clone());
            } else if instruction >= 100 {
                parameters.push(arr[i].clone());
                i += 1;
                parameters.push(arr[arr[i].clone() as usize].clone());
            } else {
                parameters.push(arr[arr[i].clone() as usize].clone());
                i += 1;
                parameters.push(arr[arr[i].clone() as usize].clone());
            }
        } else if opcode != 99 {
            parameters.push(arr[i].clone());
        }
        i += 1;
        
        match opcode {
            1 => {
                let pointer = arr[i].clone();
                i += 1;
                arr[pointer as usize] = parameters.pop().unwrap() + parameters.pop().unwrap();
            },
            2 => {
                let pointer = arr[i].clone();
                i += 1;
                arr[pointer as usize] = parameters.pop().unwrap() * parameters.pop().unwrap();
            },
            3 => arr[parameters.pop().unwrap() as usize] = 5,
            4 => println!("Output: {}", arr[parameters.pop().unwrap() as usize]),
            5 => {
                let jump = parameters.pop().unwrap();
                if parameters.pop().unwrap() != 0 {
                    i = jump as usize;
                }
            },
            6 => {
                let jump = parameters.pop().unwrap();
                if parameters.pop().unwrap() == 0 {
                    i = jump as usize;
                }
            },
            7 => {
                let pointer = arr[i].clone();
                i += 1;
                arr[pointer as usize] = if parameters.remove(0) < parameters.remove(0) {
                    1
                } else {
                    0
                };
            },
            8 => {
                let pointer = arr[i].clone();
                i += 1;
                arr[pointer as usize] = if parameters.remove(0) == parameters.remove(0) {
                    1
                } else {
                    0
                };
            },
            99 => i = arr.len(),
            _ => panic!("Bad opcode!")
        }
    };
}
