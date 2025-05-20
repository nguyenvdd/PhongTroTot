const asyncHandler = require("express-async-handler")
const db = require("../models")

module.exports = {
  // createNewPayment: asyncHandler(async (req, res) => {
  //   const response = await Promise.all([
  //     db.Payment.create(req.body),
  //     db.Room.update(
  //       { position: "Đang xử lý" },
  //       { where: { id: req.body.roomId } }
  //     ),
  //     db.Contract.create(data)
  //   ])
  //   return res.json({
  //     success: !!response,
  //     mes: response
  //       ? "Thanh toán thành công. Hãy tải hợp đồng rồi đi gặp chủ trọ để hoàn tất thủ tục"
  //       : "Có lỗi",
  //   })
  // }),

  createNewPayment: asyncHandler(async (req, res) => {
    const { roomId, total, email, fullName, cccd, birthday, address, userId } = req.body;
    const expiredAt = new Date(); 
    expiredAt.setMonth(expiredAt.getMonth() + 1); 
    
    const contractData = {
      userId: userId,
      roomId: roomId,
      preMoney: 0,
      expiredAt: expiredAt,
      notes: `Payment from ${email}`,
      stayNumber: 1
    };

    const nameParts = fullName.trim().split(" ");
    if (nameParts.length > 1) {
      firstName = nameParts.pop(); 
      lastName = nameParts.join(" "); 
    } else {
      firstName = nameParts[0] || ""; 
      lastName = "";
    }

    try {
      const response = await Promise.all([
        db.Payment.create({
          userId, email, roomId, total
        }),
        db.Room.update(
          { position: "Đang xử lý" }, 
          { where: { id: roomId } }
        ),
        db.Contract.create(contractData)
      ]);

      const alreadyUpdateProfile = await db.Profile.findOne({ where: { userId } });
      if (alreadyUpdateProfile) {
        await db.Profile.update(
          { firstName, lastName, CID: cccd, email, address, birthday }, 
          { where: { userId } }
        );
      } else {
        await db.Profile.create({
          firstName, lastName, CID: cccd, email, address, birthday, userId
        });
      }

      return res.json({
        success: !!response,
        mes: response
          ? "Thanh toán thành công. Hãy tải hợp đồng rồi đi gặp chủ trọ để hoàn tất thủ tục"
          : "Có lỗi",
      });
    } catch (error) {
      return res.status(500).json({ success: false, mes: "Có lỗi", error });
    }
  }),
}
