import axios from "../axios";

// Lấy danh sách yêu cầu tìm phòng (có phân trang & tìm kiếm)
export const apiGetRequestRooms = (params) =>
  axios({
    url: "/request-rooms/",
    method: "get",
    params,
  });

// Tạo mới một yêu cầu tìm phòng
export const apiCreateRequestRoom = (data) =>
  axios({
    url: "/request-rooms/",
    method: "post",
    data,
  });

// Xóa (mềm) một yêu cầu tìm phòng theo ID
export const apiDeleteRequestRoom = (id) =>
  axios({
    url: "/request-rooms/" + id,
    method: "delete",
  });
