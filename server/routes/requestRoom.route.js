const router = require("express").Router();
const ctrls = require("../controllers/requestRoom.controller");
const { verifyToken } = require("../middlewares/verifyToken.middleware");
const validateDto = require("../middlewares/validateDto.middleware");
const joi = require("joi");
const { numberReq, stringReq } = require("../middlewares/schema.middleware");

/**
 * GET: Lấy danh sách yêu cầu tìm phòng (không cần xác thực)
 */
router.get("/", ctrls.getAllRequestRoom);

/**
 * POST: Gửi yêu cầu tìm phòng (phải đăng nhập)
 */
router.post(
  "/",
  verifyToken,
  validateDto(
    joi.object({
      userId: numberReq,
      priceRange: stringReq,
      location: stringReq,
      contactInfo: stringReq,
      specialRequirements: joi.string().allow(""),
      financialLimit: joi.string().allow(""),
      numberOfPeople: joi.number().allow(null),
      numberOfVehicles: joi.number().allow(null),
    })
  ),
  ctrls.createRequestRoom
);

/**
 * DELETE: Xóa yêu cầu tìm phòng (phải đăng nhập)
 */
router.delete("/:id", verifyToken, ctrls.deleteRequestRoom);

module.exports = router;
