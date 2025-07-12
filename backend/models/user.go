package models

// User represents the structure for user data.
// This struct is used for both incoming request binding and database operations.
type User struct {
	ID    string `json:"id,omitempty"` // omitempty means it won't be in JSON if empty
	Name  string `json:"name" binding:"required"`
	Email string `json:"email" binding:"required,email"`
	Age   int    `json:"age" binding:"gte=0,lte=130"`
}
