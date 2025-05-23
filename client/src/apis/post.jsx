import axios from "../axios"

export const apiCreateNewPost = (data) =>
  axios({
    url: "/post/new",
    method: "post",
    data,
  })
export const apiGetPosts = (params) =>
  axios({
    url: "/post/",
    method: "get",
    params,
  })
export const apiGetPostWishlist = (params) =>
  axios({
    url: "/post/wishlist",
    method: "get",
    params,
  })
export const apiGetAdminPosts = (params) =>
  axios({
    url: "/post/admin/",
    method: "get",
    params,
  })
export const apiGetPostById = (id) =>
  axios({
    url: "/post/" + id,
    method: "get",
  })
export const apiUpdatePost = (id, data) =>
  axios({
    url: "/post/" + id,
    method: "patch",
    data,
  })
export const apiRemovePost = (id) =>
  axios({
    url: "/post/" + id,
    method: "delete",
  })
export const apiRatings = (id, data) =>
  axios({
    url: "/rating/" + id,
    method: "post",
    data,
  })
export const apiSuggestPost = (data) =>
  axios({
    url: "/post/suggested",
    method: "post",
    data,
  });
