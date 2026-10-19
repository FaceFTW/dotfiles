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

mod auto;
pub mod prelude;
use astal_sys as ffi;
pub use auto::*;
use glib::object as gobject;
use gtk4 as gtk;
