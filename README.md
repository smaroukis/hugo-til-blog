## Update 2024-02-18 - Archiving
Blog has been moved to https://github.com/smaroukis/quartz for ease of publishing. Code will be archived for future reference.


## Build Notes
- currently using a custom compiled version of `zoni/obsidian-export`, found at [smaroukis/obsidian-export](https://github.com/smaroukis/obsidian-export), specifically merged with [this pull request](LINK TODO) which adds support for non-url encoded filenames. See compiling this program below.

## Changes
- moved `hugofiles/render-links.html`, etc. to the actual hugo site, in `layouts/_default/_markup` & deleted relevant shell script lines


## Working On
- gh-pages fails because of the binary is only for macos/Darwin, need to compile for linux


## Compiling Rust Binary

Clone `smaroukis/obsidian-export` and `cd` into the folder with the `cargo.toml` file and run `cargo build`. 

### Prereq: Installing rust and cargo.
- using rust `rustc 1.73.0 (cc66ad468 2023-10-03)` (from `rustc --version`)
- using cargo `cargo 1.73.0 (9c4383fb5 2023-08-26)`

Setting up the VPS
`sudo apt-get install build-essential`
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
`source $HOME/.cargo/env`
`rustup default stable`

Building
`cargo build`from the rust project root 


TODO
- [] avoid publishing draft = False files
