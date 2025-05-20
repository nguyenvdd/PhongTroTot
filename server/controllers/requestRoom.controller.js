const asyncHandler = require("express-async-handler");
const db = require("../models");
const { Op } = require("sequelize");

module.exports = {
  // GET: Lấy tất cả yêu cầu tìm phòng (có phân trang và tìm kiếm)
  getAllRequestRoom: asyncHandler(async (req, res) => {
    const { keyword, isActive = true } = req.query;

    const whereClause = { isActive: true };

    // Tìm kiếm theo location hoặc yêu cầu đặc biệt
    if (keyword) {
      whereClause[Op.or] = [
        {
          location: {
            [Op.iLike]: `%${keyword}%`,
          },
        },
        {
          specialRequirements: {
            [Op.iLike]: `%${keyword}%`,
          },
        },
      ];
    }

    const response = await db.RequestRoom.findAll({
      where: whereClause,
      order: [["createdAt", "DESC"]],
      include: [
        {
          model: db.User,
          as: "rUser",
          attributes: ["id", "username", "phone"],
        },
      ],
    });

    return res.json({
      success: true,
      mes: "Lấy danh sách yêu cầu thành công.",
      requestRooms: response,
    });
  }),
  // POST: Tạo yêu cầu mới
  createRequestRoom: asyncHandler(async (req, res) => {
    const { userId, priceRange, location, specialRequirements, financialLimit, numberOfPeople, numberOfVehicles, contactInfo } = req.body;

    if (!userId || !location || !priceRange || !contactInfo) {
      return res.status(400).json({
        success: false,
        mes: "Thiếu thông tin bắt buộc.",
      });
    }

    const response = await db.RequestRoom.create({
      userId,
      priceRange,
      location,
      specialRequirements,
      financialLimit,
      numberOfPeople,
      numberOfVehicles,
      contactInfo,
      isActive: true,
    });

    return res.json({
      success: !!response,
      mes: response ? "Tạo yêu cầu thành công." : "Tạo yêu cầu thất bại.",
      requestRoom: response,
    });
  }),

  // DELETE: Xóa mềm yêu cầu
  deleteRequestRoom: asyncHandler(async (req, res) => {
    const { id } = req.params;

    const response = await db.RequestRoom.update(
      { isActive: false },
      { where: { id } }
    );

    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Xóa yêu cầu thành công." : "Không tìm thấy yêu cầu.",
    });
  }),
};
