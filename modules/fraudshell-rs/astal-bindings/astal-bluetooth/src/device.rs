use std::pin::Pin;

use astal_bluetooth_sys::AstalBluetoothDevice;
use gio::ffi::GAsyncResult;
use glib::object::IsA;
use glib::object::ObjectType;
use glib::translate::FromGlibPtrFull;
use glib::translate::ToGlibPtr;
use glib::translate::from_glib_full;

use crate::Device;
use crate::ffi;

pub trait DeviceExtManual: IsA<Device> + ObjectType<GlibType = AstalBluetoothDevice> {
    #[doc(alias = "astal_bluetooth_device_connect_device")]
    fn connect_device<P: FnOnce(Result<(), glib::Error>) + 'static>(&self, callback: P) {
        let main_context = glib::MainContext::ref_thread_default();
        let is_main_context_owner = main_context.is_owner();
        let has_acquired_main_context = (!is_main_context_owner)
            .then(|| main_context.acquire().ok())
            .flatten();
        assert!(
            is_main_context_owner || has_acquired_main_context.is_some(),
            "Async operations only allowed if the thread is owning the MainContext"
        );
        let user_data: Box<glib::thread_guard::ThreadGuard<P>> =
            Box::new(glib::thread_guard::ThreadGuard::new(callback));

        unsafe extern "C" fn connect_device_trampoline<
            P: FnOnce(Result<(), glib::Error>) + 'static,
        >(
            _source_object: *mut glib::gobject_ffi::GObject,
            res: *mut GAsyncResult,
            user_data: glib::ffi::gpointer,
        ) {
            let mut error = std::ptr::null_mut();
            ffi::astal_bluetooth_device_connect_device_finish(
                _source_object as *mut _,
                res,
                &mut error,
            );
            let result = if error.is_null() {
                Ok(())
            } else {
                Err(from_glib_full(error))
            };
            let callback: Box<glib::thread_guard::ThreadGuard<P>> =
                Box::from_raw(user_data as *mut _);
            let callback: P = callback.into_inner();
            callback(result);
        }

        let callback = connect_device_trampoline::<P>;

        unsafe {
            ffi::astal_bluetooth_device_connect_device(
                self.to_glib_none().0,
                Some(callback),
                Box::into_raw(user_data) as *mut _,
            );
        }
    }

    #[doc(alias = "astal_bluetooth_device_connect_device")]
    fn connect_device_future(
        &self,
    ) -> Pin<Box<dyn Future<Output = Result<(), glib::Error>> + 'static>> {
        Box::pin(gio::GioFuture::new(self, move |obj, _, send| {
            obj.connect_device(move |result| {
                send.resolve(result);
            });
        }))
    }
    #[doc(alias = "astal_bluetooth_device_disconnect_device")]
    fn disconnect_device<P: FnOnce(Result<(), glib::Error>) + 'static>(&self, callback: P) {
        let main_context = glib::MainContext::ref_thread_default();
        let is_main_context_owner = main_context.is_owner();
        let has_acquired_main_context = (!is_main_context_owner)
            .then(|| main_context.acquire().ok())
            .flatten();
        assert!(
            is_main_context_owner || has_acquired_main_context.is_some(),
            "Async operations only allowed if the thread is owning the MainContext"
        );
        let user_data: Box<glib::thread_guard::ThreadGuard<P>> =
            Box::new(glib::thread_guard::ThreadGuard::new(callback));

        unsafe extern "C" fn disconnect_device_trampoline<
            P: FnOnce(Result<(), glib::Error>) + 'static,
        >(
            _source_object: *mut glib::gobject_ffi::GObject,
            res: *mut GAsyncResult,
            user_data: glib::ffi::gpointer,
        ) {
            let mut error = std::ptr::null_mut();
            ffi::astal_bluetooth_device_disconnect_device_finish(
                _source_object as *mut _,
                res,
                &mut error,
            );
            let result = if error.is_null() {
                Ok(())
            } else {
                Err(from_glib_full(error))
            };
            let callback: Box<glib::thread_guard::ThreadGuard<P>> =
                Box::from_raw(user_data as *mut _);
            let callback: P = callback.into_inner();
            callback(result);
        }

        let callback = disconnect_device_trampoline::<P>;

        unsafe {
            ffi::astal_bluetooth_device_disconnect_device(
                self.to_glib_none().0,
                Some(callback),
                Box::into_raw(user_data) as *mut _,
            );
        }
    }

    #[doc(alias = "astal_bluetooth_device_disconnect_device")]
    fn disconnect_device_future(
        &self,
    ) -> Pin<Box<dyn Future<Output = Result<(), glib::Error>> + 'static>> {
        Box::pin(gio::GioFuture::new(self, move |obj, _, send| {
            obj.disconnect_device(move |result| {
                send.resolve(result);
            });
        }))
    }
}

impl<T: IsA<Device> + ObjectType<GlibType = AstalBluetoothDevice>> DeviceExtManual for T {}
