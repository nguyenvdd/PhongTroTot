import axios from "../axios"
import axiosLibrary from "axios"

export const apiGetRoles = () =>
  axios({
    url: "/app/roles",
    method: "get",
  })
export const apiGetCatalogs = () =>
  axios({
    url: "/app/catalogs",
    method: "get",
  })
export const apiUploadImage = (data) =>
  axiosLibrary({
    url: `https://api.cloudinary.com/v1_1/${import.meta.env.VITE_CLOUDINARY_NAME}/image/upload`,
    method: "post",
    data,
  })
export const apiGetLngLatFromAddress = (params) =>
  axiosLibrary({
    method: "get",
    url: `https://api.geoapify.com/v1/geocode/search`,
    params,
  })
export const apiGetDashboardManager = (params) =>
  axios({
    url: "/app/dashboard/manager",
    method: "get",
    params,
  })
  export const apiGetDashboardAdminManager = (params) =>
    axios({
      url: "/app/dashboard/admin/manager",
      method: "get",
      params,
    })
export const apiGetDashboardAdmin = (params) =>
  axios({
    url: "/app/dashboard/admin",
    method: "get",
    params,
  })
export const apiGetUsersManager = (params) =>
    axios({
      url: "/user/manager/",
      method: "get",
      params,
    })
export const apiGetDashboardRoom = (params) =>
  axios({
    url: "/app/dashboard/room",
    method: "get",
    params,
  })