import { useEffect, useRef, useState } from "react";
import { FaComments } from "react-icons/fa";
import { HomeSection } from "~/components/posts";
import { useAppStore } from "~/store";
import { apiSuggestPost } from "~/apis/post";
import { Link } from "react-router-dom";
import pathname from "~/utilities/path";
import slugify from "slugify";

const Home = () => {
  const { catalogs } = useAppStore();
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [messages, setMessages] = useState([]);
  const [userMessage, setUserMessage] = useState("");
  const [suggestedPosts, setSuggestedPosts] = useState([]);
  const inputRef = useRef(null);

  // Trigger re-render for animation when messages change
  const [animateIndex, setAnimateIndex] = useState(-1);

  const handleSendMessage = async () => {
    if (userMessage.trim()) {
      const newMessage = { sender: "user", text: userMessage };
      setMessages((prev) => [...prev, newMessage]);
      setUserMessage("");
      setSuggestedPosts([]);

      try {
        const res = await apiSuggestPost({ message: userMessage });
        const aiMessage = res?.suggestion || "Không có gợi ý phù hợp.";
        const botMessage = { sender: "bot", text: aiMessage };
        setMessages((prev) => [...prev, botMessage]);
        setSuggestedPosts(res?.suggestedPosts || []);
      } catch (error) {
        console.error("Lỗi khi gọi API gợi ý:", error);
        setMessages((prev) => [
          ...prev,
          { sender: "bot", text: "Đã có lỗi xảy ra. Vui lòng thử lại!" },
        ]);
      }
    }
  };

  useEffect(() => {
    if (isChatOpen && inputRef.current) inputRef.current.focus();

    // Gửi lời chào khi chat mở và chưa có tin nhắn
    if (isChatOpen && messages.length === 0) {
      setMessages([
        {
          sender: "bot",
          text: "👋 Chào bạn! Mình có thể giúp gì hôm nay? ",
        },
      ]);
    }
  }, [isChatOpen]);

  // Khi có tin nhắn mới, cập nhật animateIndex để trigger animation
  useEffect(() => {
    if (messages.length > 0) {
      setAnimateIndex(messages.length - 1);
    }
  }, [messages]);

  const convertMarkdownToHTML = (markdown) => {
    let html = markdown.replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>");
    html = html.replace(/__(.*?)__/g, "<strong>$1</strong>");
    html = html.replace(/\*(.*?)\*/g, "<em>$1</em>");
    html = html.replace(/_(.*?)_/g, "<em>$1</em>");
    html = html.replace(
      /\[(.*?)\]\((.*?)\)/g,
      '<a href="$2" class="text-blue-500 underline" target="_blank" rel="noopener noreferrer">$1</a>'
    );
    html = html.replace(/^- (.*)$/gm, "<li>• $1</li>");
    html = html.replace(/\n/g, "<br />");
    return html;
  };

  return (
    <main className="w-full bg-white lg:w-main px-4 py-6 mx-auto">
      <h1 className="text-3xl font-extrabold mt-4 tracking-wide text-gray-800">
        {catalogs?.find((el) => el.slug === "trang-chu")?.text}
      </h1>
      <p className="text-base line-clamp-2 my-4 text-gray-600">
        {catalogs?.find((el) => el.slug === "trang-chu")?.description}
      </p>
      <HomeSection filters={{ sort: "-star" }} title="Tin đăng nổi bật" />
      <HomeSection filters={{ sort: "-createdAt" }} title="Tin đăng mới nhất" />

      {/* Nút mở chatbot */}
      <div
        onClick={() => setIsChatOpen(!isChatOpen)}
        className="fixed bottom-10 right-10 bg-blue-600 text-white p-4 rounded-full cursor-pointer shadow-2xl hover:bg-blue-700 transition-transform transform hover:scale-110 active:scale-95 z-50"
        title={isChatOpen ? "Đóng Chat" : "Mở Chat"}
      >
        <FaComments size={26} />
      </div>

      {/* Chat Box */}
      {isChatOpen && (
        <div className="fixed bottom-16 right-10 w-[500px] h-[600px] bg-white shadow-2xl rounded-xl p-5 border border-gray-300 z-50 flex flex-col">
          {/* Header */}
          <div className="flex items-center justify-between mb-4 border-b border-gray-200 pb-3">
            <div className="flex items-center">
              <img
                src="https://i.pinimg.com/originals/21/a1/aa/21a1aa2537400d0232efd93e108fd953.gif"
                alt="StayAI Chat"
                className="w-14 h-14 rounded-full mr-4"
              />
              <span className="text-2xl font-semibold text-gray-800 tracking-wide">
                StayAI Chat
              </span>
            </div>
            <button
              onClick={() => setIsChatOpen(false)}
              className="text-gray-500 hover:text-gray-700 focus:outline-none text-3xl font-extrabold transition-colors"
              aria-label="Đóng chat"
              type="button"
            >
              &times;
            </button>
          </div>

          {/* Tin nhắn */}
          <div
            className="flex-1 overflow-y-auto pr-2 space-y-4 scrollbar-thin scrollbar-thumb-blue-400 scrollbar-track-gray-100"
            style={{ scrollbarWidth: "thin" }}
          >
            {messages.map((msg, index) => (
              <div
                key={index}
                className={`text-sm max-w-[80%] px-5 py-3 rounded-2xl shadow-md break-words
                  ${
                    msg.sender === "user"
                      ? "ml-auto bg-blue-600 text-white"
                      : "mr-auto bg-gray-100 text-gray-800"
                  }
                  ${
                    animateIndex === index
                      ? "opacity-0 translate-y-4 animate-fadeSlideIn"
                      : ""
                  }
                `}
                onAnimationEnd={() => {
                  if (animateIndex === index) setAnimateIndex(-1);
                }}
                dangerouslySetInnerHTML={{ __html: convertMarkdownToHTML(msg.text) }}
              />
            ))}

            {/* Gợi ý bài đăng */}
            {suggestedPosts.length > 0 && (
              <div className="mt-6 space-y-4">
                {suggestedPosts.map((post) => (
                  <div
                    key={post.id}
                    className="border border-gray-300 rounded-lg p-4 bg-gray-50 hover:shadow-lg transition-shadow cursor-pointer"
                  >
                    <Link
                      to={`/${pathname.public.DETAIL_POST}/${post.id}/${slugify(
                        post.title
                      ).toLowerCase()}`}
                      className="font-semibold text-lg text-[#007370] hover:underline line-clamp-2"
                    >
                      {post.title}
                    </Link>
                    <p className="text-sm text-gray-500 mt-1">{post.address}</p>
                    <p className="text-sm text-gray-700 mt-1">
                      <strong>Giá:</strong>{" "}
                      {post.rRooms.map((r) => r.price).join(", ")} VND
                    </p>
                    <p className="text-sm text-yellow-500 mt-1">
                      ⭐ {post.star || "Chưa có"}
                    </p>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Input */}
          <div className="flex items-center pt-4 mt-auto border-t border-gray-200">
            <input
              ref={inputRef}
              type="text"
              value={userMessage}
              onChange={(e) => setUserMessage(e.target.value)}
              className="flex-1 p-3 border border-gray-300 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500 placeholder-gray-400"
              placeholder="Nhập tin nhắn..."
              onKeyDown={(e) => e.key === "Enter" && handleSendMessage()}
            />
            <button
              onClick={handleSendMessage}
              className="ml-3 px-5 py-3 bg-blue-600 text-white rounded-full hover:bg-blue-700 transition"
            >
              Gửi
            </button>
          </div>

          {/* Style animation */}
          <style>{`
            @keyframes fadeSlideIn {
              0% {
                opacity: 0;
                transform: translateY(16px);
              }
              100% {
                opacity: 1;
                transform: translateY(0);
              }
            }
            .animate-fadeSlideIn {
              animation: fadeSlideIn 0.3s ease forwards;
            }

            /* Scrollbar thin for chat */
            .scrollbar-thin::-webkit-scrollbar {
              width: 6px;
            }
            .scrollbar-thin::-webkit-scrollbar-track {
              background: #f0f0f0;
              border-radius: 10px;
            }
            .scrollbar-thin::-webkit-scrollbar-thumb {
              background-color: #3b82f6;
              border-radius: 10px;
            }
          `}</style>
        </div>
      )}
    </main>
  );
};

export default Home;
