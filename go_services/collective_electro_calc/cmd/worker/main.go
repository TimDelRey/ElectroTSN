package main

import (
	"fmt"
	"go_services/pkg/adapters/s3"
	"log"
	"os"
)

func main() {
	client, err := s3.NewClient()
	if err != nil {
		log.Fatal(err)
	}

	file, err := os.Open("/workspaces/ElectroTSN/spec/fixtures/files/08_august.xls")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	key := "cjg0knryvqgfsa8y3ly88bfs9cxd"
	contentType := "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

	if err := client.UploadFile(key, file, contentType); err != nil {
		log.Fatal("Upload failed:", err)
	}

	fmt.Println("Upload successful!")
}
