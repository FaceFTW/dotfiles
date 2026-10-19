#![cfg_attr(docsrs, feature(doc_cfg))]
#![allow(unsafe_op_in_unsafe_fn)]
#![allow(unused_imports)]

macro_rules! assert_initialized_main_thread {
    () => {};
}

use astal_apps_sys as ffi;
pub use auto::*;

mod auto;
pub mod prelude;
