package main

import (
	"fmt"
	"log"
	"logistics-service/database"
	"logistics-service/handlers"

	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(".env"); err != nil {
		log.Println("No .env file found")
	}
	database.ConnectDB()

	if err := handlers.SeedData(); err != nil {
		log.Fatal("Seed failed: ", err)
	}
	fmt.Println("Seeding completed successfully")
}
