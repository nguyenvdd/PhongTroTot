import moment from "moment";
import React, { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { RiDeleteBin6Line } from "react-icons/ri";
import {
  apiCreateRoom,
  apiDeleteRoom,
  apiGetRooms,
  apiGetAdminRooms,
} from "~/apis/room";
import { useAppStore, useUserStore } from "~/store";
import { FaRegEye, FaFileAlt } from "react-icons/fa";
import { twMerge } from "tailwind-merge";
import clsx from "clsx";
import { DetailRoom } from "~/components/rooms";
import { toast } from "react-toastify";
import { GiNotebook } from "react-icons/gi";
import { Pagiantion } from "~/components/paginations";
import { UpdateIndex } from "~/components/manager";
import { useSearchParams } from "react-router-dom";
import { InputForm, InputSelect } from "~/components/inputs";
import useDebounce from "~/hooks/useDebounce";
import { Button } from "~/components/commons";
import { CreateRoom } from "~/components/posts";
import DialogStatisticsRoom from "./DialogStatisticsRoom";
import Swal from "sweetalert2";

const ManageRoom = () => {
  const { current } = useUserStore();
  const { setModal, isShowModal } = useAppStore();
  const [searchParams] = useSearchParams();
  const {
    register,
    formState: { errors },
    watch,
  } = useForm();
  const sort = watch("sort");
  const keyword = watch("keyword");
  const [rooms, setRooms] = useState();
  const [update, setUpdate] = useState(false);
  const [showDialog, setShowDialog] = useState(false);
  const [selectedRoom, setselectedRoom] = useState(null);

  const fetchRooms = async (params) => {
    let response;
    if (current.rroles.some((el) => el.roleCode === "ADMIN")) {
      response = await apiGetAdminRooms({
        limit: import.meta.env.VITE_LIMIT_POSTS,
        ...params,
      });
    } else {
      response = await apiGetRooms({
        limit: import.meta.env.VITE_LIMIT_POSTS,
        postedBy: current?.id,
        ...params,
      });
    }
    if (response.success) setRooms(response.rooms);
  };
  const debounceKeyword = useDebounce(keyword, 800);
  useEffect(() => {
    const params = Object.fromEntries([...searchParams]);
    if (sort) params.sort = sort;
    if (debounceKeyword) params.keyword = debounceKeyword;
    !isShowModal && fetchRooms(params);
  }, [isShowModal, update, searchParams, debounceKeyword, sort]);
  const handleRemoveRoom = async (id) => {
    Swal.fire({
      icon: "warning",
      title: "Xác nhận",
      text: "Bạn chắc chắn muốn xóa?",
      showCancelButton: true,
      showConfirmButton: true,
      confirmButtonText: "Xóa",
      cancelButtonText: "Hủy",
    }).then(async (rs) => {
      if (rs.isConfirmed) {
        const response = await apiDeleteRoom(id);
        if (response.success) {
          toast.success(response.mes);
          setUpdate(!update);
        } else toast.error(response.mes);
      }
    });
  };
  const handleAddRoom = async (room) => {
    const response = await apiCreateRoom(room);
    if (response.success) {
      toast.success(response.mes);
      setUpdate(!update);
    } else toast.error(response.mes);
  };
  const handleRowClick = (user) => {
    setselectedRoom(user);
    setShowDialog(true);
  };
  return (
    <div className="w-full h-full">
      <div className="py-4 lg:border-b flex items-center justify-between px-4 w-full">
        <h1 className="text-3xl font-bold">Quản lý phòng trọ</h1>
        <Button
          onClick={() =>
            setModal(
              true,
              <CreateRoom single pushRoom={(data) => handleAddRoom(data)} />
            )
          }
          className="py-2 px-4 bg-[#007370] text-white flex justify-center items-center rounded-md"
        >
          Tạo mới
        </Button>
      </div>
      <div className="p-4 lg:hidden w-fit mx-auto px-6">
        <p className="p-3 text-sm text-center italic rounded-md border border-[#007370] bg-blue-100 text-[#007370]">
          NOTE: Xem trên PC hoặc Laptop để đầy đủ hơn
        </p>
      </div>
      <div className="mt-4 p-4">
        <div className="flex md:justify-between gap-4 items-center">
          <div className="flex items-center gap-4">
            <InputSelect
              defaultText="Sắp xếp"
              register={register}
              id="sort"
              errors={errors}
              options={[
                { label: "Mới nhất", value: "-updatedAt" },
                { label: "Lâu nhất", value: "updatedAt" },
                // { label: "Chỉnh sửa gần nhất", value: "-updatedAt" },
                { label: "Từ A tới Z", value: "title" },
                { label: "Từ Z tới A", value: "-title" },
              ]}
              containerClassName="w-fit"
            />
            <InputForm
              id="keyword"
              register={register}
              errors={errors}
              placeholder="Tìm kiếm theo tựa đề"
              containerClassName="w-fit"
              inputClassName="px-8 focus:px-4"
            />
          </div>
          <span className="text-sm hidden md:block">
            Cập nhật <span>{moment().format("DD/MM/YYYY HH:mm:ss")}</span>
          </span>
        </div>
      </div>
      <div className="p-4 w-full">
        <table className="max-w-full w-full overflow-x-auto">
          <thead>
            <tr>
              <th className="border p-3 text-center">Số phòng</th>
              <th className="border p-3 text-center">Tựa đề</th>
              <th className="border p-3 text-center">Trạng thái</th>
              <th className="border p-3 text-white bg-[#007370] text-center">
                Hành động
              </th>
            </tr>
          </thead>
          <tbody>
            {rooms?.rows?.map((el) => (
              <tr key={el.id}>
                <td className="border p-3 text-center">{el.id}</td>
                <td className="border p-3 text-center">{el.title}</td>
                <td
                  className={twMerge(
                    clsx(
                      "border p-3 text-center",
                      el.position === "Đang xử lý" && "text-orange-600"
                    )
                  )}
                >
                  {el.position}
                </td>
                <td className="border p-3 text-center">
                  <span className="flex items-center text-gray-500 gap-4 justify-center">
                    <span
                      title="Báo cáo doanh thu"
                      className="cursor-pointer hover:text-[#007370]"
                      onClick={() => handleRowClick(el)}
                    >
                      <FaFileAlt size={18} />
                    </span>
                    <span
                      title="Xem chi tiết"
                      className="cursor-pointer hover:text-[#007370]"
                      onClick={() => setModal(true, <DetailRoom room={el} />)}
                    >
                      <FaRegEye size={18} />
                    </span>

                    <span
                      title="Xóa"
                      className="cursor-pointer hover:text-[#007370]"
                      onClick={() => handleRemoveRoom(el.id)}
                    >
                      <RiDeleteBin6Line size={18} />
                    </span>

                    {el.position === "Đã thuê" && (
                      <span
                        title="Cập nhật chỉ số"
                        className="cursor-pointer hover:text-[#007370]"
                        onClick={() =>
                          setModal(true, <UpdateIndex room={el} />)
                        }
                      >
                        <GiNotebook size={18} />
                      </span>
                    )}
                  </span>
                  {showDialog && selectedRoom && (
                    <DialogStatisticsRoom
                      room={selectedRoom}
                      onClose={() => {
                        setShowDialog(false);
                        setselectedRoom(null);
                      }}
                    />
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="my-4">
        <Pagiantion
          totalCount={rooms?.count}
          limit={+import.meta.env.VITE_LIMIT_ROOMS}
        />
      </div>
    </div>
  );
};

export default ManageRoom;
