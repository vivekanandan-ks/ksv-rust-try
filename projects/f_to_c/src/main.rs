use std::io;

fn main() {

    //let fah: f32;

    let (f, c) = loop {
        println!("Enter fahrenheit value:");
        let mut f = String::new();
        io::stdin()
            .read_line(&mut f)
            .expect("Failed to read line");

        let f: f32 = match f.trim().parse() {
            Ok(num) => num,
            Err(error) => {
                println!("Error:{}\nInvalid input. Try Again", error);
                continue;
            },
        };

        break (f, (f - 32.0) * 5.0 / 9.0)
    };


    println!("{}°F is {}°C", f, c);
}
