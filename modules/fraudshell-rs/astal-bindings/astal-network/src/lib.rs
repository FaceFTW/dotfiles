#![cfg_attr(docsrs, feature(doc_cfg))]
#![allow(unsafe_op_in_unsafe_fn)]
#![allow(deprecated)]
#![allow(unused_imports)]

macro_rules! assert_initialized_main_thread {
    () => {};
}

macro_rules! skip_assert_initialized {
    () => {};
}

use astal_network_sys as ffi;
pub use auto::*;

mod access_point;
mod auto;
pub mod prelude;
mod wifi;

pub use nm_rs as nm;

pub mod functions {
    pub use super::auto::functions::*;
}
