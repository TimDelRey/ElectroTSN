package main

import (
	"fmt"
    "time"

    "go_services/pkg/httpclient"
    "go_services/pkg/domain"
)

func main() {
    client := httpclient.New("http://localhost:3000", 5*time.Second)
	// netData, err := client.GetUser(2)
    // netData, err := client.GetInd(2, "2025-08-14")
    netData, err := client.Tariffs()
    if err != nil {
		panic(err)
	}
	// data, err := domain.ParsFunc[domain.User](netData)
    // data, err := domain.ParsFunc[domain.Indication](netData)
    data, err := domain.ParsFunc[domain.Tariff](netData)
	if err != nil {
		panic(err)
	}
	fmt.Println(data)
    // fmt.Println(data[1].UserId)
    // fmt.Println(*data[1].DayData)

    // fmt.Println(data[0].ID)
    // fmt.Println(*data[0].FirstValue)
    // fmt.Println(*data[0].SecondValue)
    // fmt.Println(*data[0].ThirdValue)

    dataMonth, err := client.GetInds("2025-08-14")
    if err != nil {
		panic(err)
	}
    month, err := domain.ParsMothColl(dataMonth)
	if err != nil {
		panic(err)
	}
	fmt.Println(month)
    fmt.Println(month["2"][0].Month)
    fmt.Println(*month["2"][0].DayData)
}
