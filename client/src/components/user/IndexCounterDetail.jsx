import moment from "moment";
import React, { useEffect, useState } from "react";
import { apiGetIndexCounterByRoomId, apiCreatePaymentOrder, apiUpdatePaymentIndex } from "~/apis/user"; // Import các hàm API
import { formatMoney } from "~/utilities/fn";
import { toast } from "react-toastify"; // Đảm bảo bạn có thư viện này để thông báo

const IndexCounterDetail = ({ roomId, roomPrices }) => {
  const [counter, setCounter] = useState();

  useEffect(() => {
    const fetchIndexCounter = async () => {
      const response = await apiGetIndexCounterByRoomId(roomId);
      if (response.success) setCounter(response.indexCounter);
    };
    fetchIndexCounter();
  }, [roomId]);
  const handlePayment = async (roomId, totalAmount, paymentId) => {
    try {
      const orderInfo = `${roomId}AND${paymentId}`; // Thông tin đơn hàng
      const returnUrl = "http://localhost:5173/thanh-vien/phong-thue-cua-toi"; // URL trả về sau khi thanh toán xong

      const response = await apiCreatePaymentOrder(totalAmount, orderInfo, returnUrl);

      if (response) {
        window.location.href = response.paymentUrl;
      } else {
        alert("Có lỗi xảy ra khi tạo URL thanh toán.");
      }
    } catch (error) {
      console.error("Lỗi khi tạo đơn thanh toán:", error);
      alert("Có lỗi xảy ra khi thanh toán.");
    }
  };


  return (
    <>
      {roomId && (
        <div
          onClick={(e) => e.stopPropagation()}
          className="w-[100%] md:w-[800px] max-h-[95vh] overflow-y-auto p-4 rounded-md bg-white"
        >
          <h1 className="pb-4 text-xl font-bold border-b">Chi tiết chỉ số</h1>
          <table className="my-6 w-full">
            <thead>
              <tr>
                <th className="border p-3 text-center">Ngày ghi sổ</th>
                <th className="border p-3 text-center">Chỉ số điện (kWh x vnđ)</th>
                <th className="border p-3 text-center">
                  Chỉ số nước (
                  <span>
                    m<sup>3</sup> x vnđ
                  </span>
                  )
                </th>
                <th className="border p-3 text-center">Dùng internet (vnđ)</th>
                <th className="border p-3 text-center">Dùng truyền hình cap (vnđ)</th>
                <th className="border p-3 text-center">Tiền phòng (vnđ)</th>
                <th className="border p-3 text-center">Thành tiền (vnđ)</th>
                <th className="border p-3 text-center">Trạng thái</th>
                <th className="border p-3 text-center w-[150px]">Hành động</th> {/* Cột hành động */}
              </tr>
            </thead>
            <tbody>
              {counter?.map((el) => {
                const totalAmount =
                  roomPrices.price +
                  el.electric * roomPrices?.electricPrice +
                  el.water * roomPrices?.waterPrice +
                  (el.internet ? 1 : 0) * roomPrices?.internetPrice +
                  (el.caps ? 1 : 0) * roomPrices?.capsPrice;

                return (
                  <tr key={el.id}>
                    <td className="border p-3 text-center">{moment(el.date).format("DD/MM/YYYY")}</td>
                    <td className="border p-3 text-center">{`${formatMoney(el.electric)} x ${formatMoney(roomPrices?.electricPrice)}`}</td>
                    <td className="border p-3 text-center">{`${formatMoney(el.water)} x ${formatMoney(roomPrices?.waterPrice)}`}</td>
                    <td className="border p-3 text-center">
                      {el.internet ? formatMoney(roomPrices?.internetPrice) : 0}
                    </td>
                    <td className="border p-3 text-center">
                      {el.caps ? formatMoney(roomPrices?.capsPrice) : 0}
                    </td>
                    <td className="border p-3 text-center">{formatMoney(roomPrices.price)}</td>
                    <td className="border p-3 text-center">{formatMoney(totalAmount)}</td>
                    <td className="border p-3 text-center">
                      {el.isPayment ? "Đã thanh toán" : "Chưa thanh toán"}
                    </td>
                    <td className="border p-3 text-center">
                      {!el.isPayment && (
                        <button
                          onClick={() => handlePayment(el.roomId, totalAmount, el.id)} // Gọi hàm thanh toán
                          className="px-4 py-2 bg-blue-500 text-white rounded-md"
                        >
                          Thanh toán
                        </button>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </>
  );
};

export default IndexCounterDetail;
