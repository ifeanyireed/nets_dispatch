package handlers

import (
	"logistics-service/database"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// Get user notifications
func GetNotifications(c *gin.Context) {
	userId := c.Param("userId")

	var notifications []database.Notification
	if err := database.DB.Where("user_id = ?", userId).Order("created_at desc").Find(&notifications).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch notifications"})
		return
	}

	c.JSON(http.StatusOK, notifications)
}

// Mark notification as read
func MarkNotificationRead(c *gin.Context) {
	notifId := c.Param("id")

	if err := database.DB.Model(&database.Notification{}).Where("id = ?", notifId).Update("is_read", true).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update notification"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Notification marked as read"})
}

// Get user notification settings
func GetNotificationSettings(c *gin.Context) {
	userId := c.Param("userId")

	var settings database.NotificationSetting
	result := database.DB.Where("user_id = ?", userId).First(&settings)
	
	if result.Error != nil {
		// If not found, return default settings
		settings = database.NotificationSetting{
			UserID:       userId,
			PushEnabled:  true,
			EmailEnabled: true,
			OrderUpdates: true,
			Promotions:   false,
			SystemAlerts: true,
		}
	}

	c.JSON(http.StatusOK, settings)
}

// Update user notification settings
func UpdateNotificationSettings(c *gin.Context) {
	userId := c.Param("userId")

	var req database.NotificationSetting
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}
	req.UserID = userId

	if err := database.DB.Save(&req).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save settings"})
		return
	}

	c.JSON(http.StatusOK, req)
}

// Helper to create and send a notification (Internal use)
func SendNotification(userId, title, message, notifType string) error {
	notif := database.Notification{
		ID:      uuid.New().String(),
		UserID:  userId,
		Title:   title,
		Message: message,
		Type:    notifType,
		IsRead:  false,
	}

	if err := database.DB.Create(&notif).Error; err != nil {
		return err
	}

	// Fetch user settings to check if push is enabled
	var settings database.NotificationSetting
	if err := database.DB.Where("user_id = ?", userId).First(&settings).Error; err == nil {
		if settings.PushEnabled && settings.PushToken != "" {
			// TODO: Actually send push notification via FCM / OneSignal here.
			// This is where you would call your push provider's API.
			_ = settings.PushToken 
		}
	}

	return nil
}
