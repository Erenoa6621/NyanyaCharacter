package main

import (
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// createMux sets up the Echo router with middleware
func createMux() *echo.Echo {
	e := echo.New()

	// Middleware
	e.Use(middleware.Recover())
	e.Use(middleware.Logger())
	e.Use(middleware.Gzip())

	// CORS (allow all for now, adjust as needed)
	e.Use(middleware.CORS())

	return e
}

func main() {
	// Initialize Echo router
	e := createMux()

	// Versioned API group
	aPI := e.Group("/api/v1")
	// /api/v1/testing
	aPI.GET("/testing", func(c echo.Context) error {
		return c.String(http.StatusOK, "OK")
	})

	// Start server
	log.Println("[Ionia API] started on :8080")
	if err := e.Start(":8080"); err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}
}
