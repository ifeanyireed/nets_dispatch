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

	// Orders
	r.GET("/orders", handlers.GetOrders)

	// Transactions
	r.GET("/transactions", handlers.GetTransactions)

	// Auth
	r.POST("/auth/register", handlers.Register)
	r.POST("/auth/login", handlers.Login)
	r.POST("/auth/forgot-password", handlers.ForgotPassword)
	r.POST("/auth/reset-password", handlers.ResetPassword)

	// Email Proxy
	r.POST("/email/send", handlers.SendEmailProxy)

	return r
}
