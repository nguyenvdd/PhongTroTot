const asyncHandler = require("express-async-handler")
const db = require("../models")
const { Sequelize, Op } = require("sequelize")

module.exports = {
  getRooms: asyncHandler(async (req, res) => {
    const { limit, page, sort, fields, title, keyword, postedBy, isDeleted, ...filters } = req.query;
    const options = {};
    const roomWhere = { ...filters };

    if (postedBy) roomWhere["$rPost.postedBy$"] = +postedBy;

    if (fields) {
      const attributes = fields.split(",");
      const isExclude = attributes.some((el) => el.startsWith("-"));
      options.attributes = isExclude
        ? { exclude: attributes.map((el) => el.replace("-", "")) }
        : attributes;
    }

    if (!isDeleted) roomWhere.isDeleted = false;

    // ✅ Tìm kiếm theo Room
    if (keyword) {
      roomWhere[Op.or] = [
        {
          title: {
            [Op.iLike]: `%${keyword}%`,
          },
        },
        {
          position: Sequelize.where(
            Sequelize.cast(Sequelize.col("Room.position"), "TEXT"),
            {
              [Op.iLike]: `%${keyword}%`,
            }
          ),
        },
        {
          internetPrice: Sequelize.where(
            Sequelize.cast(Sequelize.col("Room.internetPrice"), "TEXT"),
            {
              [Op.iLike]: `%${keyword}%`,
            }
          ),
        },
      ];
    }

    if (sort) {
      const order = sort
        .split(",")
        .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]));
      options.order = order;
    }

    // Không phân trang
    if (!limit) {
      const response = await db.Room.findAll({
        where: roomWhere,
        subQuery: false,
        include: [
          {
            model: db.Post,
            as: "rPost",
            attributes: ["id", "postedBy", "title"],
          },
        ],
        ...options,
        distinct: true,
      });

      return res.json({
        success: response.length > 0,
        mes: response.length > 0 ? "Got." : "Không tìm thấy phòng.",
        rooms: response,
      });
    }

    // Có phân trang
    const prevPage = !page || page === 1 ? 0 : page - 1;
    const offset = prevPage * limit;
    if (offset) options.offset = offset;
    options.limit = +limit;

    const response = await db.Room.findAndCountAll({
      where: roomWhere,
      ...options,
      distinct: true,
      include: [
        {
          model: db.Post,
          as: "rPost",
          attributes: ["id", "postedBy", "title"],
          required: true,
        },
        {
          model: db.Payment,
          as: "rPayment",
          include: [{ model: db.User, attributes: ["phone"], as: "rUser" }],
        },
        {
          model: db.IndexCounter,
          as: "rCounter",
        },
        {
          model: db.Contract,
          as: "rContract",
          attributes: ["id"],
          include: [
            {
              model: db.User,
              as: "rUser",
              attributes: ["id"],
              include: [
                {
                  model: db.Profile,
                  as: "rprofile",
                  attributes: ["firstName", "lastName"],
                },
              ],
            },
          ],
        },
      ],
    });

    return res.json({
      success: Boolean(response),
      mes: response ? "Got." : "Có lỗi, hãy thử lại sau.",
      rooms: response,
      options,
      filters,
    });
  }),

  update: asyncHandler(async (req, res) => {
    const { roomId } = req.params
    const response = await db.Room.update(req.body, { where: { id: roomId } })
    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Cập nhật thành công." : "Cập nhật không thành công.",
    })
  }),

  updateStatus: asyncHandler(async (req, res) => {
    const { roomId } = req.params
    const { userId } = req.body
    const response = await Promise.all([
      db.Room.update({ position: "Đã thuê" }, { where: { id: roomId } }),
      db.Payment.update(
        { status: "Thành công" },
        {
          where: {
            roomId: roomId,
            userId: userId,
            status: "Đang chờ"
          },
        }
      )
    ]);

    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Cập nhật thành công." : "Cập nhật không thành công.",
    })
  }),

  updateFull: asyncHandler(async (req, res) => {
    const { roomId } = req.params
    const { convenients, ...data } = req.body
    const response = await db.Room.update(data, { where: { id: roomId } })
    await db.Room_Convenient.destroy({ where: { roomId } })
    await db.Room_Convenient.bulkCreate(convenients.map((el) => ({ roomId, convenientId: el })))
    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Cập nhật thành công." : "Cập nhật không thành công.",
    })
  }),
  remove: asyncHandler(async (req, res) => {
    const { roomId } = req.params
    const response = await db.Room.update({ isDeleted: true }, { where: { id: roomId } })
    return res.json({
      success: response > 0,
      mes: response > 0 ? "Xóa thành công." : "Xóa không thành công.",
    })
  }),
  addIndexCounter: asyncHandler(async (req, res) => {
    const { services, ...data } = req.body
    if (services.some((el) => el === "caps")) data.caps = true
    if (services.some((el) => el === "internet")) data.internet = true

    const response = await db.IndexCounter.create(data)
    return res.json({
      success: !!response,
      mes: response ? "Cập nhật chỉ số thành công" : "Cập nhật chỉ số thất bại.",
    })
  }),
  createRoom: asyncHandler(async (req, res) => {
    const response = await db.Room.create(req.body)
    return res.json({
      success: !!response,
      mes: response ? "Thêm phòng trọ thành công" : "Có lỗi, hãy thử lại sau.",
    })
  }),
  getAdminRooms: asyncHandler(async (req, res) => {
    try {
      const { limit, page, sort, fields, title, keyword, isDeleted, ...filters } = req.query;
      const options = {};

      // Xử lý chọn trường (fields)
      if (fields) {
        const attributes = fields.split(",");
        const isExclude = attributes.some((el) => el.startsWith("-"));
        if (isExclude) {
          options.attributes = {
            exclude: attributes.map((el) => el.replace("-", "")),
          };
        } else {
          options.attributes = attributes;
        }
      }

      // Lọc isDeleted mặc định false nếu không truyền
      if (!isDeleted) {
        filters.isDeleted = false;
      }

      // Xử lý tìm kiếm keyword trên bảng Room
      if (keyword) {
        filters[Op.or] = [
          {
            title: {
              [Op.iLike]: `%${keyword}%`,
            },
          },
          {
            position: Sequelize.where(
              Sequelize.cast(Sequelize.col("position"), "TEXT"),
              {
                [Op.iLike]: `%${keyword}%`,
              }
            ),
          },
          {
            internetPrice: Sequelize.where(
              Sequelize.cast(Sequelize.col("internetPrice"), "TEXT"),
              {
                [Op.iLike]: `%${keyword}%`,
              }
            ),
          },
        ];
      }

      // Xử lý sắp xếp
      if (sort) {
        const order = sort
          .split(",")
          .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]));
        options.order = order;
      }

      // Trường hợp không phân trang
      if (!limit) {
        const response = await db.Room.findAll({
          where: filters,
          subQuery: false,
          include: [
            {
              model: db.Post,
              as: "rPost",
              attributes: ["id", "postedBy", "title"],
            },
          ],
          ...options,
          distinct: true,
        });

        return res.json({
          success: response.length > 0,
          mes: response.length > 0 ? "Got." : "Không tìm thấy phòng.",
          rooms: response,
        });
      }

      // Trường hợp có phân trang
      const prevPage = !page || page === 1 ? 0 : page - 1;
      const offset = prevPage * limit;
      if (offset) options.offset = offset;
      options.limit = +limit;

      const response = await db.Room.findAndCountAll({
        where: filters,
        ...options,
        distinct: true,
        include: [
          {
            model: db.Post,
            as: "rPost",
            attributes: ["id", "postedBy", "title"],
            required: true,
          },
          {
            model: db.Payment,
            as: "rPayment",
            include: [
              {
                model: db.User,
                attributes: ["phone"],
                as: "rUser",
              },
            ],
          },
          {
            model: db.IndexCounter,
            as: "rCounter",
          },
          {
            model: db.Contract,
            as: "rContract",
            attributes: ["id"],
            include: [
              {
                model: db.User,
                as: "rUser",
                attributes: ["id"],
                include: [
                  {
                    model: db.Profile,
                    as: "rprofile",
                    attributes: ["firstName", "lastName"],
                  },
                ],
              },
            ],
          },
        ],
      });

      return res.json({
        success: true,
        mes: "Got.",
        rooms: response,
        options,
        filters,
      });
    } catch (error) {
      console.error("getAdminRooms error:", error);
      return res.status(500).json({
        success: false,
        mes: "Đã xảy ra lỗi khi truy vấn danh sách phòng.",
        error: error.message,
      });
    }
  }),


}
