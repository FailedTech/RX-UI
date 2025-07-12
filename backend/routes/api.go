package routes

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"

	"RX-UI/backend/database" // Import our simulated database functions
	"RX-UI/backend/models"   // Import our User model
)

// RegisterAPIRoutes sets up all the API endpoints.
// It takes a *gin.RouterGroup as an argument, allowing it to register
// routes under a specific prefix (e.g., /api).
func RegisterAPIRoutes(rg *gin.RouterGroup) {
	// GET /api/hello: A simple API endpoint that returns JSON.
	rg.GET("/hello", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":    "success",
			"message":   "Hello from Gin API (Refactored)!",
			"timestamp": time.Now().Format(time.RFC3339),
		})
	})

	// POST /api/submit: Accepts JSON data, validates it, and responds.
	rg.POST("/submit", func(c *gin.Context) {
		var user models.User // Use the User struct from the models package

		// Bind and validate the JSON request body.
		if err := c.ShouldBindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Simulate saving the user to the database
		if err := database.SaveUser(user); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save user"})
			return
		}

		// Respond with success
		c.JSON(http.StatusOK, gin.H{
			"status":  "success",
			"message": "User data received and simulated save successfully!",
			"data":    user,
		})
	})

	// GET /api/user/:id: Example of a route with a path parameter.
	rg.GET("/user/:id", func(c *gin.Context) {
		userID := c.Param("id") // Get the 'id' from the URL path

		// Simulate fetching user from the database
		user, err := database.GetUserByID(userID)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
			return
		}

		c.JSON(http.StatusOK, gin.H{
			"status":  "success",
			"message": fmt.Sprintf("User %s found", userID),
			"data":    user,
		})
	})
}
