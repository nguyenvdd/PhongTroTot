const router = require("express").Router()
const ctrls = require("../controllers/contract.controller")
const { verifyToken, isManager, isAdmin } = require("../middlewares/verifyToken.middleware")
const validateDto = require("../middlewares/validateDto.middleware")
const joi = require("joi")
const { stringReq, numberReq, dateReq } = require("../middlewares/schema.middleware")
router.post(
  "/new",
  verifyToken,
  isManager,
  validateDto(
    joi.object({
      CID: numberReq,
      address: stringReq,
      expiredAt: dateReq,
      firstName: stringReq,
      lastName: stringReq,
      notes: stringReq,
      preMoney: numberReq,
      roomId: numberReq,
      userId: numberReq,
      stayNumber: numberReq,
    })
  ),
  ctrls.create
)
router.get("/admin/",verifyToken, isAdmin,ctrls.getAdmin)
router.get("/customer", verifyToken, isManager, ctrls.getCustomer)
router.get("/", verifyToken, ctrls.get)
router.patch(
  "/",
  verifyToken,
  isManager,
  validateDto(
    joi.object({
      CID: numberReq,
      address: stringReq,
      expiredAt: dateReq,
      firstName: stringReq,
      lastName: stringReq,
      notes: stringReq,
      preMoney: numberReq,
      roomId: numberReq,
      userId: numberReq,
      stayNumber: numberReq,
    })
  ),
  ctrls.update
)
router.delete("/:id", verifyToken, isManager, ctrls.remove)

module.exports = router
