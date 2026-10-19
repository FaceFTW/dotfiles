# Astal Power Profiles [![][img_crates]][crates] [![][img_doc]][doc]

Rust bindings for the Astal Power Profiles library.

For more information, check out the reference page
at <https://aylur.github.io/libastal/powerprofiles/>.

## Build dependencies

To build this library, the following packages are required:

- glib
- astal-powerprofiles

## Usage example

```rust
use astal_power_profiles::PowerProfiles;
fn get_profiles() {
  let profiles = PowerProfiles::default();
  println!("The active profile is {}", profiles.active_profile())
}
```

[img_crates]: https://img.shields.io/crates/v/astal-power-profiles.svg
[img_doc]: https://img.shields.io/badge/rust-documentation-blue.svg

[crates]: https://crates.io/crates/astal-powerprofiles
[doc]: https://daru-san.github.io/astal-rs/astal-powerprofiles
