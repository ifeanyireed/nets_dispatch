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
