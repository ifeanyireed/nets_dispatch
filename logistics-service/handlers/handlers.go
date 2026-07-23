package handlers

import (
	"logistics-service/database"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetVendors(c *gin.Context) {
	var vendors []database.Vendor
	if err := database.DB.Find(&vendors).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, vendors)
}

func GetRiders(c *gin.Context) {
	var riders []database.Rider
	if err := database.DB.Find(&riders).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, riders)
}

func GetOrders(c *gin.Context) {
	var orders []database.Order
	if err := database.DB.Preload("Vendor").Preload("Rider").Find(&orders).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, orders)
}

func GetTransactions(c *gin.Context) {
	var txns []database.Transaction
	if err := database.DB.Find(&txns).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, txns)
}

// SeedDatabase handler will call the logic in seed
func SeedDatabase(c *gin.Context) {
	err := SeedData()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Database seeded successfully"})
}

func UpdateRiderStatus(c *gin.Context) {
	id := c.Param("id")
	var req struct {
		Status string `json:"status" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	var rider database.Rider
	if err := database.DB.Where("id = ?", id).First(&rider).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Rider not found"})
		return
	}

	rider.Status = req.Status
	if err := database.DB.Save(&rider).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, rider)
}

func GetRiderProfile(c *gin.Context) {
	userId := c.Param("userId")
	var rider database.Rider
	if err := database.DB.Where("user_id = ?", userId).First(&rider).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Rider not found"})
		return
	}
	c.JSON(http.StatusOK, rider)
}

func DeleteRider(c *gin.Context) {
	id := c.Param("id")
	
	var rider database.Rider
	if err := database.DB.Where("id = ?", id).First(&rider).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Rider not found"})
		return
	}

	userId := rider.UserID

	// Start transaction to delete both rider and associated user
	tx := database.DB.Begin()
	if err := tx.Delete(&rider).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete rider"})
		return
	}

	if err := tx.Where("id = ?", userId).Delete(&database.User{}).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete associated user"})
		return
	}

	tx.Commit()
	c.JSON(http.StatusOK, gin.H{"message": "Rider deleted successfully"})
}

func UpdateAvatar(c *gin.Context) {
	userId := c.Param("id")
	var req struct {
		AvatarURL string `json:"avatarUrl" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	var user database.User
	if err := database.DB.Where("id = ?", userId).First(&user).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	user.AvatarURL = req.AvatarURL
	if err := database.DB.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save avatar URL"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Avatar updated successfully", "avatarUrl": user.AvatarURL})
}
