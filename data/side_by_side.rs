use std::cmp;
use std::env;
use std::process::Command;
use std::str;

fn pure_count(line: &str) -> usize {
    let mut count = 0;
    let mut in_escape = false;

    for byte in line.as_bytes() {
        if *byte == b'\x1b' || (in_escape && *byte == b'm') {
            in_escape = !in_escape;
        } else {
            count += 1;
        }
    }

    count
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        eprintln!("usage: side_by_side.rs \"cmd1\" \"cmd2\""); 
        return Ok(());
    }
    let cmd_a = &args[1];
    let cmd_b = &args[2];
    let separator = "    ";
    let output_a = Command::new("sh").arg("-c").arg(cmd_a).output()?;
    let output_b = Command::new("sh").arg("-c").arg(cmd_b).output()?;
    let lines_a: Vec<String> = str::from_utf8(&output_a.stdout)?
        .lines()
        .map(|s| s.trim_end().to_owned())
        .collect();
    let lines_b: Vec<String> = str::from_utf8(&output_b.stdout)?
        .lines()
        .map(|s| s.trim_end().to_owned())
        .collect();
    let max_len = lines_a
        .iter()
        .map(|line| pure_count(line))
        .max()
        .unwrap_or(0);
    let max_lines = cmp::max(lines_a.len(), lines_b.len());
    for i in 0..max_lines {
        let line_a = lines_a.get(i).map(|s| s.as_str()).unwrap_or("");
        let line_b = lines_b.get(i).map(|s| s.as_str()).unwrap_or("");
        let visible_width = pure_count(line_a);
        let padding_needed = max_len.saturating_sub(visible_width);
        print!("{}{}", line_a, " ".repeat(padding_needed));
        println!("{}{}", separator, line_b);
    }

    Ok(())
}
