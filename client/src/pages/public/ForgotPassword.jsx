import React, { useState } from "react"
import { useForm } from "react-hook-form"
import { Button } from "~/components/commons"
import { InputForm } from "~/components/inputs"
import { toast } from "react-toastify"
import { apiForgotPassword } from "~/apis/user" // Giả sử bạn có API cho việc khôi phục mật khẩu
import { useNavigate } from "react-router-dom"

const ForgotPassword = () => {
  const navigate = useNavigate()  // Hook navigate để điều hướng đến trang khác
  const [isLoading, setIsLoading] = useState(false)
  const {
    register,
    formState: { errors },
    handleSubmit,
    reset,
  } = useForm()

  const onSubmit = async (data) => {
    setIsLoading(true)
    try {
      // Gọi API gửi yêu cầu khôi phục mật khẩu
      const response = await apiForgotPassword(data)
      if (response.success) {
        toast.success("Chúng tôi đã gửi email khôi phục mật khẩu cho bạn!")
      } else {
        toast.error(response.mes || "Có lỗi xảy ra. Vui lòng thử lại!")
      }
    } catch (error) {
      toast.error("Có lỗi xảy ra. Vui lòng thử lại!")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <section className="h-screen w-full relative overflow-hidden">
      <img src="/lg-bg.jpg" alt="backgound-forgot-password" className="w-full h-full grayscale object-cover" />
      <div className="absolute inset-0 p-4 bg-overlay-50 flex items-center justify-center">
        <div className="bg-white w-full sm:w-3/5 lg:w-[30%] py-4 md:px-8 px-4 rounded-md flex flex-col items-center gap-4">
          <h1 className="font-bold text-2xl mt-3">Quên mật khẩu</h1>
          <form className="w-full flex flex-col pb-12 gap-4" onSubmit={handleSubmit(onSubmit)}>
            <InputForm
              register={register}
              id="email"
              errors={errors}
              title="Nhập email của bạn"
              type="email"
              validate={{
                required: "Không được bỏ trống.",
                pattern: {
                  value: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/,
                  message: "Email không hợp lệ.",
                },
              }}
            />
            <Button onClick={handleSubmit(onSubmit)} className="w-full mt-4 mb-3" disabled={isLoading}>
              {isLoading ? "Đang gửi..." : "Gửi yêu cầu khôi phục mật khẩu"}
            </Button>
            <span
              className="text-sm text-[#007370] cursor-pointer"
              onClick={() => navigate("/dang-nhap")}
            >
              Đã có tài khoản? Đi tới đăng nhập
            </span>
          </form>
        </div>
      </div>
    </section>
  )
}

export default ForgotPassword
