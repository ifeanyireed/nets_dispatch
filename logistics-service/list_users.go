package main

import (
	"fmt"
	"logistics-service/database"
)

func main() {
	database.ConnectDB()
	var users []database.User
	database.DB.Find(&users)
	for _, u := range users {
		fmt.Printf("User: ID=%s, Email=%s, Role=%s\n", u.ID, u.Email, u.Role)
	}
}
