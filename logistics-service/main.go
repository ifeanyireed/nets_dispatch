package main

import (
	"log"
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
	
	log.Println("Server running on port 8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatal(err)
	}
}
