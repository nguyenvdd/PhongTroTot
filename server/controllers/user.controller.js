const asyncHandler = require("express-async-handler")
const db = require("../models")
const bcrypt = require("bcrypt")
const jwt = require("jsonwebtoken")
const crypto = require("crypto")
const nodemailer = require("nodemailer")
const { Op, Sequelize, where } = require("sequelize")
const { OAuth2Client } = require("google-auth-library");

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
module.exports = {
  verifyPhoneNumber: asyncHandler(async (req, res) => {
    const response = await db.User.findOne({
      where: { phone: req.body.phone },
    })
    return res.json({
      success: !response,
      mes: response ? "SĐT đã được sử dụng." : "SĐT hợp lệ",
    })
  }),

  register: asyncHandler(async (req, res) => {
    try {
      const { phone, password, username, roleCode } = req.body
      const phoneVerified = roleCode === "MANAGER" ? true : false
      const response = await db.User.create({
        phone,
        password,
        username,
        phoneVerified,
      })
      if (response) {
        const roleCodes = ["USER"]
        if (roleCode && roleCode !== "USER") roleCodes.push(roleCode)
        const bulkData = roleCodes.map((el) => ({
          userId: response.id,
          roleCode: el,
          // isValid: el === "USER" ? true : false,
        }))
        const addRoles = await db.Role_User.bulkCreate(bulkData)
        if (addRoles && addRoles.length > 0)
          return res.json({
            success: true,
            mes: "Đăng ký tài khoản thành công.",
          })
        else {
          await db.User.destroy({ where: { id: response.id } })
          return res.json({
            success: false,
            mes: "Có lỗi, hãy thử lại",
          })
        }
      } else
        return res.json({
          success: false,
          mes: "Có lỗi, hãy thử lại",
        })
    } catch (error) {
      console.log(error)
    }
  }),

  login: asyncHandler(async (req, res) => {
    const { phone, password } = req.body
    const response = await db.User.findOne({ where: { phone } })
    if (!response) throw new Error("Thông tin đăng nhập không đúng.")
    const isValidPassword = bcrypt.compareSync(password, response.password)
    if (!isValidPassword) throw new Error("Thông tin đăng nhập không đúng.")
    const accessToken = await jwt.sign({ id: response.id }, process.env.JWT_SECRET, { expiresIn: "2d" })

    return res.json({
      success: !!accessToken,
      accessToken,
      mes: !!accessToken ? "Logged In" : "Thông tin đăng nhập không đúng.",
    })
  }),
  loginWithGoogle: asyncHandler(async (req, res) => {
    const { idToken } = req.body;

    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const email = payload?.email;

    const profile = await db.Profile.findOne({
      where: { email },
      include: [{ model: db.User, as: "rUser" }],
    });

    if (!profile || !profile.rUser) {
      throw new Error("Email chưa được đăng ký.");
    }

    const accessToken = await jwt.sign(
      { id: profile.rUser.id },
      process.env.JWT_SECRET,
      { expiresIn: "2d" }
    );

    return res.json({
      success: !!accessToken,
      accessToken,
      mes: !!accessToken ? "Đăng nhập bằng Google thành công." : "Xác thực thất bại.",
    });
  }),
  changePassword: asyncHandler(async (req, res) => {
    const { currentPassword, newPassword } = req.body
    const userId = req.user.id // Assuming the user is authenticated and their ID is available in `req.user.id`

    // Fetch user from the database
    const user = await db.User.findByPk(userId)
    if (!user) {
      return res.status(404).json({ success: false, mes: "Người dùng không tồn tại" })
    }

    // Check if the current password is correct
    const isPasswordCorrect = bcrypt.compareSync(currentPassword, user.password)
    if (!isPasswordCorrect) {
      return res.status(400).json({ success: false, mes: "Mật khẩu cũ không chính xác." })
    }

    // Update the password
    user.password = newPassword // bcrypt will automatically hash the new password using the setter
    await user.save()

    return res.json({ success: true, mes: "Mật khẩu đã được thay đổi thành công." })
  }),
  getCurrent: asyncHandler(async (req, res) => {
    const { id } = req.user
    const response = await db.User.findByPk(id, {
      attributes: ["id", "username", "phone"],
      include: [
        {
          model: db.Profile,
          as: "rprofile",
        },
        {
          model: db.Role_User,
          as: "rroles",
          attributes: ["roleCode"],
          include: [{ model: db.Role, as: "roleValues", attributes: ["value"] }],
        },
      ],
    })

    return res.json({
      success: !!response,
      currentUser: response,
      mes: !!response ? "Got." : "Không tìm thấy user.",
    })
  }),

  updateProfile: asyncHandler(async (req, res) => {
    const { id } = req.user
    const { username, email, firstName, lastName, address, gender, image, phone, CID } = req.body
    const alreadyCID = await db.Profile.findOne({ where: { CID } })
    if (alreadyCID && +alreadyCID.id !== +id)
      return res.json({
        mes: "CCCD đã có người sử dụng",
        success: false,
      })
    await db.Profile.findOrCreate({
      where: { userId: id },
      defaults: {
        userId: id,
      },
    })
    const [updateUser, updateProfile] = await Promise.all([
      db.Profile.update(
        { email, firstName, lastName, address, gender: gender || "Khác", image, CID },
        { where: { userId: id } }
      ),
      db.User.update({ username, phone }, { where: { id } }),
    ])

    return res.json({
      success: updateUser[0] > 0 && updateProfile[0] > 0,
      mes: updateUser[0] > 0 && updateProfile[0] > 0 ? "Cập nhật thành công" : "Có lỗi hãy thử lại xem.",
    })
  }),
  getUsers: asyncHandler(async (req, res) => {
    try {
      const { limit, page, sort, fields, keyword, ...filters } = req.query;
      const options = {};
      const userWhere = { ...filters };

      // Xử lý chọn fields
      if (fields) {
        const attributes = fields.split(",");
        const isExclude = attributes.some((el) => el.startsWith("-"));
        options.attributes = isExclude
          ? { exclude: attributes.map((el) => el.replace("-", "")) }
          : attributes;
      }

      // Tìm kiếm keyword chỉ trong bảng User
      if (keyword) {
        userWhere[Op.or] = [
          {
            username: {
              [Op.iLike]: `%${keyword}%`,
            },
          },
          {
            phone: {
              [Op.iLike]: `%${keyword}%`,
            },
          },
        ];
      }

      // Sắp xếp
      if (sort) {
        const order = sort
          .split(",")
          .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]));
        options.order = order;
      }

      const includeOptions = [
        {
          model: db.Profile,
          as: "rprofile",
        },
        {
          model: db.Role_User,
          as: "rroles",
          attributes: ["roleCode"],
          include: [
            {
              model: db.Role,
              as: "roleValues",
              attributes: ["value"],
            },
          ],
        },
      ];

      // Nếu không phân trang
      if (!limit) {
        const response = await db.User.findAll({
          where: userWhere,
          ...options,
          attributes: ["id", "phone", "username"],
          include: includeOptions,
        });

        return res.json({
          success: response.length > 0,
          mes: response.length > 0 ? "Got." : "Không tìm thấy người dùng.",
          users: response,
        });
      }

      // Có phân trang
      const prevPage = !page || page === 1 ? 0 : page - 1;
      const offset = prevPage * limit;
      if (offset) options.offset = offset;
      options.limit = +limit;

      const response = await db.User.findAndCountAll({
        where: userWhere,
        attributes: { exclude: ["password"] },
        ...options,
        distinct: true,
        include: includeOptions,
      });

      return res.json({
        success: true,
        mes: "Got.",
        users: response,
      });
    } catch (error) {
      console.error("getUsers error:", error);
      return res.status(500).json({
        success: false,
        mes: "Đã xảy ra lỗi khi truy vấn danh sách người dùng.",
        error: error.message,
      });
    }
  }),

  updateManager: asyncHandler(async (req, res) => {
    const { id } = req.user
    const response = await db.Role_User.create({
      userId: id,
      roleCode: "MANAGER",
    })

    return res.json({
      success: !!response,
      mes: !!response ? "Nâng cấp thành công. Hãy đăng nhập lại" : "Nâng cấp tài khoản thất bại.",
    })
  }),
  getCustomersByManager: asyncHandler(async (req, res) => {
    const { limit, page, sort, fields, keyword, ...filters } = req.query
    const { id } = req.user
    const options = {}
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
        {
          firstName: Sequelize.where(
            Sequelize.fn("LOWER", Sequelize.col("rprofile.firstName")),
            "LIKE",
            `%${keyword.toLocaleLowerCase()}%`
          ),
        },
        {
          lastName: Sequelize.where(
            Sequelize.fn("LOWER", Sequelize.col("rprofile.lastName")),
            "LIKE",
            `%${keyword.toLocaleLowerCase()}%`
          ),
        },
      ]
    if (sort) {
      const order = sort
        .split(",")
        .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]))
      options.order = order
    }

    if (!limit) {
      const response = await db.User.findAll({
        where: filters,
        ...options,
        attributes: ["id", "phone", "username"],
        include: [
          {
            model: db.Profile,
            as: "rprofile",
          },
        ],
      })
      return res.json({
        success: response.length > 0,
        mes: response.length > 0 ? "Got." : "Có lỗi, hãy thử lại sau.",
        users: response,
      })
    }
    const prevPage = !page || page === 1 ? 0 : page - 1
    const offset = prevPage * limit
    if (offset) options.offset = offset
    options.limit = +limit
    const response = await db.User.findAndCountAll({
      where: { ...filters, "$rContracts.rRoom.rPost.postedBy$": id },
      attributes: { exclude: ["password"] },
      ...options,
      distinct: true,
      subQuery: false,
      include: [
        { model: db.Profile, as: "rprofile" },
        {
          model: db.Contract,
          as: "rContracts",
          include: [{ model: db.Room, as: "rRoom", include: [{ model: db.Post, as: "rPost" }] }],
        },
        {
          model: db.Role_User,
          as: "rroles",
          attributes: ["roleCode"],
          include: [{ model: db.Role, as: "roleValues", attributes: ["value"] }],
        },
      ],
    })

    return res.json({
      success: Boolean(response),
      mes: response ? "Got." : "Có lỗi, hãy thử lại sau.",
      users: response,
    })
  }),
  updateUser: asyncHandler(async (req, res) => {
    const { id } = req.params
    const { username, email, firstName, lastName, address, gender, image, phone, role = [] } = req.body
    await db.Profile.findOrCreate({
      where: { userId: id },
      defaults: {
        userId: id,
      },
    })
    const [updateUser, updateProfile] = await Promise.all([
      db.Profile.update(
        { email, firstName, lastName, address, gender: gender || "Khác", image },
        { where: { userId: id } }
      ),
      db.User.update({ username, phone }, { where: { id } }),
    ])
    await db.Role_User.destroy({ where: { userId: id } })
    await db.Role_User.bulkCreate(role.map((el) => ({ userId: id, roleCode: el })))

    return res.json({
      success: updateUser[0] > 0 && updateProfile[0] > 0,
      mes: updateUser[0] > 0 && updateProfile[0] > 0 ? "Cập nhật thành công" : "Có lỗi hãy thử lại xem.",
    })
  }),
  updateUserByManager: asyncHandler(async (req, res) => {
    const { id } = req.params
    const { firstName, lastName, address, gender, image, phone } = req.body
    await db.Profile.findOrCreate({
      where: { userId: id },
      defaults: {
        userId: id,
      },
    })
    const [updateUser, updateProfile] = await Promise.all([
      db.Profile.update(
        { firstName, lastName, address, gender: gender || "Khác", image },
        { where: { userId: id } }
      ),
      db.User.update({ phone }, { where: { id } }),
    ])

    return res.json({
      success: updateUser[0] > 0 && updateProfile[0] > 0,
      mes: updateUser[0] > 0 && updateProfile[0] > 0 ? "Cập nhật thành công" : "Có lỗi hãy thử lại xem.",
    })
  }),
  deleteUser: asyncHandler(async (req, res) => {
    const { id } = req.params
    const response = await db.User.update({ isDeleted: true }, { where: { id } })

    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Xóa thành công" : "Có lỗi hãy thử lại xem.",
    })
  }),
  getRentedRooms: asyncHandler(async (req, res) => {
    const { id } = req.user
    const { limit, page, sort, fields, keyword, isDeleted, ...filters } = req.query
    const options = {}
    filters.userId = id
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
          "$rRoom.title$": Sequelize.where(
            Sequelize.fn("LOWER", Sequelize.col("rRoom.title")),
            "LIKE",
            `%${keyword.toLocaleLowerCase()}%`
          ),
        },
      ]
    if (sort) {
      const order = sort
        .split(",")
        .map((el) => (el.startsWith("-") ? [["rRoom", el.replace("-", ""), "DESC"]] : [["rRoom", el, "ASC"]]))
      options.order = order
    }
    if (!isDeleted) filters.isDeleted = false
    // filters["$rRooms.isDeleted&"] = false
    if (!limit) {
      const response = await db.Payment.findAll({
        where: filters,
        ...options,
      })
      return res.json({
        success: response.length > 0,
        mes: response.length > 0 ? "Got." : "Có lỗi, hãy thử lại sau.",
        rentedRooms: response,
      })
    }
    const prevPage = !page || page === 1 ? 0 : page - 1
    const offset = prevPage * limit
    if (offset) options.offset = offset
    options.limit = +limit
    const response = await db.Payment.findAndCountAll({
      where: filters,
      ...options,
      distinct: true,
      include: [
        {
          model: db.Room,
          as: "rRoom",
          include: [{ model: db.IndexCounter, as: "rCounter" }],
          order: ["date", "ASC"],
        },
      ],
    })

    return res.json({
      success: Boolean(response),
      mes: response ? "Got." : "Có lỗi, hãy thử lại sau.",
      posts: response,
    })
  }),
  getIndexCounterByRoomId: asyncHandler(async (req, res) => {
    const { roomId } = req.params

    const response = await db.IndexCounter.findAll({ where: { roomId }, order: [["date", "DESC"]] })
    return res.json({
      success: !!response.length,
      indexCounter: response,
    })
  }),
  updatePaymentIndex: asyncHandler(async (req, res) => {
    const { id } = req.params

    const response = await db.IndexCounter.update({ isPayment: true }, { where: { id } })
    await db.Payment.create(req.body)
    return res.json({
      success: response[0] > 0,
      mes: response[0] > 0 ? "Cập nhật thanh toán thành công." : "Có lỗi, hãy thử lại sau.",
    })
  }),
  getCustomersByAdmin: asyncHandler(async (req, res) => {
    const { limit, page, sort, fields, keyword, ...filters } = req.query
    const { id } = req.user
    const options = {}
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
        {
          firstName: Sequelize.where(
            Sequelize.fn("LOWER", Sequelize.col("rprofile.firstName")),
            "LIKE",
            `%${keyword.toLocaleLowerCase()}%`
          ),
        },
        {
          lastName: Sequelize.where(
            Sequelize.fn("LOWER", Sequelize.col("rprofile.lastName")),
            "LIKE",
            `%${keyword.toLocaleLowerCase()}%`
          ),
        },
      ]
    if (sort) {
      const order = sort
        .split(",")
        .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]))
      options.order = order
    }

    if (!limit) {
      const response = await db.User.findAll({
        where: filters,
        ...options,
        attributes: ["id", "phone", "username"],
        include: [
          {
            model: db.Profile,
            as: "rprofile",
          },
        ],
      })
      return res.json({
        success: response.length > 0,
        mes: response.length > 0 ? "Got." : "Có lỗi, hãy thử lại sau.",
        users: response,
      })
    }
    const prevPage = !page || page === 1 ? 0 : page - 1
    const offset = prevPage * limit
    if (offset) options.offset = offset
    options.limit = +limit
    const response = await db.User.findAndCountAll({
      where: { ...filters }, // Không lọc theo postedBy
      attributes: { exclude: ["password"] },
      ...options,
      distinct: true,
      subQuery: false,
      include: [
        { model: db.Profile, as: "rprofile" },
        {
          model: db.Contract,
          as: "rContracts",
          include: [
            {
              model: db.Room,
              as: "rRoom",
              required: false, // Đảm bảo kết quả vẫn trả về nếu không có Room
              include: [
                {
                  model: db.Post,
                  as: "rPost",
                  required: false // Đảm bảo kết quả vẫn trả về nếu không có Post
                }
              ]
            }
          ],
        },
        {
          model: db.Role_User,
          as: "rroles",
          attributes: ["roleCode"],
          include: [{ model: db.Role, as: "roleValues", attributes: ["value"] }],
        },
      ],
    });


    return res.json({
      success: Boolean(response),
      mes: response ? "Got." : "Có lỗi, hãy thử lại sau.",
      users: response,
    })
  }),
  getUsersbyManager: asyncHandler(async (req, res) => {
    try {
      const { limit, page, sort, fields, keyword, ...filters } = req.query;
      const options = {};
      const userWhere = { ...filters };

      // Xử lý chọn trường (fields)
      if (fields) {
        const attributes = fields.split(",");
        const isExclude = attributes.some((el) => el.startsWith("-"));
        options.attributes = isExclude
          ? { exclude: attributes.map((el) => el.replace("-", "")) }
          : attributes;
      }

      // Tìm kiếm keyword chỉ trong bảng User
      if (keyword) {
        userWhere[Op.or] = [
          {
            username: {
              [Op.iLike]: `%${keyword}%`,
            },
          },
          {
            phone: {
              [Op.iLike]: `%${keyword}%`,
            },
          },
        ];
      }

      // Sắp xếp nếu có
      if (sort) {
        const order = sort
          .split(",")
          .map((el) => (el.startsWith("-") ? [el.replace("-", ""), "DESC"] : [el, "ASC"]));
        options.order = order;
      }

      // Include các bảng liên quan (không dùng where trong rprofile nữa)
      const includeOptions = [
        {
          model: db.Profile,
          as: "rprofile",
        },
        {
          model: db.Role_User,
          as: "rroles",
          where: { roleCode: "MANAGER" },
          include: [
            {
              model: db.Role,
              as: "roleValues",
              attributes: ["value"],
            },
          ],
        },
      ];

      // Không phân trang
      if (!limit) {
        const response = await db.User.findAll({
          where: userWhere,
          ...options,
          attributes: ["id", "phone", "username"],
          include: includeOptions,
        });

        return res.json({
          success: response.length > 0,
          mes: response.length > 0 ? "Got." : "Không tìm thấy người dùng.",
          users: response,
        });
      }

      // Có phân trang
      const prevPage = !page || page === 1 ? 0 : page - 1;
      const offset = prevPage * limit;
      if (offset) options.offset = offset;
      options.limit = +limit;

      const response = await db.User.findAndCountAll({
        where: userWhere,
        attributes: { exclude: ["password"] },
        ...options,
        distinct: true,
        include: includeOptions,
      });

      return res.json({
        success: true,
        mes: "Got.",
        users: response,
      });

    } catch (error) {
      console.error("getUsersbyManager error:", error);
      return res.status(500).json({
        success: false,
        mes: "Lỗi khi truy vấn danh sách người dùng.",
        error: error.message,
      });
    }
  }),
  forgotPassword: asyncHandler(async (req, res) => {
    const { email } = req.body // Lấy email từ body

    // Tìm Profile từ email
    const profile = await db.Profile.findOne({
      where: { email },
      include: [
        {
          model: db.User,
          as: "rUser", // Mối quan hệ từ Profile đến User
          attributes: ["id"], // Chỉ lấy id của User
        },
      ],
    })

    if (!profile || !profile.rUser) {
      return res.status(404).json({ success: false, mes: "Người dùng không tồn tại." })
    }

    // Lấy userId từ Profile
    const userId = profile.rUser.id

    // Tạo reset token
    const resetToken = crypto.randomBytes(20).toString("hex")
    const resetTokenExpire = Date.now() + 3600000 // Token hết hạn sau 1 giờ

    // Tìm User từ userId và lưu token và thời gian hết hạn
    const user = await db.User.findByPk(userId)
    if (!user) {
      return res.status(404).json({ success: false, mes: "Người dùng không tồn tại." })
    }

    user.resetTokenPassword = resetToken
    user.resetTokenExpire = resetTokenExpire
    await user.save()

    // Gửi email với reset link
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: process.env.EMAIL_NAME, // Đặt email của bạn ở đây
        pass: process.env.EMAIL_APP_PASSWORD, // Đặt mật khẩu email của bạn ở đây
      },
    })

    const resetLink = `${process.env.CLIENT_URL}/dat-lai-mat-khau?token=${resetToken}` // Đường dẫn reset mật khẩu
    await transporter.sendMail({
      from: process.env.EMAIL_USER, // Đảm bảo bạn đã cung cấp đúng thông tin email
      to: email,
      subject: "Yêu cầu khôi phục mật khẩu",
      html: `
    <html>
      <head>
        <style>
          body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f3f4f6;
          }
          .container {
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
          }
          h2 {
            color: #333;
            text-align: center;
          }
          p {
            font-size: 16px;
            color: #555;
            line-height: 1.5;
          }
          .reset-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            padding: 12px 25px;
            background-color: #007370;
            color: white;
            text-decoration: none;
            font-size: 16px;
            border-radius: 5px;
            font-weight: bold;
          }
          .footer {
            text-align: center;
            font-size: 14px;
            color: #888;
            margin-top: 20px;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h2>Yêu cầu khôi phục mật khẩu</h2>
          <p>
            Bạn đã yêu cầu khôi phục mật khẩu cho tài khoản của mình. Để thay đổi mật khẩu, vui lòng nhấn vào liên kết bên dưới:
          </p>
          <a href="${resetLink}" class="reset-link">Đặt lại mật khẩu</a>
          <p>
            Nếu bạn không yêu cầu thay đổi mật khẩu, vui lòng bỏ qua email này. Liên kết khôi phục mật khẩu sẽ hết hạn sau 1 giờ.
          </p>
          <div class="footer">
            <p>Trân trọng,</p>
            <p>Đội ngũ hỗ trợ</p>
          </div>
        </div>
      </body>
    </html>
  `,
    })


    return res.json({ success: true, mes: "Đã gửi email khôi phục mật khẩu cho bạn." })
  }),
  // Reset Password - Kiểm tra token và đặt mật khẩu mới
  resetPassword: asyncHandler(async (req, res) => {
    const { token, newPassword } = req.body

    // Kiểm tra token và thời gian hết hạn
    const user = await db.User.findOne({
      where: {
        resetTokenPassword: token,
        resetTokenExpire: { [Op.gt]: Date.now() }, // Kiểm tra xem token chưa hết hạn
      },
    })

    if (!user) {
      return res.status(400).json({ success: false, mes: "Token không hợp lệ hoặc đã hết hạn." })
    }

    // Mã hóa mật khẩu mới
    user.password = newPassword; // Dùng bcrypt để mã hóa mật khẩu mới
    user.resetTokenPassword = null // Xóa token sau khi reset thành công
    user.resetTokenExpire = null // Xóa thời gian hết hạn
    await user.save()

    return res.json({ success: true, mes: "Mật khẩu đã được thay đổi thành công." })
  })

}
