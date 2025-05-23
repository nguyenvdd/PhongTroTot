const router = require("express").Router()
const ctrls = require("../controllers/app.controller")
const { verifyToken, isManager, isAdmin } = require("../middlewares/verifyToken.middleware")

router.get("/roles", ctrls.getRoles)
router.get("/catalogs", ctrls.getCatalogs)
router.get("/dashboard/manager", verifyToken, isManager, ctrls.getDashboardManager)
router.get("/dashboard/admin/manager", verifyToken, isAdmin, ctrls.getDashboardAdminManager)
router.get("/dashboard/admin", verifyToken, isAdmin, ctrls.getDashboardAdmin)
router.get("/dashboard/room", verifyToken, isManager, ctrls.getDashboardRoom)

module.exports = router
