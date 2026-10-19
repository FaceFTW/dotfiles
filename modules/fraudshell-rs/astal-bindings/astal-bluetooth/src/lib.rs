#![cfg_attr(docsrs, feature(doc_cfg))]
#![allow(unsafe_op_in_unsafe_fn)]
#![allow(unused_imports)]
#![allow(dead_code)]

macro_rules! assert_initialized_main_thread {
    () => {};
}

use astal_bluetooth_sys as ffi;
pub use auto::*;

mod auto;
mod device;
pub mod prelude;
