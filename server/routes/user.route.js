const router = require("express").Router()
const joi = require("joi")
const validate = require("../middlewares/validateDto.middleware")
const { password, stringReq, string, arrayReq } = require("../middlewares/schema.middleware")
const ctrls = require("../controllers/user.controller")
const { verifyToken, isManager, isAdmin } = require("../middlewares/verifyToken.middleware")

router.post("/validate-phonenumber", validate(joi.object({ phone: stringReq })), ctrls.verifyPhoneNumber)
router.post(
  "/register",
  validate(
    joi.object({
      phone: stringReq,
      password: stringReq,
      username: stringReq,
      roleCode: stringReq,
    })
  ),
  ctrls.register
)
router.post(
  "/login",
  validate(
    joi.object({
      phone: stringReq,
      password: stringReq,
    })
  ),
  ctrls.login
)
router.post(
  "/google-login",
  validate(
    joi.object({
      idToken: stringReq,
    })
  ),
  ctrls.loginWithGoogle
);
router.patch(
  "/profile",
  verifyToken,
  validate(
    joi.object({
      phone: stringReq,
      username: stringReq,
      address: stringReq,
      email: stringReq,
      lastName: stringReq,
      firstName: stringReq,
      gender: stringReq,
      CID: stringReq,
      image: string,
    })
  ),
  ctrls.updateProfile
)
router.get("/current", verifyToken, ctrls.getCurrent)
router.get("/rented-rooms", verifyToken, ctrls.getRentedRooms)
router.get("/rented-rooms-idx-counter/:roomId", verifyToken, ctrls.getIndexCounterByRoomId)
router.get("/manager", verifyToken, isManager, ctrls.getUsersbyManager)
router.get("/customer", verifyToken, isManager, ctrls.getCustomersByManager)
router.get("/admin", verifyToken, isAdmin, ctrls.getCustomersByAdmin)
router.get("/", verifyToken, isAdmin, ctrls.getUsers)
router.get("/manager/", verifyToken, isAdmin, ctrls.getUsersbyManager)
router.patch("/utm", verifyToken, ctrls.updateManager)
router.patch("/payment-idx/:id", verifyToken, isManager, ctrls.updatePaymentIndex)
router.delete("/:id", verifyToken, isAdmin, ctrls.deleteUser)
router.patch(
  "/update-by-manager/:id",
  verifyToken,
  isManager,
  validate(
    joi.object({
      phone: stringReq,
      address: string,
      lastName: string,
      firstName: string,
      gender: string,
      image: string,
    })
  ),
  ctrls.updateUserByManager
)
router.patch(
  "/change-password",
  verifyToken, // Đảm bảo người dùng đã đăng nhập
  validate(
    joi.object({
      currentPassword: password.required(), // Mật khẩu cũ
      newPassword: password.required(), // Mật khẩu mới
    })
  ),
  ctrls.changePassword // Controller xử lý logic thay đổi mật khẩu
)
router.post("/forgot-password", ctrls.forgotPassword)

// Reset Password - Cập nhật mật khẩu mới
router.post("/reset-password", ctrls.resetPassword)
router.patch(
  "/update/:id",
  verifyToken,
  isAdmin,
  validate(
    joi.object({
      phone: stringReq,
      username: stringReq,
      address: string,
      email: string,
      lastName: string,
      firstName: string,
      gender: string,
      image: string,
      role: arrayReq,
    })
  ),
  ctrls.updateUser
)
module.exports = router
