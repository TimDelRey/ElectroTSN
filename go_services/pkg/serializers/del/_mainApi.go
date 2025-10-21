package main

import (
	"fmt"
    "time"

    "go_services/pkg/adapters/httpclient"
    "go_services/pkg/serializers"
    "go_services/pkg/domain"
)

func main() {
    client := httpclient.New("http://localhost:3000", 5*time.Second)
    // тариф
    // netData, err := client.Tariffs()
    // if err != nil {
	// 	panic(err)
	// }
    // data, err := serializers.ParsApi[domain.Tariff](netData)
	// if err != nil {
	// 	panic(err)
	// }
    // fmt.Println(data[0].FirstValue)
    // fmt.Println(data[0].SecondValue)
    // fmt.Println(data[0].ThirdValue)

    // юзер
	// netData, err := client.GetUser(3)
    // if err != nil {
	// 	panic(err)
	// }
    // data, err := serializers.ParsApi[domain.User](netData)
    // if err != nil {
	// 	panic(err)
	// }
    // fmt.Println(data[0].LastName)

    // инидикация
    netData, err := client.GetInd(3, "2025-08-14")
    if err != nil {
		panic(err)
	}
    data, err := serializers.ParsApi[domain.Indication](netData)
    if err != nil {
		panic(err)
	}
    fmt.Println(data[0].AllDayData)

    // коллективные квитанции (пока не использовать)
    // dataMonth, err := client.GetInds("2025-08-14")
    // if err != nil {
	// 	panic(err)
	// }
    // month, err := serializers.ParsApiMothColl(dataMonth)
	// if err != nil {
	// 	panic(err)
	// }
	// fmt.Println(month)
    // fmt.Println(month["2"][0].Month)
    // fmt.Println(*month["2"][0].DayData)
}
