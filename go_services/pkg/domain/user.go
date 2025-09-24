package domain

type User struct {
    ID          int    `json:"id"`
    FirstName   string `json:"first_name`
    Name        string `json:"name`
    LastName    string `json:"last_name"`
    PlaceNumber int    `json:"place_number"`
    Tariff      string `json:"tariff"`
}
