const router = require("express").Router();
const ctrls = require("../controllers/wishlist.controller");
const { verifyToken } = require("../middlewares/verifyToken.middleware");

// Lấy danh sách bài viết yêu thích của user
router.get("/", verifyToken, ctrls.getWishlistByUserId);
router.post("/:pid", verifyToken, ctrls.addToWishlist);
router.delete("/:pid", verifyToken, ctrls.deleteFromWishlist);

module.exports = router;
