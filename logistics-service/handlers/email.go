package handlers

import (
	"bytes"
	"encoding/json"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

type EmailRequest struct {
	To       string `json:"to" binding:"required"`
	From     string `json:"from" binding:"required"`
	FromName string `json:"from_name" binding:"required"`
	Subject  string `json:"subject" binding:"required"`
	HTML     string `json:"html"`
	Text     string `json:"text"`
}

func SendEmailProxy(c *gin.Context) {
	var reqBody EmailRequest
	if err := c.ShouldBindJSON(&reqBody); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update this to your live domain if needed
	url := "https://mail.resultspro.ng/email_proxy/api/send-email.php"
	
	jsonPayload, err := json.Marshal(reqBody)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to marshal payload"})
		return
	}
	
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonPayload))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error creating request"})
		return
	}
	
	req.Header.Set("Content-Type", "application/json")
	apiKey := os.Getenv("EMAIL_PROXY_API_KEY")
	if apiKey == "" {
		apiKey = "sk_live_6f3b92d8a4c1e7f50b4a1d9c2e8f7a3b" // Fallback to our generated key
	}
	req.Header.Set("Authorization", "Bearer "+apiKey)
	
	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error sending request to proxy"})
		return
	}
	defer resp.Body.Close()
	
	var proxyResp map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&proxyResp); err != nil {
		c.JSON(resp.StatusCode, gin.H{"error": "Invalid response from proxy"})
		return
	}

	c.JSON(resp.StatusCode, proxyResp)
}
