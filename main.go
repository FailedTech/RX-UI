package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"

	// Import packages from our new backend structure
	"RX-UI/backend/database"
	"RX-UI/backend/middleware"
	"RX-UI/backend/routes"
)

func main() {
	// Initialize Gin router with default middleware (Logger and Recovery)
	router := gin.Default()

	// --- Frontend Setup ---
	// Load HTML templates from the new frontend/templates directory
	router.LoadHTMLGlob("frontend/templates/*")

	// Serve static files from the new frontend/static directory
	router.Static("/static", "./frontend/static")

	// Serve the main HTML page
	router.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{
			"title":   "Refactored Gin App",
			"message": "Welcome to the Refactored Gin Test App!",
			"year":    time.Now().Year(),
		})
	})

	// --- Backend Setup ---
	// Initialize database (simulated)
	database.InitDB()

	// Apply global middleware (example: custom logger)
	router.Use(middleware.CustomLogger())

	// Group API routes under /api
	apiGroup := router.Group("/api")
	{
		// Register API routes from the routes package
		routes.RegisterAPIRoutes(apiGroup)
	}

	// Run the Gin server
	fmt.Println("Refactored Gin server starting on http://localhost:8080")
	if err := router.Run(":8080"); err != nil {
		fmt.Printf("Error starting server: %v\n", err)
	}
}
