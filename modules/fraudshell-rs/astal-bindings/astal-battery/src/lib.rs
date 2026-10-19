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

use astal_battery_sys as ffi;
pub use auto::*;

mod auto;
pub mod prelude;
