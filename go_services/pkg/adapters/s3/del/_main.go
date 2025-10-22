package main

import (
	"fmt"
	"go_services/pkg/adapters/s3"
	"log"
	"os"
	"io"

	"github.com/joho/godotenv"
)

func init() {
	_ = godotenv.Load("/workspaces/ElectroTSN/.env")
}

func main() {
	client, err := s3.NewClient()
	if err != nil {
		log.Fatal(err)
	}

	// загрузка на облако

	uploadFile, err := os.Open("/workspaces/ElectroTSN/spec/fixtures/files/person_calc.xlsx")
	if err != nil {
		log.Fatal(err)
	}
	defer uploadFile.Close()

	key := "jdg25k91h1n3s9jpbql7zclaujp8"
	contentType := "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

	if err := client.UploadFile(key, uploadFile, contentType); err != nil {
		log.Fatal("Upload failed:", err)
	}

	fmt.Println("Upload successful!")

	// загрузка с облака

	downloaded, err := client.DownloadFile(key, contentType)
	if err != nil {
		log.Fatal("Download failed:", err)
	}

	defer downloaded.Body.Close()

	downloadFile, err := os.Create("/workspaces/ElectroTSN/spec/fixtures/files/downloadedFile.xlsx")

	if err != nil {
		log.Fatal("Creating file is failed:", err)
	}
	defer downloadFile.Close()

	_, err = io.Copy(downloadFile, downloaded.Body)
	if err != nil {
		log.Fatal("Coppying is failed:", err)
	}
	fmt.Println("Good")
}
