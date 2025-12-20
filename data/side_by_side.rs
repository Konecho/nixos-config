use std::cmp;
use std::env;
use std::io::{self, Write};
use std::process::Command;
use std::str;

fn pure_count(line: &str) -> usize {
    let mut count = 0;
    let mut in_escape = false;

    for &byte in line.as_bytes() {
        if byte == b'\x1b' {
            in_escape = true;
            continue;
        }
        if in_escape && byte == b'm' {
            in_escape = false;
            continue;
        }
        if !in_escape {
            count += 1;
        }
    }
    count
}

struct Config {
    cmd_a: String,
    cmd_b: String,
    separator: String,
    truncate: bool,
}

impl Config {
    fn from_env() -> Result<Self, String> {
        let args: Vec<String> = env::args().collect();
        if args.len() < 3 {
            return Err("usage: side_by_side.rs \"cmd1\" \"cmd2\" [separator] [--truncate]".to_string());
        }
        Ok(Config {
            cmd_a: args[1].clone(),
            cmd_b: args[2].clone(),
            separator: args.get(3).unwrap_or(&"    ".to_string()).clone(),
            truncate: args.contains(&"--truncate".to_string()),
        })
    }
}

fn run_command(cmd: &str) -> Result<(Vec<String>, Vec<String>), Box<dyn std::error::Error>> {
    let output = Command::new("sh").arg("-c").arg(cmd).output()?;
    
    if !output.status.success() {
        eprintln!("Command failed: {}", cmd);
        if !output.stderr.is_empty() {
            eprintln!("Error: {}", String::from_utf8_lossy(&output.stderr));
        }
    }
    
    let stdout = String::from_utf8_lossy(&output.stdout);
    let lines: Vec<String> = stdout
        .lines()
        .map(|s| s.trim_end().to_string())
        .collect();
    
    Ok((lines, vec![])) // Could return stderr lines too
}

pub fn main() -> Result<(), Box<dyn std::error::Error>> {
    let config = Config::from_env().map_err(|e| {
        eprintln!("{}", e);
        std::process::exit(1);
    }).unwrap();

    let (lines_a, _) = run_command(&config.cmd_a)?;
    let (lines_b, _) = run_command(&config.cmd_b)?;

    let max_len = lines_a
        .iter()
        .map(|line| pure_count(line))
        .max()
        .unwrap_or(0);

    let max_lines = cmp::max(lines_a.len(), lines_b.len());
    
    let stdout = io::stdout();
    let mut handle = stdout.lock();

    for i in 0..max_lines {
        let line_a = lines_a.get(i).map(|s| s.as_str()).unwrap_or("");
        let line_b = lines_b.get(i).map(|s| s.as_str()).unwrap_or("");
        
        let visible_width = pure_count(line_a);
        let padding_needed = max_len.saturating_sub(visible_width);
        
        write!(handle, "{}{}", line_a, " ".repeat(padding_needed))?;
        writeln!(handle, "{}{}", config.separator, line_b)?;
    }

    Ok(())
}
