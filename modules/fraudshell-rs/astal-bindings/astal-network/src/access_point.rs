use std::pin::Pin;

use gio::Cancellable;
use gio::ffi::GAsyncResult;
use glib::object::{IsA, ObjectType};
use glib::translate::{ToGlibPtr, from_glib_full};

use crate::{AccessPoint, ffi};

pub trait AccessPointExtManual:
    IsA<AccessPoint> + ObjectType<GlibType = crate::ffi::AstalNetworkAccessPoint>
{
    #[doc(alias = "astal_network_access_point_activate")]
    fn activate<P: FnOnce(Result<(), glib::Error>) + 'static>(
        &self,
        password: Option<&str>,
        callback: P,
    ) {
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

        unsafe extern "C" fn activate_trampoline<P: FnOnce(Result<(), glib::Error>) + 'static>(
            _source_object: *mut glib::gobject_ffi::GObject,
            res: *mut GAsyncResult,
            user_data: glib::ffi::gpointer,
        ) {
            let mut error = std::ptr::null_mut();
            ffi::astal_network_access_point_activate_finish(
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

        let callback = activate_trampoline::<P>;

        unsafe {
            ffi::astal_network_access_point_activate(
                self.to_glib_none().0,
                password.to_glib_none().0,
                Some(callback),
                Box::into_raw(user_data) as *mut _,
            );
        }
    }

    fn activate_future(
        &self,
        password: Option<&str>,
    ) -> Pin<Box<dyn Future<Output = Result<(), glib::Error>> + 'static>> {
        let password = password.map(|s| s.to_owned());
        Box::pin(gio::GioFuture::new(self, move |obj, _, send| {
            obj.activate(password.as_deref(), move |result| {
                send.resolve(result);
            });
        }))
    }
}

impl<T: IsA<AccessPoint> + ObjectType<GlibType = ffi::AstalNetworkAccessPoint>> AccessPointExtManual
    for T
{
}
