use std::collections::HashMap;
use permutohedron::Heap;

pub(crate) fn main() {
    let input: Vec<i32> = vec![3,8,1001,8,10,8,105,1,0,0,21,46,59,72,93,110,191,272,353,434,99999,3,9,101,4,9,9,1002,9,3,9,1001,9,5,9,102,2,9,9,1001,9,5,9,4,9,99,3,9,1002,9,5,9,1001,9,5,9,4,9,99,3,9,101,4,9,9,1002,9,4,9,4,9,99,3,9,102,3,9,9,101,3,9,9,1002,9,2,9,1001,9,5,9,4,9,99,3,9,1001,9,2,9,102,4,9,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,99];
    println!("--- Day 7: Sunny with a Chance of Asteroids ---");
    println!("Part One: {}", part_one(input.clone()));
    // println!("\nPart Two: {}", part_two(input.clone()));
}


fn part_one(arr: Vec<i32>) -> i32 {
    let mut map: HashMap<(u8, u8, u8, u8, u8), i32> = HashMap::new();
    let mut range: Vec<u8> = vec![0, 1, 2, 3, 4];
    Heap::new(&mut range).for_each(|h| {
        let (a, b, c, d, e) = (h[0], h[1], h[2], h[3], h[4]);
        map.insert(
            (a, b, c, d, e),
            _run_machine(arr.clone(), vec![
                e as i32,
                _run_machine(arr.clone(), vec![
                    d as i32,
                    _run_machine(arr.clone(), vec![
                        c as i32,
                        _run_machine(arr.clone(), vec![
                            b as i32,
                            _run_machine(arr.clone(), vec![a as i32, 0])
                        ])
                    ])
                ])
            ])
        );
    });

    let mut result: Vec<((u8, u8, u8, u8, u8), i32)> = map.into_iter().collect();
    result.sort_unstable_by(|x, y| x.1.cmp(&y.1));
    println!("Sequence: {:#?}", result.last().unwrap().0);
    result.last().unwrap().1
}
/*fn part_two(arr: Vec<i32>) -> i32 {
    let mut map: HashMap<(u8, u8, u8, u8, u8), i32> = HashMap::new();
    let mut range: Vec<u8> = vec![5, 6, 7, 8, 9];
    Heap::new(&mut range).for_each(|h| {
        let (mut v, mut w, mut x, mut y, mut z) = (h[0], h[1], h[2], h[3], h[4]);
        let mut a = IntcodeInterpreter::new(arr.clone(), Box::new(|| 0));
        let mut b = IntcodeInterpreter::new(arr.clone(), Box::new(|| 0));
        let mut c = IntcodeInterpreter::new(arr.clone(), Box::new(|| 0));
        let mut d = IntcodeInterpreter::new(arr.clone(), Box::new(|| 0));
        let mut e = IntcodeInterpreter::new(arr.clone(), Box::new(|| 0));
        a.input_handler = Box::new(|| -> i32 {
            if v < 10 {
                let temp = v;
                v += 5;
                temp as i32
            } else {
                let mut output = None;
                while output.is_none() {
                    output = e.step();
                }
                output.unwrap()
            }
        });
        b.input_handler = Box::new(|| -> i32 {
            if w < 10 {
                let temp = w;
                w += 5;
                temp as i32
            } else {
                let mut output = None;
                while output.is_none() {
                    output = a.step();
                }
                output.unwrap()
            }
        });
        c.input_handler = Box::new(|| -> i32 {
            if x < 10 {
                let temp = x;
                x += 5;
                temp as i32
            } else {
                let mut output = None;
                while output.is_none() {
                    output = b.step();
                }
                output.unwrap()
            }
        });
        d.input_handler = Box::new(|| -> i32 {
            if y < 10 {
                let temp = y;
                y += 5;
                temp as i32
            } else {
                let mut output = None;
                while output.is_none() {
                    output = c.step();
                }
                output.unwrap()
            }
        });
        e.input_handler = Box::new(|| -> i32 {
            if z < 10 {
                let temp = z;
                z += 5;
                temp as i32
            } else {
                let mut output = None;
                while output.is_none() {
                    output = d.step();
                }
                output.unwrap()
            }
        });

        let mut result = None;
        while e.is_running() {
            result = e.step();
        }

        map.insert((v - 5, w - 5, x - 5, y - 5, z - 5), result.unwrap());
    });

    let mut result: Vec<((u8, u8, u8, u8, u8), i32)> = map.into_iter().collect();
    result.sort_unstable_by(|x, y| x.1.cmp(&y.1));
    println!("Sequence: {:#?}", result.last().unwrap().0);
    result.last().unwrap().1
}*/

fn _run_machine(mut arr: Vec<i32>, mut inputs: Vec<i32>) -> i32 {
    let mut i = 0;
    let mut output = -1;
    while i < arr.len() {
        let mut parameters: Vec<i32> = vec![];
        let instruction = arr[i].clone();
        i += 1;

        let opcode = instruction % 100;
        if opcode != 99 && (opcode < 3 || opcode > 4) {
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
            3 => arr[parameters.pop().unwrap() as usize] = inputs.remove(0),
            4 => output = arr[parameters.pop().unwrap() as usize],
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
    output
}

/*struct IntcodeInterpreter<'a> {
    program: Vec<i32>,
    pointer: usize,
    input_handler: Box<dyn FnMut() -> i32 + 'a>,
    running: bool
}
impl<'a> IntcodeInterpreter<'a> {
    fn new(program: Vec<i32>, input_handler: Box<impl FnMut() -> i32 + 'a>) -> IntcodeInterpreter<'a> {
        IntcodeInterpreter {
            program, pointer: 0, input_handler, running: true
        }
    }
    
    fn step(&mut self) -> Option<i32> {
        if !self.running {
            return None;
        }
        let mut parameters: Vec<i32> = vec![];
        let instruction = self.program[self.pointer].clone();
        self.pointer += 1;

        let opcode = instruction % 100;
        if opcode != 99 && (opcode < 3 || opcode > 4) {
            if instruction >= 1000 {
                if instruction / 10 > 100 {
                    parameters.push(self.program[self.pointer].clone());
                } else {
                    parameters.push(self.program[self.program[self.pointer].clone() as usize].clone());
                }
                self.pointer += 1;
                parameters.push(self.program[self.pointer].clone());
            } else if instruction >= 100 {
                parameters.push(self.program[self.pointer].clone());
                self.pointer += 1;
                parameters.push(self.program[self.program[self.pointer].clone() as usize].clone());
            } else {
                parameters.push(self.program[self.program[self.pointer].clone() as usize].clone());
                self.pointer += 1;
                parameters.push(self.program[self.program[self.pointer].clone() as usize].clone());
            }
        } else if opcode != 99 {
            parameters.push(self.program[self.pointer].clone());
        }
        self.pointer += 1;

        match opcode {
            1 => {
                let pointer = self.program[self.pointer].clone();
                self.pointer += 1;
                self.program[pointer as usize] = parameters.pop().unwrap() + parameters.pop().unwrap();
            },
            2 => {
                let pointer = self.program[self.pointer].clone();
                self.pointer += 1;
                self.program[pointer as usize] = parameters.pop().unwrap() * parameters.pop().unwrap();
            },
            3 => self.program[parameters.pop().unwrap() as usize] = (*self.input_handler)(),
            4 => return Some(self.program[parameters.pop().unwrap() as usize]),
            5 => {
                let jump = parameters.pop().unwrap();
                if parameters.pop().unwrap() != 0 {
                    self.pointer = jump as usize;
                }
            },
            6 => {
                let jump = parameters.pop().unwrap();
                if parameters.pop().unwrap() == 0 {
                    self.pointer = jump as usize;
                }
            },
            7 => {
                let pointer = self.program[self.pointer].clone();
                self.pointer += 1;
                self.program[pointer as usize] = if parameters.remove(0) < parameters.remove(0) {
                    1
                } else {
                    0
                };
            },
            8 => {
                let pointer = self.program[self.pointer].clone();
                self.pointer += 1;
                self.program[pointer as usize] = if parameters.remove(0) == parameters.remove(0) {
                    1
                } else {
                    0
                };
            },
            99 => self.pointer = self.program.len(),
            _ => panic!("Bad opcode!")
        }
        None
    }
    fn is_running(&self) -> bool {
        self.running
    }
}*/
