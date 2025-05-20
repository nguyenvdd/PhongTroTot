"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class RequestRoom extends Model {
    static associate(models) {
      // Một yêu cầu thuộc về một người dùng
      RequestRoom.belongsTo(models.User, { foreignKey: "userId", as: "rUser" });
    }
  }

  RequestRoom.init(
    {
      userId: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      priceRange: DataTypes.STRING,            // ví dụ: "2tr - 4tr"
      location: DataTypes.STRING,              // khu vực mong muốn
      specialRequirements: DataTypes.TEXT,     // yêu cầu đặc biệt
      financialLimit: DataTypes.STRING,        // giới hạn tài chính
      numberOfPeople: DataTypes.INTEGER,       // số người
      numberOfVehicles: DataTypes.INTEGER,     // số xe
      contactInfo: DataTypes.STRING,           // số điện thoại, email
      isActive: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      }
    },
    {
      sequelize,
      modelName: "RequestRoom",
    }
  );

  return RequestRoom;
};
