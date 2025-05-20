import moment from "moment"
import React, { useEffect, useState } from "react"
import { useForm } from "react-hook-form"
import { RiDeleteBin6Line } from "react-icons/ri"
import { Link, useSearchParams, useNavigate } from "react-router-dom"
import { toast } from "react-toastify"
import Swal from "sweetalert2"
import { apiGetContracts, apiRemoveContract, apiGetAdminContracts } from "~/apis/contract"
import { InputForm, InputSelect } from "~/components/inputs"
import { Pagiantion } from "~/components/paginations"
import useDebounce from "~/hooks/useDebounce"
import { usePostStore, useUserStore } from "~/store"
import { formatMoney } from "~/utilities/fn"
import pathname from "~/utilities/path"
import clsx from "clsx"
import { twMerge } from "tailwind-merge"
import { FaEdit, FaRegEye } from "react-icons/fa"
import ApproveContractDialog from '../../components/contract/ApproveContractDialog';

const ManageContract = () => {
  const { setContractData } = usePostStore()
  const { current } = useUserStore()
  const isAdmin = current?.rroles?.some((el) => el.roleCode === "ADMIN")
  const pathRole = isAdmin ? pathname.admin : pathname.manager

  const navigate = useNavigate()
  const {
    register,
    formState: { errors },
    watch,
  } = useForm()

  const sort = watch("sort")
  const keyword = watch("keyword")
  const [contracts, setContracts] = useState()
  const [update, setUpdate] = useState(false)
  const [searchParams] = useSearchParams()
  const [showDialog, setShowDialog] = useState(false)
  const [selectedContract, setSelectedContract] = useState(null)

  const openDialog = (contract) => {
    setSelectedContract(contract)
    setShowDialog(true)
  }

  const fetchContracts = async (params) => {
    let response

    if (isAdmin) {
      response = await apiGetAdminContracts({
        limit: import.meta.env.VITE_LIMIT_CONTRACTS,
        postedBy: current?.id,
        ...params,
      })
    } else {
      response = await apiGetContracts({
        limit: import.meta.env.VITE_LIMIT_CONTRACTS,
        postedBy: current?.id,
        ...params,
      })
    }
    if (response.success) setContracts(response.contracts)
  }

  const debounceKeyword = useDebounce(keyword, 800)

  useEffect(() => {
    const params = Object.fromEntries([...searchParams])
    if (sort) params.sort = sort
    if (debounceKeyword) params.keyword = debounceKeyword
    fetchContracts(params)
  }, [update, debounceKeyword, searchParams])

  const handleDeleteContract = (id) => {
    Swal.fire({
      title: "Xác nhận",
      icon: "warning",
      text: "Bạn chắc chắn muốn xóa?",
      showConfirmButton: true,
      showCancelButton: true,
      confirmButtonText: "Xóa",
      cancelButtonText: "Hủy",
    }).then(async (rs) => {
      if (rs.isConfirmed) {
        const response = await apiRemoveContract(id)
        if (response.success) {
          toast.success(response.mes)
          setUpdate(!update)
        } else toast.error(response.mes)
      }
    })
  }

  const handleViewContract = (contract) => {
    const data = {
      bphone: contract?.rUser?.phone,
      bName: contract?.rUser?.rprofile?.lastName + " " + contract?.rUser?.rprofile?.firstName,
      bcccd: contract?.rUser?.rprofile?.CID || "",
      bcccddate: "....................",
      bcccdaddress: "...................",
      bAddress: contract?.rUser?.rprofile?.address || "",
      bBirthday: moment(contract?.rUser?.rprofile?.birthday).format("YYYY-MM-DD") || "",
      houseaddress: contract?.rRoom?.title,
      price: formatMoney(contract?.rPayments[0]?.total),
      start: moment(contract?.createAt).format("YYYY-MM-DD"),
      end: moment(contract?.createdAt).format("YYYY-MM-DD"),
      currentday: moment(contract?.createdAt).date().toString().padStart(2, '0'),
      currentmonth: (moment(contract?.createdAt).month() + 1).toString().padStart(2, '0'),
      currentyear: moment(contract?.createdAt).year().toString(),
    }
    setContractData(data)
    navigate(`/${pathname.user.CONTRACT}`)
  }

  return (
    <div className="w-full h-full">
      <div className="py-4 lg:border-b flex items-center justify-between flex-wrap gap-4 px-4 w-full">
        <h1 className="text-3xl font-bold">Quản lý hợp đồng</h1>
        <div className="flex gap-4 items-center">
          <Link
            className="text-white bg-[#007370] px-4 py-2 rounded-md flex justify-center items-center"
            to={`/${pathRole.LAYOUT}/${pathRole.CREATE_CONTRACT}`}
          >
            Tạo mới
          </Link>
        </div>
      </div>
      <div className="p-4">
        <p className="p-3 text-sm text-center italic rounded-md border border-[#007370] bg-blue-100 text-[#007370]">
          NOTE: Xem trên PC hoặc Laptop để đầy đủ hơn
        </p>
      </div>
      <div className="my-4 px-4">
        <div className="flex md:justify-between gap-4 items-center">
          <div className="flex items-center gap-4">
            <InputSelect
              defaultText="Sắp xếp"
              register={register}
              id="sort"
              errors={errors}
              options={[
                { label: "Mới nhất", value: "-createdAt" },
                { label: "Lâu nhất", value: "createdAt" },
                { label: "Chỉnh sửa gần nhất", value: "-updatedAt" },
                { label: "Từ A tới Z", value: "title" },
                { label: "Từ Z tới A", value: "-title" },
              ]}
              containerClassName="w-fit"
            />
            <InputForm
              id="keyword"
              register={register}
              errors={errors}
              placeholder="Tìm kiếm theo tựa đề, địa chỉ"
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
              <th className="border p-3 text-center">ID</th>
              <th className="border p-3 text-center">Phòng</th>
              <th className="border p-3 text-center">Người thuê</th>
              <th className="border hidden md:table-cell p-3 text-center">Tiền đặt cọc</th>
              <th className="border p-3 text-center">Hết hạn</th>
              <th className="border hidden lg:table-cell p-3 text-center">Số người ở</th>
              <th className="border hidden lg:table-cell p-3 text-center">Ghi chú</th>
              <th className="border p-3 text-center">Trạng thái</th>
              <th className="border p-3 text-white bg-[#007370] text-center">Thao tác</th>
            </tr>
          </thead>
          <tbody>
            {contracts?.rows?.map((el) => (
              <tr key={el.id}>
                <td className="border p-3 text-center">{el.id}</td>
                <td className="border p-3 text-center">
                  <span className="line-clamp-2">{el.rRoom?.title}</span>
                </td>
                <td className="border p-3 text-center">{el.rUser?.phone}</td>
                <td className="border hidden md:table-cell p-3 text-center">{formatMoney(el.preMoney)}</td>
                <td className="border p-3 text-center">{moment(el.expiredAt).format("DD/MM/YY")}</td>
                <td className="border p-3 hidden lg:table-cell text-center">{el.stayNumber}</td>
                <td className="border hidden lg:table-cell p-3 text-center">
                  <span className="line-clamp-2">{el.notes}</span>
                </td>
                <td className={twMerge(clsx("border p-3 text-center", el.rRoom?.position === "Đang xử lý" && "text-orange-600"))}>
                  {el.rRoom?.position}
                </td>
                <td className="border p-3 text-center">
                  <span className="flex items-center text-gray-500 gap-4 justify-center">
                    {el.rRoom?.position === "Đang xử lý" && (
                      <span
                        key={el.id}
                        title="Cập nhật trạng thái"
                        className="cursor-pointer hover:text-[#007370]"
                        onClick={() => openDialog(el)}
                      >
                        <FaEdit size={18} />
                      </span>
                    )}
                    <span
                      title="Xem hợp đồng"
                      onClick={() => handleViewContract(el)}
                      className="text-[#007370] hover:underline cursor-pointer text-center"
                    >
                      <FaRegEye size={18} />
                    </span>
                    <span
                      title="Xóa"
                      className="cursor-pointer hover:text-[#007370]"
                      onClick={() => handleDeleteContract(el.id)}
                    >
                      <RiDeleteBin6Line size={18} />
                    </span>
                    {showDialog && selectedContract && (
                      <ApproveContractDialog
                        contract={selectedContract}
                        onClose={() => {
                          setShowDialog(false)
                          setSelectedContract(null)
                        }}
                        onApprove={fetchContracts}
                      />
                    )}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="my-4">
        <Pagiantion totalCount={contracts?.count} limit={+import.meta.env.VITE_LIMIT_CONTRACTS} />
      </div>
    </div>
  )
}

export default ManageContract
