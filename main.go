package main

import (
	"embed"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

//go:embed frontend/index.html
var embeddedIndexHTML embed.FS

func main() {
	router := gin.Default()

	// Handle GET requests to the root path "/"
	// This serves the embedded HTML page.
	router.GET("/", func(c *gin.Context) {
		indexFile, err := embeddedIndexHTML.ReadFile("frontend/index.html")
		if err != nil {
			c.String(http.StatusInternalServerError, "Error loading HTML: %v", err)
			return
		}
		c.Data(http.StatusOK, "text/html; charset=utf-8", indexFile)
	})

	// Handle POST requests to the root path "/"
	// This receives the form data when the button is clicked.
	router.POST("/", func(c *gin.Context) {
		// Get the value of the "userMessage" field from the form data.
		userMessage := c.PostForm("userMessage")

		// Print the received message to the backend console.
		fmt.Printf("Backend received message from form: '%s'\n", userMessage)
	})

	router.Run(":8080")
}
