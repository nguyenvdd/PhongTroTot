import React, { useEffect, useState } from "react";
import CreateRequestModal from "./CreateRequestModal";
import { apiGetRequestRooms } from "~/apis/requestRoom";
import { apiDeleteRequestRoom } from "~/apis/requestRoom";
import { FaPhoneAlt } from "react-icons/fa";
import Swal from "sweetalert2";

const PRIMARY_COLOR = "#007370";
const ITEMS_PER_PAGE = 4;
const DEFAULT_IMAGE = "https://source.unsplash.com/800x600/?room,rent";

const ListTimPhong = () => {
  const [requests, setRequests] = useState([]);
  const [openModal, setOpenModal] = useState(false);
  const [page, setPage] = useState(1);

  const user = JSON.parse(localStorage.getItem("phongtro"))?.state?.current;
  const role = user?.rroles?.[0]?.roleCode;
  const userId = user?.id;

  const fetchRequests = async () => {
    const res = await apiGetRequestRooms();
    if (res?.success) setRequests(res.requestRooms);
  };

  const handleDelete = async (id) => {
    const result = await Swal.fire({
      title: "Bạn có chắc muốn xóa?",
      text: "Hành động này không thể hoàn tác!",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6",
      confirmButtonText: "Xóa",
      cancelButtonText: "Hủy"
    });
    if (!result.isConfirmed) return;
    const res = await apiDeleteRequestRoom(id);
    if (res?.success) {
      setRequests((prev) => prev.filter((item) => item.id !== id));
      await Swal.fire({
        icon: "success",
        title: "Đã xóa thành công!",
        showConfirmButton: false,
        timer: 1500
      });
    } else {
      Swal.fire({
        icon: "error",
        title: "Xóa thất bại!",
        text: "Vui lòng thử lại."
      });
    }
  };

  useEffect(() => {
    fetchRequests();
  }, []);

  const paginatedData = requests.slice(
    (page - 1) * ITEMS_PER_PAGE,
    page * ITEMS_PER_PAGE
  );
  const totalPages = Math.ceil(requests.length / ITEMS_PER_PAGE);

  return (
    <div className="max-w-7xl mx-auto px-4 py-6 space-y-6">
      {/* Tạo yêu cầu */}
      <div className="flex justify-end">
        <button
          onClick={() => setOpenModal(true)}
          className="bg-[#007370] text-white px-5 py-3 rounded-lg hover:bg-[#005f5a] transition font-medium"
        >
          Tạo yêu cầu tìm phòng
        </button>
      </div>
      {/* Danh sách yêu cầu */}
      {paginatedData.length === 0 ? (
        <div className="text-center text-gray-500 py-10 text-lg">Không có yêu cầu nào.</div>
      ) : (
        <div className="space-y-6">
          {paginatedData.map((item) => (
            <div
              key={item.id}
              className="bg-white shadow rounded-2xl overflow-hidden flex flex-col lg:flex-row hover:shadow-lg transition-all duration-300"
            >
              {/* Ảnh */}
              {/* Ảnh nhỏ hơn */}
              <div className="lg:w-1/3 w-full max-h-56 overflow-hidden">
                <img
                  src={"https://i.pinimg.com/736x/e0/85/39/e085398da428e9fb130f0edf1754d191.jpg"}
                  alt="room"
                  className="w-full h-full object-cover rounded-l-xl"
                />
              </div>


              {/* Nội dung */}
              <div className="lg:w-2/3 w-full p-4 flex flex-col justify-between text-sm">

                <div>
                  <div className="flex justify-between items-start mb-2">
                    <h3 className="text-2xl font-semibold text-[#007370]">{item.location}</h3>
                    <span
                      className={`text-sm px-3 py-1 rounded-full text-white font-medium ${item.isActive ? "bg-[#007370]" : "bg-gray-400"
                        }`}
                    >
                      {item.isActive ? "Đang mở" : "Đã đóng"}
                    </span>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-2 text-[16px] mb-3">
                    <p><strong>Khoảng giá:</strong> {item.priceRange}</p>
                    <p><strong>Liên hệ:</strong> {item.contactInfo}</p>
                    <p><strong>Số người:</strong> {item.numberOfPeople || "-"}</p>
                    <p><strong>Số xe:</strong> {item.numberOfVehicles || "-"}</p>
                  </div>

                  {item.specialRequirements && (
                    <p className="text-gray-700 text-[15px] mt-2">
                      <strong>Yêu cầu:</strong>{" "}
                      <span className="line-clamp-2">{item.specialRequirements}</span>
                    </p>
                  )}
                </div>

                {role === "MANAGER" && (
                  <div className="mt-5">
                    <button
                      className="bg-[#007370] text-white py-2 px-6 rounded-md flex items-center gap-2 hover:bg-[#005f5a] transition"
                    >
                      <FaPhoneAlt size={14} /> Liên hệ
                    </button>
                  </div>
                )}

                {(item.userId === userId || role === "ADMIN") && (
                  <div className="mt-3 flex justify-end">
                    <button
                      onClick={() => handleDelete(item.id)}
                      className="bg-red-500 text-white py-2 px-6 rounded-md flex items-center gap-2 hover:bg-red-700 transition"
                    >
                      Xóa
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Phân trang */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-2 mt-10">
          {Array.from({ length: totalPages }, (_, i) => i + 1).map((num) => (
            <button
              key={num}
              onClick={() => setPage(num)}
              className={`px-4 py-2 rounded-lg text-sm ${page === num
                ? "bg-[#007370] text-white"
                : "bg-gray-200 text-gray-800 hover:bg-gray-300"
                } transition`}
            >
              {num}
            </button>
          ))}
        </div>
      )}

      {/* Modal */}
      <CreateRequestModal
        open={openModal}
        onClose={() => setOpenModal(false)}
        fetchRequests={fetchRequests}
      />
    </div>
  );
};

export default ListTimPhong;
