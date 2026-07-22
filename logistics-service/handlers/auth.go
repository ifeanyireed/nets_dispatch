package handlers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"logistics-service/database"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

type RegisterRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
	Role     string `json:"role" binding:"required"` // agent, vendor, rider
	Name     string `json:"name" binding:"required"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

func Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Validate role
	if req.Role != "agent" && req.Role != "vendor" && req.Role != "rider" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid role"})
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	userId := uuid.New().String()
	user := database.User{
		ID:           userId,
		Email:        req.Email,
		PasswordHash: string(hashedPassword),
		Role:         req.Role,
	}

	// Transaction to create both user and profile
	tx := database.DB.Begin()
	if err := tx.Create(&user).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already registered"})
		return
	}

	profileId := uuid.New().String()
	switch req.Role {
	case "agent":
		agent := database.Agent{ID: profileId, UserID: userId, Name: req.Name}
		if err := tx.Create(&agent).Error; err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create agent profile"})
			return
		}
	case "vendor":
		vendor := database.Vendor{ID: profileId, UserID: userId, Name: req.Name}
		if err := tx.Create(&vendor).Error; err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create vendor profile"})
			return
		}
	case "rider":
		rider := database.Rider{ID: profileId, UserID: userId, Name: req.Name}
		if err := tx.Create(&rider).Error; err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create rider profile"})
			return
		}
	}

	tx.Commit()
	c.JSON(http.StatusCreated, gin.H{"message": "User registered successfully", "userId": userId, "role": req.Role})
}

func Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user database.User
	if err := database.DB.Where("email = ?", req.Email).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// Generate JWT
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "your_fallback_secret_key"
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"userId": user.ID,
		"role":   user.Role,
		"exp":    time.Now().Add(time.Hour * 72).Unix(),
	})

	tokenString, err := token.SignedString([]byte(secret))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	// Fetch Profile based on role
	var profile interface{}
	switch user.Role {
	case "agent":
		var agent database.Agent
		database.DB.Where("user_id = ?", user.ID).First(&agent)
		profile = agent
	case "vendor":
		var vendor database.Vendor
		database.DB.Where("user_id = ?", user.ID).First(&vendor)
		profile = vendor
	case "rider":
		var rider database.Rider
		database.DB.Where("user_id = ?", user.ID).First(&rider)
		profile = rider
	}

	c.JSON(http.StatusOK, gin.H{
		"token": tokenString,
		"user": map[string]interface{}{
			"id":    user.ID,
			"email": user.Email,
			"role":  user.Role,
		},
		"profile": profile,
	})
}

type ForgotPasswordRequest struct {
	Email string `json:"email" binding:"required,email"`
}

type ResetPasswordRequest struct {
	Token       string `json:"token" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required,min=6"`
}

func ForgotPassword(c *gin.Context) {
	var req ForgotPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var user database.User
	if err := database.DB.Where("email = ?", req.Email).First(&user).Error; err != nil {
		// Always return OK to prevent email enumeration
		c.JSON(http.StatusOK, gin.H{"message": "If that email is in our database, we will send a password reset link."})
		return
	}

	// Generate reset token (valid for 30 minutes)
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "your_fallback_secret_key"
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"userId":  user.ID,
		"purpose": "password_reset",
		"exp":     time.Now().Add(time.Minute * 30).Unix(),
	})
	tokenString, _ := token.SignedString([]byte(secret))

	resetLink := fmt.Sprintf("https://netslogistics.com/reset-password?token=%s", tokenString)
	htmlBody := fmt.Sprintf("<h2>Password Reset</h2><p>Click <a href='%s'>here</a> to reset your password. This link expires in 30 minutes.</p>", resetLink)

	// Call email proxy
	proxyReq := map[string]string{
		"to":        user.Email,
		"from":      "hello@netslogistics.com",
		"from_name": "Nets Logistics",
		"subject":   "Password Reset Instructions",
		"html":      htmlBody,
	}

	jsonPayload, _ := json.Marshal(proxyReq)
	reqHttp, _ := http.NewRequest("POST", "https://mail.resultspro.ng/email_proxy/api/send-email.php", bytes.NewBuffer(jsonPayload))
	reqHttp.Header.Set("Content-Type", "application/json")
	apiKey := os.Getenv("EMAIL_PROXY_API_KEY")
	if apiKey == "" {
		apiKey = "sk_live_6f3b92d8a4c1e7f50b4a1d9c2e8f7a3b"
	}
	reqHttp.Header.Set("Authorization", "Bearer "+apiKey)

	client := &http.Client{}
	go client.Do(reqHttp) // Send asynchronously so we don't block the response

	c.JSON(http.StatusOK, gin.H{"message": "If that email is in our database, we will send a password reset link."})
}

func ResetPassword(c *gin.Context) {
	var req ResetPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "your_fallback_secret_key"
	}

	token, err := jwt.Parse(req.Token, func(token *jwt.Token) (interface{}, error) {
		return []byte(secret), nil
	})

	if err != nil || !token.Valid {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid or expired token"})
		return
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || claims["purpose"] != "password_reset" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid token purpose"})
		return
	}

	userId := claims["userId"].(string)

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	if err := database.DB.Model(&database.User{}).Where("id = ?", userId).Update("password_hash", string(hashedPassword)).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to reset password"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Password has been successfully reset"})
}
