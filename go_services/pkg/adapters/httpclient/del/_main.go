package main

import (
	"fmt"
	"go_services/pkg/adapters/httpclient"
    "time"
    _ "go_services/pkg/logger"
)

func main() {
	client := httpclient.New("http://localhost:3000", 5*time.Second)

	data, err := client.Tariffs()
    // data, err := client.GetInd(3, "2025-08-14")
    // data, err := client.GetInds("2025-08-14")
    // data, err := client.GetUser(3)
    // data, err := client.CompleteReceipt(1)
	if err != nil {
		panic(err)
	}
	fmt.Println(string(data))
}
