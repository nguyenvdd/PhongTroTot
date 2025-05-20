import React, { useEffect, useState } from "react"
import { useForm } from "react-hook-form"
import { Button } from "~/components/commons"
import { InputForm, InputRadio } from "~/components/inputs"
import { useAppStore, useUserStore } from "~/store"
import { IoMdArrowRoundBack } from "react-icons/io"
import { InputOtp } from "~/components/auth"
import { RecaptchaVerifier, signInWithPhoneNumber } from "firebase/auth"
import { auth } from "~/utilities/firebase.config"
import { toast } from "react-toastify"
import { apiLogin, apiLoginWithGoogle, apiRegister, apiValidatePhoneNumber } from "~/apis/user"
import { useNavigate, useSearchParams } from "react-router-dom"
import { GoogleLogin } from "@react-oauth/google"

const Login = () => {
  const navigate = useNavigate()
  const [varriant, setVarriant] = useState("LOGIN")
  const [isSendSuccessOtp, setIsSendSuccessOtp] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const { roles } = useAppStore()
  const { setDataRegister, setToken } = useUserStore()
  const [searchParams] = useSearchParams()

  const {
    register,
    formState: { errors },
    handleSubmit,
    reset,
    watch,
  } = useForm()

  const roleCode = watch("roleCode")

  useEffect(() => {
    reset()
  }, [varriant])

  const onCaptchVerify = () => {
    if (!window.recaptchaVerifier) {
      window.recaptchaVerifier = new RecaptchaVerifier(auth, "recaptcha-container", {
        size: "invisible",
        callback: () => handleSendOtp(),
        "expired-callback": () => {},
      })
    }
  }

  const handleSendOtp = (phone) => {
    setIsLoading(true)
    onCaptchVerify()
    const appVerifier = window.recaptchaVerifier
    const formatPh = "+84" + phone.slice(1)
    signInWithPhoneNumber(auth, formatPh, appVerifier)
      .then((confirmationResult) => {
        window.confirmationResult = confirmationResult
        setIsLoading(false)
        toast.success("Đã gửi OTP thành công!")
        setIsSendSuccessOtp(true)
      })
      .catch((error) => {
        setIsLoading(false)
        setIsSendSuccessOtp(false)
        if (error.message.includes("reCAPTCHA client element has been removed"))
          toast.info("Vui lòng Reload lại page!")
        else toast.error("Gửi OTP không thành công, hãy thử sĐT khác!")
      })
  }

  const onSubmit = async (data) => {
    if (varriant === "REGISTER") {
      const validatePhoneNumber = await apiValidatePhoneNumber({ phone: data.phone })
      if (validatePhoneNumber.success) {
        const response = await apiRegister(data)
        if (response.success) {
          toast.success(response.mes)
          setVarriant("LOGIN")
        } else toast.error(response.mes)
      } else toast.error(validatePhoneNumber.mes)
    }

    if (varriant === "LOGIN") {
      const response = await apiLogin(data)
      if (response.success) {
        setToken(response.accessToken)
        if (searchParams.get("from")) navigate(searchParams.get("from"))
        else navigate("/")
      } else toast.error(response.mes)
    }
  }

  const handleGoogleLoginSuccess = async (credentialResponse) => {
    try {
      const idToken = credentialResponse.credential

      const response = await apiLoginWithGoogle({ idToken })
      if (response.success) {
        setToken(response.accessToken)
        toast.success("Đăng nhập Google thành công")
        navigate("/")
      } else toast.error(response.mes)
    } catch (error) {
      toast.error("Đăng nhập Google thất bại")
    }
  }

  const toggleVariant = () => {
    reset()
    setVarriant(varriant === "LOGIN" ? "REGISTER" : "LOGIN")
  }

  return (
    <section className="h-screen w-full relative overflow-hidden">
      <img src="/lg-bg.jpg" alt="backgound-login" className="w-full h-full grayscale object-cover" />
      <div id="recaptcha-container"></div>
      <div className="absolute inset-0 p-4 bg-overlay-50 flex items-center justify-center">
        <div className="bg-white w-full sm:w-3/5 lg:w-[30%] py-4 md:px-8 px-4 rounded-md flex flex-col items-center gap-4">
          <h1 className="font-bold text-2xl mt-3">
            {varriant === "LOGIN" ? "Đăng nhập" : "Đăng ký tài khoản"}
          </h1>
          <form className="w-full flex flex-col pb-6 gap-4">
            <InputForm
              register={register}
              id="phone"
              errors={errors}
              title="Số điện thoại"
            />
            <InputForm
              register={register}
              id="password"
              errors={errors}
              title="Mật khẩu"
              type="password"
              validate={{ required: "Không được bỏ trống." }}
            />
            {varriant === "REGISTER" && (
              <>
                <InputForm
                  register={register}
                  id="username"
                  errors={errors}
                  title="Tên của bạn"
                  validate={{ required: "Không được bỏ trống." }}
                />
                <InputRadio
                  register={register}
                  id="roleCode"
                  value={roleCode}
                  errors={errors}
                  title="Vai trò"
                  optionsClassName="grid grid-cols-2 gap-4"
                  validate={{ required: "Không được bỏ trống." }}
                  options={roles
                    ?.filter((el) => el.code !== "ADMIN")
                    ?.map((el) => ({ label: el.value, value: el.code }))}
                />
              </>
            )}
            <Button onClick={handleSubmit(onSubmit)} className="w-full mt-4 mb-2" disabled={isLoading}>
              {varriant === "LOGIN" ? "Đăng nhập" : "Đăng ký"}
            </Button>
            {varriant === "LOGIN" && (
              <GoogleLogin
                onSuccess={handleGoogleLoginSuccess}
                onError={() => toast.error("Đăng nhập Google thất bại")}
                width="100%"
              />
            )}
            {varriant === "LOGIN" && (
              <span className="text-sm text-[#007370]" onClick={() => navigate("/quen-mat-khau")}>
                Quên mật khẩu?
              </span>
            )}
            <span className="text-sm flex gap-2 text-[#007370]">
              <span>{varriant === "LOGIN" ? "Chưa có tài khoản?" : "Đã có tài khoản?"}</span>
              <span onClick={toggleVariant} className="cursor-pointer hover:underline">
                {varriant === "LOGIN" ? "Đi tới đăng ký mới" : "Đi tới đăng nhập"}
              </span>
            </span>
          </form>
        </div>
      </div>
      {isSendSuccessOtp && (
        <div className="absolute inset-0 bg-white flex items-center justify-center md:bg-overlay-70">
          <div className="bg-white w-full md:h-fit md:w-[500px] rounded-md h-full mx-auto p-6">
            <h1 className="text-xl flex items-center gap-3 font-bold">
              <span
                className="cursor-pointer"
                onClick={(e) => {
                  e.stopPropagation()
                  setIsSendSuccessOtp(false)
                }}
              >
                <IoMdArrowRoundBack size={20} />
              </span>
              Nhập mã OTP
            </h1>
            <div className="mt-8">
              <InputOtp
                setIsSendSuccessOtp={setIsSendSuccessOtp}
                setVarriant={setVarriant}
                reset={reset}
                isRegister={true}
              />
            </div>
          </div>
        </div>
      )}
    </section>
  )
}

export default Login
