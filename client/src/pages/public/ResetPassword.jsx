import React, { useState } from "react"
import { useNavigate, useSearchParams } from "react-router-dom"
import { toast } from "react-toastify"
import { apiResetPassword } from "~/apis/user" // Import API resetPassword

const ResetPassword = () => {
  const navigate = useNavigate()  // Hook navigate để điều hướng đến trang khác
  const [newPassword, setNewPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [message, setMessage] = useState("")
  const [searchParams] = useSearchParams()
  const token = searchParams.get("token") // Lấy token từ URL

  const handleResetPassword = async () => {
    if (newPassword !== confirmPassword) {
      setMessage("Mật khẩu mới và xác nhận mật khẩu không khớp.")
      return
    }
    setIsLoading(true)
    try {
      const response = await apiResetPassword({ token, newPassword })
      if (response.success) {
        setMessage("Mật khẩu đã được thay đổi.")
        navigate("/dang-nhap") // Chuyển hướng về trang đăng nhập
      } else {
        setMessage(response.mes || "Có lỗi xảy ra. Vui lòng thử lại.")
      }
    } catch (error) {
      setMessage("Có lỗi xảy ra. Vui lòng thử lại.")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <section className="h-screen w-full relative overflow-hidden">
      <img src="/lg-bg.jpg" alt="backgound-reset-password" className="w-full h-full grayscale object-cover" />
      <div className="absolute inset-0 p-4 bg-overlay-50 flex items-center justify-center">
        <div className="bg-white w-full sm:w-3/5 lg:w-[30%] py-4 md:px-8 px-4 rounded-md flex flex-col items-center gap-4">
          <h1 className="font-bold text-2xl mt-3">Đặt lại mật khẩu</h1>
          <form className="w-full flex flex-col pb-12 gap-4">
            <input
              type="password"
              placeholder="Nhập mật khẩu mới"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-md"
            />
            <input
              type="password"
              placeholder="Xác nhận mật khẩu mới"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className="px-4 py-2 border border-gray-300 rounded-md"
            />
            <button
              type="button"
              onClick={handleResetPassword}
              className="w-full mt-4 mb-3 bg-[#007370] text-white py-2 rounded-md"
              disabled={isLoading}
            >
              {isLoading ? "Đang xử lý..." : "Đặt lại mật khẩu"}
            </button>
            {message && <p className="text-red-500 text-sm">{message}</p>}
            <span
              className="text-sm text-[#007370] cursor-pointer"
              onClick={() => navigate("/dang-nhap")}
            >
              Quay lại đăng nhập
            </span>
          </form>
        </div>
      </div>
    </section>
  )
}

export default ResetPassword
