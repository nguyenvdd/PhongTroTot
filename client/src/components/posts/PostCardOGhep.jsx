import React, { useState, useRef, useEffect } from "react";
import { formatMoney, renderStar } from "~/utilities/fn";
import { Link } from "react-router-dom";
import pathname from "~/utilities/path";
import slugify from "slugify";
import { twMerge } from "tailwind-merge";
import clsx from "clsx";
import { MdFavoriteBorder, MdFavorite } from "react-icons/md";
import { HiOutlineShare } from "react-icons/hi";
import { FaFacebookF, FaFacebookMessenger } from "react-icons/fa";
import { SiZalo } from "react-icons/si";
import { apiAddToWishlist, apiRemoveFromWishlist } from "~/apis/wishlist";
import { toast } from "react-toastify";

const PostCardOGhep = ({
  images = [],
  title,
  address,
  description = "",
  star = 0,
  rRooms = [],
  rCatalog,
  bgCatalog,
  id,
  rUser,
  isWishlist = false,
  fetchPosts
}) => {
  const [liked, setLiked] = useState(isWishlist);
  const [showShareOptions, setShowShareOptions] = useState(false);
  const shareRef = useRef(null);

  const handleToggleWishlist = async () => {
    try {
      if (liked) {
        await apiRemoveFromWishlist(id);
        toast.info("Đã xóa khỏi danh sách yêu thích.");
      } else {
        await apiAddToWishlist(id);
        toast.success("Đã thêm vào danh sách yêu thích!");
      }
      setLiked(!liked);
      fetchPosts();
    } catch (err) {
      toast.error("Có lỗi xảy ra. Vui lòng thử lại!");
      console.error("Lỗi khi xử lý yêu thích:", err);
    }
  };

  const stripHtml = (html) => {
    const doc = new DOMParser().parseFromString(html, 'text/html');
    return doc.body.textContent || "";
  };

  const handleShare = (platform) => {
    const postUrl = `${window.location.origin}/${pathname.public.DETAIL_POST}/${id}/${slugify(title).toLowerCase()}`;
    const postTitle = title || "Bài đăng hấp dẫn";
    const postAddress = address || "Địa chỉ đang cập nhật...";
    const descriptionText = description ? stripHtml(description) : "";

    const roomsInfo = rRooms
      ?.filter(room => room.position === "Còn trống")
      ?.map(room => `- ${room.title}: ${formatMoney(room.price)} VNĐ`)
      ?.join("\n") || "Chưa có phòng trống.";

    const shareContent = 
`${postTitle}
Địa chỉ: ${postAddress}

🌟 Mô tả:
${descriptionText}

🏠 Danh sách phòng:
${roomsInfo}

Xem chi tiết tại: ${postUrl}`;

    navigator.clipboard.writeText(shareContent)
      .then(() => {
        toast.success("Đã sao chép nội dung! Hãy dán vào khi gửi tin nhắn hoặc đăng bài.");
      })
      .catch(() => {
        toast.error("Không thể sao chép nội dung. Vui lòng thử lại!");
      });

    if (platform === "facebook") {
      window.open("https://www.facebook.com", "_blank");
    } else if (platform === "zalo") {
      window.open("https://chat.zalo.me", "_blank");
    } else if (platform === "messenger") {
      window.open("https://www.messenger.com", "_blank");
    }

    setShowShareOptions(false);
  };

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (shareRef.current && !shareRef.current.contains(event.target)) {
        setShowShareOptions(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  const availableRooms = rRooms.filter((el) => el.position === "Còn trống").length;

  return (
    <div
      className={twMerge(
        clsx(
          "bg-white rounded-lg overflow-hidden shadow-sm border flex flex-col transition-all duration-200 hover:shadow-md relative",
          availableRooms === 0 && "opacity-50 pointer-events-none"
        )
      )}
    >
      {/* Label */}
      <div
        className={twMerge(
          clsx(
            "absolute z-10 m-2 px-3 py-1 rounded text-xs text-white font-semibold",
            bgCatalog || "bg-orange-600"
          )
        )}
      >
        {rCatalog?.value}
      </div>

      {/* Image */}
      <Link
        to={`/${pathname.public.DETAIL_POST}/${id}/${slugify(title).toLowerCase()}`}
        className="relative w-full h-[180px] overflow-hidden"
      >
        <img
          src={images[0]}
          alt={title}
          className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
        />
      </Link>

      {/* Content */}
      <div className="flex flex-col gap-2 p-4">
        <Link
          to={`/${pathname.public.DETAIL_POST}/${id}/${slugify(title).toLowerCase()}`}
          className="text-lg font-semibold text-[#007370] hover:underline line-clamp-2"
        >
          {title}
        </Link>

        <div className="flex items-center gap-1 text-yellow-500 text-sm">
          {renderStar(+star)?.map((el, idx) => (
            <span key={idx}>{el}</span>
          ))}
        </div>

        <span className="text-sm text-gray-600">🚩 {address}</span>

        {availableRooms > 0 ? (
          <span className="text-sm text-gray-800">
            📢 Còn <span className="text-orange-500 font-bold">{availableRooms}</span> phòng trống
          </span>
        ) : (
          <span className="text-sm text-red-600 font-semibold">❌ Đã hết phòng</span>
        )}

        {rRooms?.length > 0 && (
          <span className="text-lg text-orange-600 font-bold">
            {rRooms.length === 1
              ? `${formatMoney(rRooms[0]?.price)}`
              : `${formatMoney(
                  rRooms.map((el) => el.price).reduce((a, b) => Math.min(a, b))
                )} ~ ${formatMoney(
                  rRooms.map((el) => el.price).reduce((a, b) => Math.max(a, b))
                )}`}
            <span className="text-sm font-normal text-gray-500 ml-1">VNĐ</span>
          </span>
        )}

        <div className="flex items-center gap-2 pt-2 mt-auto">
          <img
            src={rUser?.rprofile?.image || "/user.svg"}
            alt="avatar"
            className="w-8 h-8 object-cover rounded-full"
          />
          <span className="text-sm text-gray-700">{rUser?.username}</span>
        </div>
      </div>

      {/* ❤️ Yêu thích */}
      <button
        className="absolute bottom-3 right-3 p-2 bg-white rounded-full shadow hover:bg-red-100 transition"
        title="Yêu thích bài viết"
        onClick={handleToggleWishlist}
      >
        {liked ? (
          <MdFavorite className="text-red-500 w-5 h-5" />
        ) : (
          <MdFavoriteBorder className="text-red-500 w-5 h-5" />
        )}
      </button>

      {/* 📤 Chia sẻ */}
      <div ref={shareRef}>
        <button
          className="absolute bottom-3 right-14 p-2 bg-white rounded-full shadow hover:bg-blue-100 transition"
          title="Chia sẻ bài viết"
          onClick={() => setShowShareOptions(!showShareOptions)}
        >
          <HiOutlineShare className="text-blue-500 w-5 h-5" />
        </button>

        {showShareOptions && (
          <div className="absolute bottom-16 right-10 bg-white rounded-lg shadow-md p-2 flex flex-col gap-2 z-20 animate-fadeIn">
            <button
              onClick={() => handleShare("facebook")}
              className="flex items-center gap-2 text-sm hover:text-blue-600 transition"
            >
              <FaFacebookF /> Facebook
            </button>
            <button
              onClick={() => handleShare("zalo")}
              className="flex items-center gap-2 text-sm hover:text-blue-400 transition"
            >
              <SiZalo /> Zalo
            </button>
            <button
              onClick={() => handleShare("messenger")}
              className="flex items-center gap-2 text-sm hover:text-blue-500 transition"
            >
              <FaFacebookMessenger /> Messenger
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default PostCardOGhep;
