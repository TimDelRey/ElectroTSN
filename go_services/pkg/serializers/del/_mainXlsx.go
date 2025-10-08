package main

import (
    "fmt"
    "io"
    "go_services/pkg/serializers"
    "go_services/pkg/adapters/s3"
    "log"

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

	key := "jdg25k91h1n3s9jpbql7zclaujp8"
	contentType := "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

	// загрузка с облака

	downloaded, err := client.DownloadFile(key, contentType)
	if err != nil {
		log.Fatal("Download failed:", err)
	}

	defer downloaded.Body.Close()

    // парсинг в стракт
    data, err := io.ReadAll(downloaded.Body)
    if err != nil {
		log.Fatal("Reading file is failed:", err)
	}
    calc, err := serializers.ParsPersonCalcXls(data)
    if err != nil {
		log.Fatal("Parsing is failed:", err)
	}
    fmt.Println(calc)
}
