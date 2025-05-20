import React, { Fragment, useEffect, useState } from "react"
import { Link, createSearchParams, useNavigate } from "react-router-dom"
import { HiMenuAlt3 } from "react-icons/hi"
import { NavPopup } from "."
import { Button } from "../commons"
import pathname from "~/utilities/path"
import { usePostStore, useUserStore } from "~/store"
import { showOptions } from "~/utilities/constant"
import useDebounce from "~/hooks/useDebounce"
import { Modal, Input, message } from "antd" // Import Modal and Input from Ant Design
import { apiChangePassword } from "~/apis/user"

const LogoContainer = () => {
  const navigate = useNavigate()
  const { isResetFilter, setIsResetFilter } = usePostStore()
  const [isShowMenu, setIsShowMenu] = useState(false)
  const [isShowOptions, setIsShowOptions] = useState(false)
  const { current, logout } = useUserStore()
  const [keyword, setKeyword] = useState("")
  const debounceKeyword = useDebounce(keyword, 800)
  const [isModalVisible, setIsModalVisible] = useState(false) // State to control modal visibility
  const [oldPassword, setOldPassword] = useState("") // State for old password
  const [newPassword, setNewPassword] = useState("") // State for new password
  const [confirmPassword, setConfirmPassword] = useState("") // State for confirm password

  useEffect(() => {
    if (debounceKeyword) {
      navigate({
        pathname: `/${pathname.public.FILTER}`,
        search: createSearchParams({ keyword: debounceKeyword }).toString(),
      })
    }
  }, [debounceKeyword])

  useEffect(() => {
    if (isResetFilter) {
      setKeyword("")
      setIsResetFilter(false)
    }
  }, [isResetFilter])

  const handlePasswordChange = async () => {
    if (!oldPassword || !newPassword || !confirmPassword) {
      message.error("Tất cả các trường mật khẩu đều phải được điền đầy đủ.");
      return;
    }

    if (newPassword !== confirmPassword) {
      message.error("Mật khẩu mới và xác nhận mật khẩu không khớp.");
      return;
    }

    try {
      const response = await apiChangePassword({
        currentPassword: oldPassword,
        newPassword: newPassword,
      });
      if (response.success) {
        message.success("Mật khẩu đã được thay đổi thành công!");
        setIsModalVisible(false); // Đóng modal sau khi thay đổi mật khẩu thành công
      } else {
        message.error(response.mes || "Đã xảy ra lỗi khi thay đổi mật khẩu.");
      }
    } catch (error) {
      console.log(error)
      message.error("Có lỗi xảy ra. Vui lòng thử lại sau.");
    }
  };

  return (
    <div className="w-full max-w-main px-4 py-8 mx-auto gap-4 flex items-center justify-between">
      {isShowMenu && (
        <div
          onClick={() => setIsShowMenu(false)}
          className="absolute inset-0 z-50 bg-overlay-70 flex justify-end"
        >
          <div onClick={(e) => e.stopPropagation()} className="bg-white w-4/5 animate-slide-right">
            <NavPopup setIsShowMenu={setIsShowMenu} />
          </div>
        </div>
      )}
      <Link className="flex-none w-[35%] md:w-[140px]" to="/">
        <img src="/logo.png" alt="logo" className="w-full object-contain" />
      </Link>
      <div className="flex-auto max-w-[600px]">
        <input
          type="text"
          value={keyword}
          onChange={(e) => setKeyword(e.target.value)}
          placeholder="Tìm kiếm phòng trọ..."
          className="px-4 py-2 border-[#007370] placeholder:text-sm placeholder:text-gray-400 border w-full rounded-l-full rounded-r-full"
        />
      </div>
      <div onClick={() => setIsShowMenu(true)} className="cursor-pointer md:hidden text-[#007370]">
        <HiMenuAlt3 size={30} />
      </div>
      <div className="hidden justify-center items-center gap-3 md:flex">
        {!current && (
          <Button
            onClick={() => navigate(`/${pathname.public.LOGIN}`)}
            className="bg-transparent border border-[#007370] text-[#007370]"
          >
            Đăng nhập / Đăng ký
          </Button>
        )}
        {current && (
          <div
            onClick={() => setIsShowOptions((prev) => !prev)}
            className="flex items-center gap-2 mx-4 cursor-pointer relative"
          >
            {isShowOptions && current && (
              <div className="absolute flex flex-col right-0 top-full py-2 bg-white rounded-md border drop-shadow-sm">
                {showOptions.map((el) => (
                  <Fragment key={el.id}>
                    {current.rroles?.some((item) => item.roleCode === el.code) && (
                      <Link className="px-4 py-2 hover:bg-gray-100" to={el.path}>
                        {el.name}
                      </Link>
                    )}
                  </Fragment>
                ))}
                {current?.rroles?.some((el) => el.roleCode === "MANAGER") && (
                  <Link
                    className="px-4 py-2 hover:bg-gray-100"
                    to={`/${pathname.manager.LAYOUT}/${pathname.manager.CREATE_POST}`}
                  >
                    Đăng tin mới
                  </Link>
                )}
                {current?.rroles?.some((el) => el.roleCode === "USER") && (
                  <Link
                    className="px-4 py-2 hover:bg-gray-100"
                    to={`/${pathname.user.LAYOUT}/${pathname.user.CREATE_POST}`}
                  >
                    tìm người ở ghép
                  </Link>
                )}
                <Link className="px-4 py-2 hover:bg-gray-100" to={"/yeu-thich"}>
                  Bài viết yêu thích
                </Link>
                <button onClick={() => setIsModalVisible(true)} className="px-4 py-2 hover:bg-gray-100 w-full text-left">
                  Đổi mật khẩu
                </button>
                <span className="px-4 py-2 hover:bg-gray-100 cursor-pointer" onClick={() => logout()}>
                  Đăng xuất
                </span>
              </div>
            )}
            <img
              src={current?.rprofile?.image || "/user.svg"}
              alt="user-avatar"
              className="w-12 h-12 object-cover rounded-full"
            />
            <div className="flex flex-col">
              <span>
                Xin chào, <span>{current.username}</span>
              </span>
              <span>
                ID: <span>#{current?.id}</span>
              </span>
            </div>
          </div>
        )}
      </div>

      {/* Modal for password change */}
      <Modal
        title="Đổi mật khẩu"
        visible={isModalVisible}
        onOk={handlePasswordChange}
        onCancel={() => setIsModalVisible(false)}
        okText="Lưu"
        cancelText="Hủy"
        okButtonProps={{
          style: {
            backgroundColor: '#007370', // Màu nền nút Lưu
            borderColor: '#007370',
            color: '#fff' // Màu chữ nút Lưu
          },
        }}
        cancelButtonProps={{
          style: {
            backgroundColor: '#f0f0f0', // Màu nền nút Hủy
            borderColor: '#f0f0f0',
            color: '#000' // Màu chữ nút Hủy
          },
        }}
        bodyStyle={{ backgroundColor: '#f4f4f4', padding: '20px', borderRadius: '8px' }} // Màu nền modal và padding
        titleStyle={{ color: '#007370' }} // Màu tiêu đề modal
      >
        <div className="space-y-4">
          <Input.Password
            value={oldPassword}
            onChange={(e) => setOldPassword(e.target.value)}
            placeholder="Nhập mật khẩu cũ"
            style={{ height: 40 }}
          />
          <Input.Password
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            placeholder="Nhập mật khẩu mới"
            style={{ height: 40 }}
          />
          <Input.Password
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            placeholder="Xác nhận mật khẩu mới"
            style={{ height: 40 }}
          />
        </div>
      </Modal>
    </div>
  )
}

export default LogoContainer
