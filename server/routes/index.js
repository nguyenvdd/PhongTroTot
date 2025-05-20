const {
  errHandler,
  badRequestException,
} = require("../middlewares/errorHandler.middleware")
const user = require("./user.route")
const util = require("./app.route")
const convenient = require("./convenient.route")
const post = require("./post.route")
const payment = require("./payment.route")
const room = require("./room.route")
const contract = require("./contract.route")
const rating = require("./rating.route")
const wishlist = require("./wishlist.route")
const vnpay = require("./vnpay.route")
const requestRoom = require("./requestRoom.route")

const initRoutes = (app) => {
  app.use("/api/user", user)
  app.use("/api/app", util)
  app.use("/api/convenient", convenient)
  app.use("/api/post", post)
  app.use("/api/rating", rating)
  app.use("/api/contract", contract)
  app.use("/api/wishlist", wishlist)
  app.use("/api/room", room)
  app.use("/api/payment", payment)
  app.use("/api/vnpay", vnpay)
  app.use("/api/request-rooms", requestRoom)

  app.use(badRequestException)
  app.use(errHandler)
}

module.exports = initRoutes
