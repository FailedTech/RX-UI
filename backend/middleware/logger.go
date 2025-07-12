package middleware

import (
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
)

// CustomLogger is a simple Gin middleware that logs request details.
func CustomLogger() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Start timer
		start := time.Now()

		// Process request
		c.Next() // Call the next handler in the chain

		// Calculate response time
		latency := time.Since(start)

		// Log request details
		fmt.Printf("[CustomLogger] %s %s | Status: %d | Latency: %v | ClientIP: %s\n",
			c.Request.Method,
			c.Request.URL.Path,
			c.Writer.Status(),
			latency,
			c.ClientIP(),
		)
	}
}
