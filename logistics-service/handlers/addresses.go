package handlers

import (
	"logistics-service/database"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type CreateAddressInput struct {
	Title   string `json:"title" binding:"required"`
	Address string `json:"address" binding:"required"`
	Type    string `json:"type" binding:"required"`
}

func GetAddresses(c *gin.Context) {
	userId := c.Param("userId")
	var addresses []database.Address
	database.DB.Where("user_id = ?", userId).Find(&addresses)
	c.JSON(http.StatusOK, addresses)
}

func CreateAddress(c *gin.Context) {
	userId := c.Param("userId")
	var input CreateAddressInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	address := database.Address{
		ID:      uuid.NewString(),
		UserID:  userId,
		Title:   input.Title,
		Address: input.Address,
		Type:    input.Type,
	}

	if err := database.DB.Create(&address).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save address"})
		return
	}

	c.JSON(http.StatusOK, address)
}

func DeleteAddress(c *gin.Context) {
	addressId := c.Param("id")
	if err := database.DB.Where("id = ?", addressId).Delete(&database.Address{}).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete address"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Address deleted successfully"})
}

func UpdateAddress(c *gin.Context) {
	addressId := c.Param("id")
	var input CreateAddressInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var address database.Address
	if err := database.DB.Where("id = ?", addressId).First(&address).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Address not found"})
		return
	}

	address.Title = input.Title
	address.Address = input.Address
	address.Type = input.Type

	if err := database.DB.Save(&address).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update address"})
		return
	}

	c.JSON(http.StatusOK, address)
}
