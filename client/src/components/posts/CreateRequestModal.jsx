import React, { useState } from "react";
import { apiCreateRequestRoom } from "~/apis/requestRoom"
import { toast } from "react-toastify";

const PRIMARY_COLOR = "#007370";

const CreateRequestModal = ({ open, onClose, fetchRequests }) => {
  const user = JSON.parse(localStorage.getItem("phongtro"))?.state?.current;

  const [form, setForm] = useState({
    location: "",
    priceRange: "",
    contactInfo: user?.phone || "",
    specialRequirements: "",
    financialLimit: "",
    numberOfPeople: 1,
    numberOfVehicles: 0,
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async () => {
    if (!form.location || !form.priceRange || !form.contactInfo) {
      toast.error("Vui lòng nhập đầy đủ thông tin bắt buộc");
      return;
    }

    try {
      const res = await apiCreateRequestRoom({
        ...form,
        userId: user?.id,
      });

      toast.success("Tạo yêu cầu thành công");
      setForm({
        location: "",
        priceRange: "",
        contactInfo: user?.phone || "",
        specialRequirements: "",
        financialLimit: "",
        numberOfPeople: 1,
        numberOfVehicles: 0,
      });
      onClose();
      fetchRequests();
    } catch {
      toast.error("Tạo yêu cầu thất bại");
    }
  };

  if (!open) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white w-[90%] max-w-lg rounded-xl p-6 shadow space-y-4 relative">
        <h2 className="text-xl font-semibold text-center">Tạo yêu cầu tìm phòng</h2>

        <div className="space-y-3">
          <div>
            <label className="block font-medium">Khu vực *</label>
            <input
              name="location"
              value={form.location}
              onChange={handleChange}
              className="w-full border rounded px-3 py-2 mt-1"
              placeholder="VD: Quận 1, Bình Thạnh..."
              required
            />
          </div>

          <div>
            <label className="block font-medium">Khoảng giá *</label>
            <input
              name="priceRange"
              value={form.priceRange}
              onChange={handleChange}
              className="w-full border rounded px-3 py-2 mt-1"
              placeholder="VD: 3tr - 4tr"
              required
            />
          </div>

          <div>
            <label className="block font-medium">Thông tin liên hệ *</label>
            <input
              name="contactInfo"
              value={form.contactInfo}
              onChange={handleChange}
              className="w-full border rounded px-3 py-2 mt-1"
              placeholder="SĐT / Zalo"
              required
            />
          </div>

          <div>
            <label className="block font-medium">Yêu cầu đặc biệt</label>
            <textarea
              name="specialRequirements"
              value={form.specialRequirements}
              onChange={handleChange}
              className="w-full border rounded px-3 py-2 mt-1"
              rows={3}
              placeholder="VD: cửa sổ, bếp, thú cưng..."
            />
          </div>

          <div>
            <label className="block font-medium">Giới hạn tài chính</label>
            <input
              name="financialLimit"
              value={form.financialLimit}
              onChange={handleChange}
              className="w-full border rounded px-3 py-2 mt-1"
              placeholder="VD: dưới 5 triệu"
            />
          </div>

          <div className="flex gap-4">
            <div className="flex-1">
              <label className="block font-medium">Số người</label>
              <input
                name="numberOfPeople"
                type="number"
                min={1}
                value={form.numberOfPeople}
                onChange={handleChange}
                className="w-full border rounded px-3 py-2 mt-1"
              />
            </div>
            <div className="flex-1">
              <label className="block font-medium">Số xe</label>
              <input
                name="numberOfVehicles"
                type="number"
                min={0}
                value={form.numberOfVehicles}
                onChange={handleChange}
                className="w-full border rounded px-3 py-2 mt-1"
              />
            </div>
          </div>
        </div>

        <div className="flex justify-end gap-3 mt-6">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded border border-gray-400 hover:bg-gray-100"
          >
            Hủy
          </button>
          <button
            onClick={handleSubmit}
            className="px-4 py-2 rounded text-white"
            style={{ backgroundColor: PRIMARY_COLOR }}
          >
            Gửi yêu cầu
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateRequestModal;
