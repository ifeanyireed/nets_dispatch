package routes

import (
	"logistics-service/handlers"
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// Enable CORS
	r.Use(cors.Default())

	// Seed endpoint
	r.POST("/seed", handlers.SeedDatabase)

	// Vendors
	r.GET("/vendors", handlers.GetVendors)

	// Riders
	r.GET("/riders", handlers.GetRiders)
	r.PATCH("/riders/:id/status", handlers.UpdateRiderStatus)
	r.GET("/riders/profile/:userId", handlers.GetRiderProfile)
	r.DELETE("/riders/:id", handlers.DeleteRider)

	// Orders
	r.GET("/orders", handlers.GetOrders)

	// Transactions
	r.GET("/transactions", handlers.GetTransactions)

	// Auth
	r.POST("/auth/register", handlers.Register)
	r.POST("/auth/login", handlers.Login)
	r.POST("/auth/forgot-password", handlers.ForgotPassword)
	r.POST("/auth/reset-password", handlers.ResetPassword)

	// Users
	r.PATCH("/users/:id/avatar", handlers.UpdateAvatar)
	r.GET("/users/:userId/addresses", handlers.GetAddresses)
	r.POST("/users/:userId/addresses", handlers.CreateAddress)
	r.PATCH("/addresses/:id", handlers.UpdateAddress)
	r.DELETE("/addresses/:id", handlers.DeleteAddress)
	
	// Security Settings
	r.GET("/users/:userId/security", handlers.GetSecuritySettings)
	r.PATCH("/users/:userId/security", handlers.UpdateSecuritySettings)
	
	// Wallet
	r.GET("/users/:userId/wallet", handlers.GetWallet)
	r.POST("/users/:userId/payout", handlers.RequestPayout)

	// Upload
	r.POST("/upload", handlers.Upload)

	// Email Proxy
	r.POST("/email/send", handlers.SendEmailProxy)

	// Notifications & Settings
	r.GET("/users/:userId/notifications", handlers.GetNotifications)
	r.PATCH("/notifications/:id/read", handlers.MarkNotificationRead)
	r.GET("/users/:userId/settings/notifications", handlers.GetNotificationSettings)
	r.PATCH("/users/:userId/settings/notifications", handlers.UpdateNotificationSettings)

	return r
}
