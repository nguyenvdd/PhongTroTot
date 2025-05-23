const asyncHandler = require("express-async-handler")
const db = require("../models")
const { Sequelize, Op } = require("sequelize")

module.exports = {
  create: asyncHandler(async (req, res) => {
    const { firstName, lastName, CID, address, ...data } = req.body
    const response = await Promise.all([
      db.Contract.create(data),
      db.Room.update({ position: "Đã thuê" }, { where: { id: data.roomId } }),
      db.Payment.update(
        { status: "Thành công" },
        {
          where: {
            roomId: data.roomId,
            userId: data.userId,
            status: "Đang chờ",
          },
        }
      ),
    ])
    const alreadyUpdateProfile = await db.Profile.findOne({ where: { userId: data.userId } })
    if (alreadyUpdateProfile) {
      await db.Profile.update({ firstName, lastName, CID, address }, { where: { userId: data.userId } })
    } else {
      await db.Profile.create({ firstName, lastName, CID, address, userId: data.userId })
    }

    return res.json({
      success: !!response[0],
      mes: response[0] ? "Thêm hợp đồng thành công" : "Có lỗi",
      response,
    })
  }),
  get: asyncHandler(async (req, res) => {
    const { limit, page, sort, fields, keyword, postedBy, userId, ...filters } = req.query;
    const options = {};
    const contractWhere = { ...filters };

    // Lọc theo người đăng bài
    if (postedBy) contractWhere["$rRoom.rPost.postedBy$"] = postedBy;

    // Xử lý fields
    if (fields) {
      const attributes = fields.split(",");
      const isExclude = attributes.some((el) => el.startsWith("-"));
      options.attributes = isExclude
        ? { exclude: attributes.map((el) => el.replace("-", "")) }
        : attributes;
    }

    // Tìm kiếm theo thông tin Room
    const roomInclude = {
      model: db.Room,
      as: "rRoom",
      attributes: ["id", "title", "position"],
      include: [
        {
          model: db.Post,
          as: "rPost",
          attributes: ["id", "title", "postedBy"],
        },
      ],
    };

    if (keyword) {
      roomInclude.where = {
        [Op.or]: [
          {
            title: {
              [Op.iLike]: `%${keyword}%`,
            },
          },
          {
            position: Sequelize.where(
              Sequelize.cast(Sequelize.col("rRoom.position"), "TEXT"),
              {
                [Op.iLike]: `%${keyword}%`,
              }
            ),
          },
        ],
      };
    }

    // Sắp xếp
    if (sort) {
      const order = sort
        .split(",")
        .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]));
      options.order = order;
    }

    // Nếu không phân trang
    if (!limit) {
      const response = await db.Contract.findAll({
        where: contractWhere,
        subQuery: false,
        include: [
          roomInclude,
          {
            model: db.User,
            as: "rUser",
            attributes: ["id", "username", "phone"],
            include: [
              {
                model: db.Profile,
                as: "rprofile",
                attributes: ["firstName", "lastName", "CID", "address", "birthday"],
              },
            ],
          },
          {
            model: db.Payment,
            as: "rPayments",
            attributes: ["total"],
            required: false,
          },
        ],
        ...options,
        distinct: true,
      });

      return res.json({
        success: response.length > 0,
        mes: response.length > 0 ? "Got." : "Không tìm thấy hợp đồng.",
        contracts: response,
      });
    }

    // Có phân trang
    const prevPage = !page || page === 1 ? 0 : page - 1;
    const offset = prevPage * limit;
    if (offset) options.offset = offset;
    options.limit = +limit;

    const response = await db.Contract.findAndCountAll({
      where: contractWhere,
      subQuery: false,
      include: [
        roomInclude,
        {
          model: db.User,
          as: "rUser",
          attributes: ["id", "username", "phone"],
          include: [
            {
              model: db.Profile,
              as: "rprofile",
              attributes: ["firstName", "lastName", "CID", "address", "birthday"],
            },
          ],
        },
        {
          model: db.Payment,
          as: "rPayments",
          attributes: ["total"],
          required: false,
        },
      ],
      ...options,
      distinct: true,
    });

    return res.json({
      success: Boolean(response),
      mes: response ? "Got." : "Có lỗi, hãy thử lại sau.",
      contracts: response,
    });
  }),

  getCustomer: asyncHandler(async (req, res) => {
    const { limit, page, sort, fields, keyword, postedBy, ...filters } = req.query
    const options = {}
    if (postedBy) filters["$rRoom.rPost.postedBy$"] = postedBy
    if (fields) {
      const attributes = fields.split(",")
      const isExclude = attributes.some((el) => el.startsWith("-"))
      if (isExclude)
        options.attributes = {
          exclude: attributes.map((el) => el.replace("-", "")),
        }
      else options.attributes = attributes
    }
    if (keyword)
      filters[Op.or] = [
        {
          username: Sequelize.where(
            Sequelize.fn("LOWER", Sequelize.col("User.username")),
            "LIKE",
            `%${keyword.toLocaleLowerCase()}%`
          ),
        },
        { "$rUser.username$": keyword },
        { "$rUser.phone$": keyword },
      ]
    if (sort) {
      const order = sort
        .split(",")
        .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]))
      options.order = order
    }

    if (!limit) {
      const response = await db.Contract.findAll({
        where: filters,
        subQuery: false,
        ...options,
        distinct: true,
      })
      return res.json({
        success: response.length > 0,
        mes: response.length > 0 ? "Got." : "Có lỗi, hãy thử lại sau.",
        contracts: response,
      })
    }
    const prevPage = !page || page === 1 ? 0 : page - 1
    const offset = prevPage * limit
    if (offset) options.offset = offset
    options.limit = +limit
    const response = await db.Contract.findAndCountAll({
      where: filters,
      subQuery: false,
      include: [
        {
          model: db.User,
          as: "rUser",
          attributes: ["id", "username", "phone"],
          include: [{ model: db.Profile, as: "rprofile" }],
        },
        {
          model: db.Room,
          as: "rRoom",
          attributes: ["id", "title"],
          include: [
            {
              model: db.Post,
              as: "rPost",
              attributes: ["id", "title", "postedBy"],
            },
          ],
        },
      ],
      ...options,
      distinct: true,
    })

    return res.json({
      success: Boolean(response),
      mes: response ? "Got." : "Có lỗi, hãy thử lại sau.",
      contracts: response,
    })
  }),
  update: asyncHandler(async (req, res) => {
    const { id } = req.params
    const response = await db.Contract.update(req.body, { where: { id } })
    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Cập nhật thành công." : "Cập nhật không thành công.",
    })
  }),
  remove: asyncHandler(async (req, res) => {
    const { id } = req.params
    const response = await db.Contract.destroy({ where: { id } })
    return res.json({
      success: response > 0,
      mes: response > 0 ? "Xóa thành công." : "Xóa không thành công.",
    })
  }),
  getAdmin: asyncHandler(async (req, res) => {
    try {
      const { limit, page, sort, fields, keyword, postedBy, userId, ...filters } = req.query;
      const options = {};
      const contractWhere = { ...filters };

      // Xử lý chọn fields
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

      // Xử lý tìm kiếm theo thông tin ROOM (không phải Post)
      const roomInclude = {
        model: db.Room,
        as: "rRoom",
        attributes: ["id", "title", "position"],
        include: [
          {
            model: db.Post,
            as: "rPost",
            attributes: ["id", "title", "postedBy"],
          },
        ],
      };

      if (keyword) {
        roomInclude.where = {
          [Op.or]: [
            {
              title: {
                [Op.iLike]: `%${keyword}%`,
              },
            },
            {
              position: Sequelize.where(
                Sequelize.cast(Sequelize.col("rRoom.position"), "TEXT"),
                {
                  [Op.iLike]: `%${keyword}%`,
                }
              ),
            },
          ],
        };
      }

      // Sắp xếp
      if (sort) {
        const order = sort
          .split(",")
          .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]));
        options.order = order;
      }

      // Nếu không phân trang
      if (!limit) {
        const response = await db.Contract.findAll({
          where: contractWhere,
          subQuery: false,
          include: [
            roomInclude,
            {
              model: db.User,
              as: "rUser",
              attributes: ["id", "username", "phone"],
              include: [
                {
                  model: db.Profile,
                  as: "rprofile",
                  attributes: ["firstName", "lastName", "CID", "address", "birthday"],
                },
              ],
            },
            {
              model: db.Payment,
              as: "rPayments",
              attributes: ["total"],
              required: false,
            },
          ],
          ...options,
          distinct: true,
        });

        return res.json({
          success: response.length > 0,
          mes: response.length > 0 ? "Got." : "Không tìm thấy hợp đồng.",
          contracts: response,
        });
      }

      // Có phân trang
      const prevPage = !page || page === 1 ? 0 : page - 1;
      const offset = prevPage * limit;
      if (offset) options.offset = offset;
      options.limit = +limit;

      const response = await db.Contract.findAndCountAll({
        where: contractWhere,
        subQuery: false,
        include: [
          roomInclude,
          {
            model: db.User,
            as: "rUser",
            attributes: ["id", "username", "phone"],
            include: [
              {
                model: db.Profile,
                as: "rprofile",
                attributes: ["firstName", "lastName", "CID", "address", "birthday"],
              },
            ],
          },
          {
            model: db.Payment,
            as: "rPayments",
            attributes: ["total"],
            required: false,
          },
        ],
        ...options,
        distinct: true,
      });

      return res.json({
        success: true,
        mes: "Got.",
        contracts: response,
      });

    } catch (error) {
      console.error("getAdmin error:", error);
      return res.status(500).json({
        success: false,
        mes: "Lỗi khi truy vấn danh sách hợp đồng.",
        error: error.message,
      });
    }
  }),

}
