#![cfg_attr(docsrs, feature(doc_cfg))]
#![allow(unsafe_op_in_unsafe_fn)]
#![allow(unused_imports)]
#![allow(dead_code)]

macro_rules! assert_initialized_main_thread {
    () => {};
}

macro_rules! skip_assert_initialized {
    () => {};
}

// Core module (always enabled)
pub mod core;

// Feature-gated library modules
#[cfg(feature = "battery")]
pub mod battery;

#[cfg(feature = "apps")]
pub mod apps;

#[cfg(feature = "auth")]
pub mod auth;

#[cfg(feature = "bluetooth")]
pub mod bluetooth;

#[cfg(feature = "cava")]
pub mod cava;

#[cfg(feature = "greet")]
pub mod greet;

#[cfg(feature = "hyprland")]
pub mod hyprland;

#[cfg(feature = "io")]
pub mod io;

#[cfg(feature = "mpris")]
pub mod mpris;

#[cfg(feature = "network")]
pub mod network;

#[cfg(feature = "notifd")]
pub mod notifd;

#[cfg(feature = "niri")]
pub mod niri;

#[cfg(feature = "powerprofiles")]
pub mod powerprofiles;

#[cfg(feature = "river")]
pub mod river;

#[cfg(feature = "tray")]
pub mod tray;

#[cfg(feature = "wireplumber")]
pub mod wireplumber;

pub mod prelude;
