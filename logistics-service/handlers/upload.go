package handlers

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

// Upload handles file uploads via SFTP to Hostinger
func Upload(c *gin.Context) {
	// Parse the multipart form
	file, err := c.FormFile("file")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "No file provided"})
		return
	}

	// Open the uploaded file
	srcFile, err := file.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not read file"})
		return
	}
	defer srcFile.Close()

	// Generate a unique filename
	ext := filepath.Ext(file.Filename)
	filename := fmt.Sprintf("%d%s", time.Now().UnixNano(), ext)

	// Fetch SFTP config from environment
	host := os.Getenv("SFTP_HOST")
	port := os.Getenv("SFTP_PORT")
	user := os.Getenv("SFTP_USER")
	remoteDir := os.Getenv("SFTP_REMOTE_DIR")
	baseURL := os.Getenv("SFTP_BASE_URL")
	keyPath := os.Getenv("SFTP_KEY_PATH")
	passphrase := os.Getenv("SFTP_KEY_PASSPHRASE")
	password := os.Getenv("SFTP_PASS")

	var authMethods []ssh.AuthMethod

	// 1. Try Key-Based Authentication first
	if keyPath != "" {
		key, err := os.ReadFile(keyPath)
		if err == nil {
			var signer ssh.Signer
			if passphrase != "" {
				signer, err = ssh.ParsePrivateKeyWithPassphrase(key, []byte(passphrase))
			} else {
				signer, err = ssh.ParsePrivateKey(key)
			}
			
			if err == nil {
				authMethods = append(authMethods, ssh.PublicKeys(signer))
			} else {
				log.Printf("Failed to parse private key: %v", err)
			}
		} else {
			log.Printf("Failed to read private key at %s: %v", keyPath, err)
		}
	}

	// 2. Try Password Authentication as fallback
	if password != "" {
		authMethods = append(authMethods, ssh.Password(password))
	}

	if len(authMethods) == 0 {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "No valid authentication methods available for SFTP"})
		return
	}

	config := &ssh.ClientConfig{
		User:            user,
		Auth:            authMethods,
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), // Use insecure for now, avoid known_hosts issues
		Timeout:         10 * time.Second,
	}

	// Connect to SSH
	addr := fmt.Sprintf("%s:%s", host, port)
	conn, err := ssh.Dial("tcp", addr, config)
	if err != nil {
		log.Printf("Failed to dial SSH: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to connect to upload server"})
		return
	}
	defer conn.Close()

	// Open SFTP session
	client, err := sftp.NewClient(conn)
	if err != nil {
		log.Printf("Failed to create SFTP client: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to open SFTP session"})
		return
	}
	defer client.Close()

	// Ensure remote directory exists (optional, assuming it already exists)
	// client.MkdirAll(remoteDir)

	// Create remote file
	remotePath := filepath.Join(remoteDir, filename)
	// Make sure to use forward slashes for remote path
	remotePath = filepath.ToSlash(remotePath)
	
	dstFile, err := client.Create(remotePath)
	if err != nil {
		log.Printf("Failed to create remote file: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create remote file"})
		return
	}
	defer dstFile.Close()

	// Copy file contents
	if _, err := io.Copy(dstFile, srcFile); err != nil {
		log.Printf("Failed to upload file: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to upload file contents"})
		return
	}

	// Construct public URL
	publicURL := fmt.Sprintf("%s/%s", baseURL, filename)

	c.JSON(http.StatusOK, gin.H{
		"message": "File uploaded successfully",
		"url":     publicURL,
	})
}
