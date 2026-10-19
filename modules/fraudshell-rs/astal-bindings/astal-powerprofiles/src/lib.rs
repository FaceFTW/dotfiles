#![cfg_attr(docsrs, feature(doc_cfg))]
#![allow(unsafe_op_in_unsafe_fn)]
#![allow(deprecated)]
#![allow(unused_imports)]
#![doc = include_str!("../README.md")]

macro_rules! assert_initialized_main_thread {
    () => {};
}

use astal_power_profiles_sys as ffi;
pub use auto::*;

mod auto;
pub mod prelude;

pub mod functions {
    pub use super::auto::functions::*;
}
