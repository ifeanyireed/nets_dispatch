package handlers

import (
	"logistics-service/database"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

func GetWallet(c *gin.Context) {
	userId := c.Param("userId")
	var wallet database.Wallet
	
	if err := database.DB.Where("user_id = ?", userId).First(&wallet).Error; err != nil {
		// Mock initial balance for testing if missing
		wallet = database.Wallet{
			UserID:  userId,
			Balance: 12400.0, // Hardcoded initial mock balance for the dashboard
		}
		database.DB.Create(&wallet)
	}

	c.JSON(http.StatusOK, wallet)
}

func RequestPayout(c *gin.Context) {
	userId := c.Param("userId")
	var input struct {
		Amount        float64 `json:"amount" binding:"required"`
		BankName      string  `json:"bankName" binding:"required"`
		AccountNumber string  `json:"accountNumber" binding:"required"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var wallet database.Wallet
	if err := database.DB.Where("user_id = ?", userId).First(&wallet).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Wallet not found"})
		return
	}

	if wallet.Balance < input.Amount {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Insufficient funds"})
		return
	}

	// Deduct balance
	wallet.Balance -= input.Amount
	database.DB.Save(&wallet)

	// Create payout request
	payout := database.PayoutRequest{
		ID:            uuid.NewString(),
		UserID:        userId,
		Amount:        input.Amount,
		BankName:      input.BankName,
		AccountNumber: input.AccountNumber,
		Status:        "Pending",
	}
	
	if err := database.DB.Create(&payout).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to request payout"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Payout requested successfully",
		"payout":  payout,
		"newBalance": wallet.Balance,
	})
}
