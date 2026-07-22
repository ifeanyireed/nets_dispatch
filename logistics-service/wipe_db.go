package main

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"logistics-service/database"
	"logistics-service/handlers"

	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(".env"); err != nil {
		log.Println("No .env file found")
	}

	dsn := "u859677653_logistics:*Reedb4b4@tcp(srv1427.hstgr.io:3306)/u859677653_logistics_db?charset=utf8mb4&parseTime=True&loc=Local"
	if envDsn := os.Getenv("DATABASE_URL"); envDsn != "" {
		// Just hardcode since we know it
	}
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	fmt.Println("Wiping all existing tables...")
	db.Exec("SET FOREIGN_KEY_CHECKS = 0;")
	
	// Drop old Prisma tables
	db.Exec("DROP TABLE IF EXISTS `Transaction`;")
	db.Exec("DROP TABLE IF EXISTS `Order`;")
	db.Exec("DROP TABLE IF EXISTS `Rider`;")
	db.Exec("DROP TABLE IF EXISTS `Vendor`;")
	db.Exec("DROP TABLE IF EXISTS `_prisma_migrations`;")

	// Drop GORM tables
	db.Exec("DROP TABLE IF EXISTS `transactions`;")
	db.Exec("DROP TABLE IF EXISTS `orders`;")
	db.Exec("DROP TABLE IF EXISTS `riders`;")
	db.Exec("DROP TABLE IF EXISTS `vendors`;")

	db.Exec("SET FOREIGN_KEY_CHECKS = 1;")
	fmt.Println("Tables wiped.")

	fmt.Println("Re-initializing tables via GORM...")
	// We can safely call ConnectDB to run AutoMigrate now
	database.ConnectDB()

	fmt.Println("Re-seeding database...")
	if err := handlers.SeedData(); err != nil {
		log.Fatal("Seed failed: ", err)
	}

	fmt.Println("Database wiped and successfully re-initialized!")
}
