"use strict";

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.createTable("RequestRooms", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      userId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Users", // tên table (phải viết đúng tên thật trong DB)
          key: "id",
        },
        onUpdate: "CASCADE",
        onDelete: "CASCADE",
      },
      priceRange: Sequelize.STRING,
      location: Sequelize.STRING,
      specialRequirements: Sequelize.TEXT,
      financialLimit: Sequelize.STRING,
      numberOfPeople: Sequelize.INTEGER,
      numberOfVehicles: Sequelize.INTEGER,
      contactInfo: Sequelize.STRING,
      isActive: {
        type: Sequelize.BOOLEAN,
        defaultValue: true,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal("CURRENT_TIMESTAMP"),
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.literal("CURRENT_TIMESTAMP"),
      },
    });
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.dropTable("RequestRooms");
  },
};
