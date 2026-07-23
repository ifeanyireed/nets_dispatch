package handlers

import (
	"logistics-service/database"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

func SeedData() error {
	db := database.DB

	// Clear existing data
	db.Exec("DELETE FROM transactions")
	db.Exec("DELETE FROM orders")
	db.Exec("DELETE FROM vendors")
	db.Exec("DELETE FROM riders")
	db.Exec("DELETE FROM agents")
	db.Exec("DELETE FROM users")

	passwordHash, _ := bcrypt.GenerateFromPassword([]byte("password123"), bcrypt.DefaultCost)
	hash := string(passwordHash)

	// Users
	uAgent := database.User{ID: uuid.New().String(), Email: "agent@nets.com", PasswordHash: hash, Role: "agent"}
	uVendor := database.User{ID: uuid.New().String(), Email: "vendor@nets.com", PasswordHash: hash, Role: "vendor"}
	uRider := database.User{ID: uuid.New().String(), Email: "rider@nets.com", PasswordHash: hash, Role: "rider"}

	if err := db.Create(&uAgent).Error; err != nil { return err }
	if err := db.Create(&uVendor).Error; err != nil { return err }
	if err := db.Create(&uRider).Error; err != nil { return err }

	// Create Agent
	a1 := database.Agent{
		ID:     uuid.New().String(),
		UserID: uAgent.ID,
		Name:   "Dispatcher Mike",
		Hub:    "Lagos Main Hub",
	}
	if err := db.Create(&a1).Error; err != nil { return err }

	// Create Vendors
	v1 := database.Vendor{
		ID:           uuid.New().String(),
		UserID:       uVendor.ID,
		Name:         "Chicken Republic",
		Category:     "Restaurant",
		Location:     "Lekki Phase 1",
		ActiveOrders: 24,
		Status:       "Active",
	}
	if err := db.Create(&v1).Error; err != nil { return err }

	// Create Riders
	r1 := database.Rider{
		ID:         uuid.New().String(),
		UserID:     uRider.ID,
		Name:       "Ade Ogundele",
		Vehicle:    "Bike",
		Status:     "Active",
		Rating:     4.9,
		Deliveries: 1204,
	}
	if err := db.Create(&r1).Error; err != nil { return err }

	uNewRider := database.User{ID: uuid.New().String(), Email: "newrider@nets.com", PasswordHash: hash, Role: "rider"}
	if err := db.Create(&uNewRider).Error; err != nil { return err }

	r2 := database.Rider{
		ID:         uuid.New().String(),
		UserID:     uNewRider.ID,
		Name:       "John Doe",
		Vehicle:    "Car",
		Status:     "Pending",
		Rating:     0.0,
		Deliveries: 0,
	}
	if err := db.Create(&r2).Error; err != nil { return err }

	// Create Orders
	o1 := database.Order{
		ID:       uuid.New().String(),
		OrderNo:  "NLG-88231",
		VendorID: v1.ID,
		RiderID:  &r1.ID,
		Amount:   2400,
		Status:   "In transit",
	}
	if err := db.Create(&o1).Error; err != nil { return err }

	// Create Transactions
	t1 := database.Transaction{
		ID:        uuid.New().String(),
		TxnNo:     "TXN-9021",
		Type:      "Order Revenue",
		Reference: "NLG-88231",
		Amount:    2400,
	}
	if err := db.Create(&t1).Error; err != nil { return err }

	return nil
}
