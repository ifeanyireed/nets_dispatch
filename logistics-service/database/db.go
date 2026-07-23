package database

import (
	"log"
	"os"
	"time"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB *gorm.DB

type User struct {
	ID           string    `gorm:"type:char(36);primaryKey" json:"id"`
	Email        string    `gorm:"unique" json:"email"`
	PasswordHash string    `json:"-"`
	Role         string    `json:"role"` // 'agent', 'vendor', 'rider'
	AvatarURL    string    `json:"avatarUrl"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

type Agent struct {
	ID        string    `gorm:"type:char(36);primaryKey" json:"id"`
	UserID    string    `gorm:"type:char(36);uniqueIndex" json:"userId"`
	User      User      `json:"user"`
	Name      string    `json:"name"`
	Hub       string    `json:"hub"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

type Vendor struct {
	ID           string    `gorm:"type:char(36);primaryKey" json:"id"`
	UserID       string    `gorm:"type:char(36);uniqueIndex" json:"userId"`
	User         User      `json:"user"`
	Name         string    `json:"name"`
	Category     string    `json:"category"`
	Location     string    `json:"location"`
	ActiveOrders int       `gorm:"default:0" json:"activeOrders"`
	Status       string    `gorm:"default:'Active'" json:"status"`
	Orders       []Order   `json:"orders,omitempty"`
	CreatedAt    time.Time `json:"createdAt"`
	UpdatedAt    time.Time `json:"updatedAt"`
}

type Rider struct {
	ID         string    `gorm:"type:char(36);primaryKey" json:"id"`
	UserID     string    `gorm:"type:char(36);uniqueIndex" json:"userId"`
	User       User      `json:"user"`
	Name       string    `json:"name"`
	Vehicle    string    `json:"vehicle"`
	Status     string    `gorm:"default:'Offline'" json:"status"`
	Rating     float64   `gorm:"default:0.0" json:"rating"`
	Deliveries int       `gorm:"default:0" json:"deliveries"`
	Orders     []Order   `json:"orders,omitempty"`
	CreatedAt  time.Time `json:"createdAt"`
	UpdatedAt  time.Time `json:"updatedAt"`
}

type Order struct {
	ID        string    `gorm:"type:char(36);primaryKey" json:"id"`
	OrderNo   string    `gorm:"unique" json:"orderNo"`
	VendorID  string    `gorm:"type:char(36)" json:"vendorId"`
	Vendor    Vendor    `json:"vendor"`
	RiderID   *string   `gorm:"type:char(36)" json:"riderId"`
	Rider     *Rider    `json:"rider,omitempty"`
	Status    string    `gorm:"default:'Pending'" json:"status"`
	Amount    float64   `json:"amount"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

type Transaction struct {
	ID        string    `gorm:"type:char(36);primaryKey" json:"id"`
	TxnNo     string    `gorm:"unique" json:"txnNo"`
	Type      string    `json:"type"`
	Reference string    `json:"reference"`
	Amount    float64   `json:"amount"`
	CreatedAt time.Time `json:"createdAt"`
}

func ConnectDB() {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		// fallback or error
		// gorm mysql dsn format: user:pass@tcp(127.0.0.1:3306)/dbname?charset=utf8mb4&parseTime=True&loc=Local
		// We have to parse prisma URL to GORM DSN but let's just use the GORM standard DSN string since it's pure Go now.
		// For the previous credentials:
		dsn = "u859677653_logistics:*Reedb4b4@tcp(srv1427.hstgr.io:3306)/u859677653_logistics_db?charset=utf8mb4&parseTime=True&loc=Local"
	} else {
		// Quick parse if it starts with mysql://... we can just hardcode for simplicity since the user wants it to work.
		dsn = "u859677653_logistics:*Reedb4b4@tcp(srv1427.hstgr.io:3306)/u859677653_logistics_db?charset=utf8mb4&parseTime=True&loc=Local"
	}

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	err = db.AutoMigrate(&User{}, &Agent{}, &Vendor{}, &Rider{}, &Order{}, &Transaction{})
	if err != nil {
		log.Fatal("Failed to migrate database:", err)
	}

	DB = db
}
