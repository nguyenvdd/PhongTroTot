import React from "react"

const RelatedPosts = ({ children, title }) => {
  return (
    <div className="border border-[#007370] rounded-md">
      <h2 className="w-full py-4 px-4 font-bold uppercase text-center bg-[#007370] text-white rounded-t-md">
        {title}
      </h2>
      {children}
    </div>
  )
}

export default RelatedPosts
