import axios from "../axios"

export const apiValidatePhoneNumber = (data) =>
  axios({
    url: "/user/validate-phonenumber",
    method: "post",
    data,
  })
export const apiRegister = (data) =>
  axios({
    url: "/user/register",
    method: "post",
    data,
  })
export const apiLogin = (data) =>
  axios({
    url: "/user/login",
    method: "post",
    data,
  })
export const apiLoginWithGoogle = (data) =>
  axios({
    url: "/user/google-login",
    method: "post",
    data,
  });

export const apiGetCurrent = () =>
  axios({
    url: "/user/current",
    method: "get",
  })
export const apiUpdateProfile = (data) =>
  axios({
    url: "/user/profile",
    method: "patch",
    data,
  })
export const apiGetUsersByManager = (params) =>
  axios({
    url: "/user/manager",
    method: "get",
    params,
  })
export const apiUpgradeToManager = () =>
  axios({
    url: "/user/utm",
    method: "patch",
  })
export const apiGetUsersByAdmin = (params) =>
  axios({
    url: "/user/",
    method: "get",
    params,
  })
export const apiGetCustomers = (params) =>
  axios({
    url: "/user/customer",
    method: "get",
    params,
  })
export const apiGetCustomersAdmin = (params) =>
  axios({
    url: "/user/admin",
    method: "get",
    params,
  })

export const apiUpdateUser = (id, data) =>
  axios({
    url: "/user/update/" + id,
    method: "patch",
    data,
  })
export const apiDeleteUser = (id) =>
  axios({
    url: "/user/" + id,
    method: "delete",
  })
export const apiUpdateUserByManager = (id, data) =>
  axios({
    url: "/user/update-by-manager/" + id,
    method: "patch",
    data,
  })
export const apiGetMyRooms = (params) =>
  axios({
    url: "/user/rented-rooms/",
    method: "get",
    params,
  })
export const apiGetIndexCounterByRoomId = (roomId) =>
  axios({
    url: "/user/rented-rooms-idx-counter/" + roomId,
    method: "get",
  })
export const apiUpdatePaymentIndex = (id, data) =>
  axios({
    url: "/user/payment-idx/" + id,
    method: "patch",
    data,
  })
export const apiCreatePaymentOrder = (amount, orderInfo, returnUrl) =>
  axios({
    url: "/vnpay/payment", // Đây là endpoint để tạo đơn thanh toán
    method: "get",
    params: {
      amount,
      orderInfo,
      returnUrl,
    },
  });
export const apiChangePassword = (data) =>
  axios({
    url: "/user/change-password", // Endpoint API thay đổi mật khẩu
    method: "patch",
    data, // Dữ liệu gửi lên sẽ chứa currentPassword và newPassword
  })
// API call cho quên mật khẩu
export const apiForgotPassword = (data) =>
  axios({
    url: "/user/forgot-password", // Endpoint API quên mật khẩu
    method: "post",
    data, // Dữ liệu gửi lên sẽ chứa email
  })

// API call cho reset mật khẩu
export const apiResetPassword = (data) =>
  axios({
    url: "/user/reset-password", // Endpoint API reset mật khẩu
    method: "post",
    data, // Dữ liệu gửi lên sẽ chứa token và mật khẩu mới
  })