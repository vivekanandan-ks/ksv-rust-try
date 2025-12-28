use std::io;

fn main() {

    let n: u32 = loop {

        println!("Enter a positive integer from 0 to 92:");
        let mut n = String::new();
        io::stdin()
            .read_line(&mut n)
            .expect("Failed to read line");

        //let guess: u32 = guess.trim().parse().expect("Please type a number!");
        let n: u32 = match n.trim().parse() {
            Ok(num) => {
                if num > 92 {
                    println!("Number too large!");
                    continue;
                }
                num
            },
            Err(error) => {
                println!("Error :{}\nSo Please type an integer!", error );
                continue;
            },
        };
        break n;
    };

    println!("Nth Fibonacci number {}:", fib(n));
    println!("Nth Fibonacci number(using recursive) {}:", fib_recursive(n));


}

fn fib(n:u32) -> u64 {
    let mut a = 0;
    let mut b = 1;
    //let mut last_value = 0;

    //println!("Fibonacci sequence up to {}:", n);

    for _ in 0..n {
        //println!("{}", a);
        //last_value = a;
        let c = a + b;
        a = b;
        b = c;
    }

    //return last_value;
    return a;
}

fn fib_recursive(n: u32) -> u64 {
    if n==0 || n==1 {
        return n.into();
    }
    return fib_recursive(n-1) + fib_recursive(n-2);

}
