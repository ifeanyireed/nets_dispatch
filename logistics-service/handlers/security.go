package handlers

import (
	"logistics-service/database"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetSecuritySettings(c *gin.Context) {
	userId := c.Param("userId")
	var settings database.SecuritySetting
	
	result := database.DB.Where("user_id = ?", userId).First(&settings)
	if result.Error != nil {
		// If not found, create default
		settings = database.SecuritySetting{
			UserID:           userId,
			TwoFactorEnabled: false,
			LoginAlerts:      true,
		}
		database.DB.Create(&settings)
	}

	c.JSON(http.StatusOK, settings)
}

func UpdateSecuritySettings(c *gin.Context) {
	userId := c.Param("userId")
	var input struct {
		TwoFactorEnabled *bool `json:"twoFactorEnabled"`
		LoginAlerts      *bool `json:"loginAlerts"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var settings database.SecuritySetting
	if err := database.DB.Where("user_id = ?", userId).First(&settings).Error; err != nil {
		settings = database.SecuritySetting{UserID: userId}
		database.DB.Create(&settings)
	}

	if input.TwoFactorEnabled != nil {
		settings.TwoFactorEnabled = *input.TwoFactorEnabled
	}
	if input.LoginAlerts != nil {
		settings.LoginAlerts = *input.LoginAlerts
	}

	if err := database.DB.Save(&settings).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update security settings"})
		return
	}

	c.JSON(http.StatusOK, settings)
}
