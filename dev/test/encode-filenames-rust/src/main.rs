extern crate url;

use std::env;
use std::fs;
use std::path::Path;
// use url::percent_encoding::{utf8_percent_encode, PATH_SEGMENT_ENCODE_SET};
use percent_encoding::{utf8_percent_encode, AsciiSet, CONTROLS};
const PERCENTENCODE_CHARS: &AsciiSet = &CONTROLS.add(b' ').add(b'(').add(b')').add(b'%').add(b'?');

fn main() {
    // Check if a directory argument is provided
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <directory_path>", args[0]);
        std::process::exit(1);
    }

    // Get the directory path from the command line argument
    let directory_path = &args[1];

    // Iterate through files in the directory
    if let Ok(entries) = fs::read_dir(directory_path) {
        for entry in entries {
            if let Ok(entry) = entry {
                let file_path = entry.path();

                // Check if it's a file (not a subdirectory)
                if file_path.is_file() {
                    // Perform UTF-8 percent encoding on the file path
                    let file_name = file_path
                        .file_name()
                        .map(|name| name.to_string_lossy().to_string())
                        .unwrap_or_else(|| String::from(""));

                    let encoded_file_name = utf8_percent_encode(&file_name, PATH_SEGMENT_ENCODE_SET).to_string();

                    // Print the original and encoded file paths
                    println!("Original: {:?}", file_name);
                    println!("Encoded: {:?}", encoded_file_name);
                }
            }
        }
    } else {
        eprintln!("Failed to read the directory.");
        std::process::exit(1);
    }
}
