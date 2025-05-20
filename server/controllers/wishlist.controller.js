const asyncHandler = require("express-async-handler");
const db = require("../models");

module.exports = {
  // ✅ 1. Lấy danh sách bài viết yêu thích của user
  getWishlistByUserId: asyncHandler(async (req, res) => {
    const { id } = req.user;

    const wishlists = await db.Wishlist.findAll({
      where: { userId: id, isDeleted: false },
      include: [
        {
          model: db.Post,
          as: "post",
          include: [
            {
              model: db.User,
              as: "rUser",
              attributes: ["id", "username"],
              include: [{ model: db.Profile, as: "rprofile", attributes: ["image"] }],
            },
            {
              model: db.Room,
              as: "rRooms",
              attributes: { exclude: ["createdAt", "updatedAt"] },
            },
            {
              model: db.Catalog,
              as: "rCatalog",
              attributes: ["id", "value"],
            },
          ],
        },
      ],
    });

    return res.json({
      success: true,
      wishlists,
    });
  }),

  // ✅ 2. Thêm bài viết vào wishlist
  addToWishlist: asyncHandler(async (req, res) => {
    const { id } = req.user;
    const { pid } = req.params;

    const existing = await db.Wishlist.findOne({
      where: { userId: id, postId: pid },
    });

    if (existing && !existing.isDeleted) {
      return res.status(400).json({
        success: false,
        mes: "Bài viết đã có trong danh sách yêu thích",
      });
    }

    if (existing && existing.isDeleted) {
      await db.Wishlist.update({ isDeleted: false }, { where: { id: existing.id } });
    } else {
      await db.Wishlist.create({ userId: id, postId: pid });
    }

    return res.json({
      success: true,
      mes: "Đã thêm vào danh sách yêu thích",
    });
  }),

  // ✅ 3. Xóa bài viết khỏi wishlist
  deleteFromWishlist: asyncHandler(async (req, res) => {
    const { id } = req.user;
    const { pid } = req.params;

    const result = await db.Wishlist.update(
      { isDeleted: true },
      { where: { userId: id, postId: pid } }
    );

    return res.json({
      success: true,
      mes: "Đã xóa khỏi danh sách yêu thích",
    });
  }),
};
