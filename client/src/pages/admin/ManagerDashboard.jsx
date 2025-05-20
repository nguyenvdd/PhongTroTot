import React, { useEffect, useState } from "react";
import { apiGetUsersManager } from "~/apis/app";
import { useForm } from "react-hook-form";
import { InputForm } from "~/components/inputs";
import useDebounce from "~/hooks/useDebounce";
import { useSearchParams } from "react-router-dom";
import { Pagiantion } from "~/components/paginations";
import moment from "moment";
import DialogStatistics from "./DialogStatistics";

const ManagerDashboard = () => {
  const { register, formState: { errors }, watch, setValue } = useForm();
  const [searchParams] = useSearchParams();
  const [users, setUsers] = useState();
  const [showDialog, setShowDialog] = useState(false);
  const [selectedContract, setSelectedContract] = useState(null);

  const sort = watch("sort");
  const keyword = watch("keyword");

  const fetchUsers = async (paramsUser) => {
    const response = await apiGetUsersManager({
      limit: import.meta.env.VITE_LIMIT_POSTS,
      isDeleted: false,
      ...paramsUser,
    });
    if (response.success) setUsers(response.users);
  };

  const debounceKeyword = useDebounce(keyword, 800);

  useEffect(() => {
    const paramsUser = Object.fromEntries([...searchParams]);
    if (sort) paramsUser.sort = sort;
    if (debounceKeyword) paramsUser.keyword = debounceKeyword;
    fetchUsers(paramsUser);
  }, [searchParams, sort, debounceKeyword]);

  const handleRowClick = (user) => {
    setSelectedContract(user);
    setShowDialog(true);
  };

  return (
    <div className="w-full h-full">
      <div className="flex justify-between py-4 lg:border-b px-4 items-center">
        <h1 className="text-3xl font-bold">Thống kê chủ trọ</h1>
      </div>
      <div className="p-4 w-full">
        <div className="my-4">
          <div className="flex md:justify-between gap-4 items-center">
            <InputForm
              id="keyword"
              register={register}
              errors={errors}
              placeholder="Username, tên, ..."
              containerClassName="w-fit"
              inputClassName="px-8 focus:px-4"
            />
          </div>
        </div>

        <div className="my-4 w-full overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr>
                <th className="border p-3 text-center">ID</th>
                <th className="border p-3 text-center">Username</th>
                <th className="border p-3 text-center">Số điện thoại</th>
                <th className="border p-3 text-center">Ngày đăng ký</th>
              </tr>
            </thead>
            <tbody>
              {users?.rows?.map(el => (
                <tr key={el.id} onClick={() => handleRowClick(el)} className="cursor-pointer hover:bg-gray-100">
                  <td className="border p-3 text-center">{el.id}</td>
                  <td className="border p-3 text-center">{el.username}</td>
                  <td className="border p-3 text-center">{el.phone}</td>
                  <td className="border p-3 text-center">{moment(el.createdAt).format("DD/MM/YY")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="my-4">
          <Pagiantion totalCount={users?.count} limit={+import.meta.env.VITE_LIMIT_POSTS} />
        </div>
      </div>
      {showDialog && selectedContract && (
        <DialogStatistics
          user={selectedContract}
          onClose={() => {
            setShowDialog(false);
            setSelectedContract(null);
          }}
        />
      )}
    </div>
  );
};

export default ManagerDashboard;
