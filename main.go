package main

import (
	"embed" // Import the embed package
	"fmt"
	"io/fs"    // For filesystem interfaces like fs.FS
	"net/http" // For HTTP status codes and http.Dir

	"github.com/gin-gonic/gin"
)

// This directive tells Go to embed the contents of the 'frontend/dist' directory
// into the 'embeddedFS' variable at compile time.
// The '/*' ensures that all files and subdirectories within 'dist' are included.
//
//go:embed frontend/dist/*
var embeddedFS embed.FS

func main() {
	router := gin.Default()

	// Create a sub-filesystem from the embedded content.
	// This is important because 'frontend/dist' is the root of the embedded files,
	// but we want to serve them from the web root '/'.
	// fs.Sub effectively strips the 'frontend/dist' prefix from the paths.
	distFS, err := fs.Sub(embeddedFS, "frontend/dist")
	if err != nil {
		// If there's an error creating the sub-filesystem, log it and exit.
		// This usually indicates a problem with the embed path.
		fmt.Printf("Error creating sub-filesystem from embedded content: %v\n", err)
		return
	}

	// Serve the embedded 'dist' directory as static files.
	// Now, Gin will serve files directly from the compiled binary,
	// using the 'distFS' (which is the 'frontend/dist' content).
	router.StaticFS("/", http.FS(distFS))

	// Run the Gin server on port 8080.
	fmt.Println("RX-UI Gin server starting on http://localhost:8080")
	fmt.Println("To see the Vue app, first run 'bun run build' in the 'frontend/' directory.")
	fmt.Println("Then, compile your Go app: 'go build -o rx-ui.exe' (or just 'go build').")
	fmt.Println("Finally, run the compiled executable: './rx-ui.exe' (or 'rx-ui.exe').")
	fmt.Println("Access your application at http://localhost:8080 in your browser.")
	if err := router.Run(":8080"); err != nil {
		fmt.Printf("Error starting server: %v\n", err)
	}
}
