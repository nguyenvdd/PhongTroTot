import React, { useEffect, useState } from "react";
import { apiGetPosts, apiGetPostWishlist } from "~/apis/post";
import { PostCard } from ".";
import { Pagiantion } from "../paginations";
import { useAppStore } from "~/store";
import { useLocation, useSearchParams } from "react-router-dom";

const LIMIT = 6;

const List = ({ filters = {}, isHidePagination, tag, codeTag }) => {
  const [posts, setPosts] = useState();
  const { catalogs } = useAppStore();
  const [searchParams] = useSearchParams();
  const location = useLocation();
  const userId = JSON.parse(localStorage.getItem("phongtro"))?.state?.current?.id;
  const fetchPosts = async (params) => {
    const response = await apiGetPostWishlist({
      limit: LIMIT,
      userId,
      ...params,
    });

    if (response.success) setPosts(response.posts);
  };

  useEffect(() => {
    const searchParamsObj = Object.fromEntries([...searchParams]);

    // Price filter formatting (FE sends price as "min,max" or just "min")
    if (searchParamsObj["gia-tu"] && !searchParamsObj["gia-den"]) {
      searchParamsObj.price = `${searchParamsObj["gia-tu"]}`;
    } else if (searchParamsObj["gia-den"] && !searchParamsObj["gia-tu"]) {
      searchParamsObj.price = `0,${searchParamsObj["gia-den"]}`;
    } else if (searchParamsObj["gia-tu"] && searchParamsObj["gia-den"]) {
      searchParamsObj.price = `${searchParamsObj["gia-tu"]},${searchParamsObj["gia-den"]}`;
    }

    delete searchParamsObj["gia-tu"];
    delete searchParamsObj["gia-den"];

    // Area filter formatting (same logic as price)
    if (searchParamsObj["dien-tich-tu"] && !searchParamsObj["dien-tich-den"]) {
      searchParamsObj.area = `${searchParamsObj["dien-tich-tu"]}`;
    } else if (searchParamsObj["dien-tich-den"] && !searchParamsObj["dien-tich-tu"]) {
      searchParamsObj.area = `0,${searchParamsObj["dien-tich-den"]}`;
    } else if (searchParamsObj["dien-tich-tu"] && searchParamsObj["dien-tich-den"]) {
      searchParamsObj.area = `${searchParamsObj["dien-tich-tu"]},${searchParamsObj["dien-tich-den"]}`;
    }

    delete searchParamsObj["dien-tich-tu"];
    delete searchParamsObj["dien-tich-den"];

    fetchPosts(searchParamsObj);
  }, [searchParams]);

  return (
    <div className="w-full">
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {posts?.rows?.map((el) => (
          <PostCard
            key={el.id}
            {...el}
            bgCatalog={catalogs?.find((ctg) => ctg.id === el.rCatalog?.id)?.bg}
            fetchPosts={fetchPosts}
          />
        ))}
      </div>
      {!isHidePagination && (
        <Pagiantion totalCount={posts?.count} limit={LIMIT} />
      )}
    </div>
  );
};

export default List;
