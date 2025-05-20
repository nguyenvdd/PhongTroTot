const router = require("express").Router()
const ctrls = require("../controllers/post.controller")
const {
  verifyToken,
  isManager,
  isAdmin,
} = require("../middlewares/verifyToken.middleware")
const validateDto = require("../middlewares/validateDto.middleware")
const joi = require("joi")
const {
  stringReq,
  numberReq,
  arrayReq,
  array,
} = require("../middlewares/schema.middleware")
router.post("/suggested", ctrls.getSuggestedPosts)
router.post(
  "/new",
  verifyToken,
  isManager,
  validateDto(
    joi.object({
      title: stringReq,
      address: stringReq,
      description: stringReq,
      catalogId: numberReq,
      images: arrayReq,
      rooms: array,
    })
  ),
  ctrls.createNewPost
)
router.patch(
  "/:id",
  verifyToken,
  isManager,
  validateDto(
    joi.object({
      title: stringReq,
      address: stringReq,
      description: stringReq,
      catalogId: numberReq,
      images: arrayReq,
      rooms: array,
    })
  ),
  ctrls.updatePost
)
router.get("/", ctrls.getPosts)
router.get("/wishlist", ctrls.getPostWishlist)
router.get("/admin/",verifyToken, isAdmin,ctrls.getAdminPosts)
router.get("/:pid", ctrls.getPostById)
router.delete("/:id", verifyToken, isManager, ctrls.removePost)

module.exports = router
