package main

import (
	"log"
	"os"
	"logistics-service/database"
	"logistics-service/routes"
	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	// Connect to GORM DB
	database.ConnectDB()

	r := routes.SetupRouter()
	
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	
	log.Printf("Server running on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatal(err)
	}
}
