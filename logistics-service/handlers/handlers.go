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
