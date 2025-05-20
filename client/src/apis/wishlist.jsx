import axios from "../axios";

// 🔍 Lấy danh sách bài viết yêu thích của người dùng hiện tại
export const apiGetWishlist = () =>
  axios({
    url: "/wishlist",
    method: "get",
  });

// ❤️ Thêm một bài viết vào wishlist
export const apiAddToWishlist = (postId) =>
  axios({
    url: `/wishlist/${postId}`,
    method: "post",
  });

// ❌ Xóa một bài viết khỏi wishlist
export const apiRemoveFromWishlist = (postId) =>
  axios({
    url: `/wishlist/${postId}`,
    method: "delete",
  });
