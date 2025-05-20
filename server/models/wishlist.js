"use strict"
const { Model } = require("sequelize")
module.exports = (sequelize, DataTypes) => {
  class Wishlist extends Model {
    static associate(models) {
      Wishlist.belongsTo(models.User, { foreignKey: "userId", as: "user" });
      Wishlist.belongsTo(models.Post, { foreignKey: "postId", as: "post" });

      // define association here
    }
  }
  Wishlist.init(
    {
      postId: DataTypes.INTEGER,
      userId: DataTypes.INTEGER,
      isDeleted: DataTypes.BOOLEAN,
    },
    {
      sequelize,
      modelName: "Wishlist",
    }
  )
  return Wishlist
}
