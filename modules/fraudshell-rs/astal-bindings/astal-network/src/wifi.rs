use std::pin::Pin;

use astal_network_sys::AstalNetworkWifi;
use gio::ffi::GAsyncResult;
use glib::object::{IsA, ObjectType};
use glib::translate::from_glib_full;

use crate::Wifi;
use crate::ffi;

pub trait WifiExtManual: IsA<Wifi> + ObjectType<GlibType = AstalNetworkWifi> {
    #[doc(alias = "astal_network_wifi_deactivate_connection")]
    fn deactivate_connection<P: FnOnce(Result<(), glib::Error>) + 'static>(&self, callback: P) {
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

        unsafe extern "C" fn deactivate_connection_trampoline<
            P: FnOnce(Result<(), glib::Error>) + 'static,
        >(
            _source_object: *mut glib::gobject_ffi::GObject,
            res: *mut GAsyncResult,
            user_data: glib::ffi::gpointer,
        ) {
            let mut error = std::ptr::null_mut();
            ffi::astal_network_wifi_deactivate_connection_finish(
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

        let callback = deactivate_connection_trampoline::<P>;

        unsafe {
            ffi::astal_network_wifi_deactivate_connection(
                self.to_glib_none().0,
                Some(callback),
                Box::into_raw(user_data) as *mut _,
            );
        }
    }

    #[doc(alias = "astal_network_wifi_deactivate_connection")]
    fn deactivate_connection_future(
        &self,
    ) -> Pin<Box<dyn Future<Output = Result<(), glib::Error>> + 'static>> {
        Box::pin(gio::GioFuture::new(self, move |obj, _, send| {
            obj.deactivate_connection(move |result| {
                send.resolve(result);
            });
        }))
    }
}

impl<T: IsA<Wifi> + ObjectType<GlibType = AstalNetworkWifi>> WifiExtManual for T {}
