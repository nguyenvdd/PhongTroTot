import moment from "moment"
import React, { useEffect } from "react"
import { useForm } from "react-hook-form"
import { createSearchParams, useLocation, useNavigate, useSearchParams } from "react-router-dom"
import { Button } from "~/components/commons"
import { InputForm, InputSelect } from "~/components/inputs"
import { ListTimPhong } from "~/components/posts"
import { BoxFilter } from "~/components/searchs"
import { useAppStore, usePostStore } from "~/store"

const TimPhong = () => {
  const location = useLocation()
  const { catalogs } = useAppStore()
  const {
    register,
    formState: { errors },
    handleSubmit,
    reset,
    watch,
  } = useForm()
  const sort = watch("sort")
  const navigate = useNavigate()
  const [seachParams] = useSearchParams()
  const { setIsResetFilter, isResetFilter } = usePostStore()
  useEffect(() => {
    if (isResetFilter) reset()
  }, [isResetFilter])
  useEffect(() => {
    const searchParamsObj = Object.fromEntries([...seachParams])
    if (sort) {
      searchParamsObj.sort = sort
    } else delete searchParamsObj.sort
    navigate({
      pathname: location.pathname,
      search: createSearchParams(searchParamsObj).toString(),
    })
  }, [sort])
  return (
    <main className="w-full bg-white lg:w-main px-4 py-4 mx-auto">
      <h1 className="text-3xl font-semibold mt-6">
        {catalogs?.find((el) => "/" + el.slug === location.pathname)?.text}
      </h1>
      <span className="text-base line-clamp-2 block my-4">
        {catalogs?.find((el) => "/" + el.slug === location.pathname)?.description}
      </span>
      <div className="w-full grid grid-cols-12 mt-4 gap-4">
        <div className="col-span-10 md:col-span-12">
          <ListTimPhong
            tag={location.pathname}
            codeTag={catalogs?.find((el) => "/" + el.slug === location.pathname)?.id}
          />
        </div>
      
      </div>
    </main>
  )
}

export default TimPhong
