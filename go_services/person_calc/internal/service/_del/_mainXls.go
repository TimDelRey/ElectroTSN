package main

import (
    "os"
    "io"
    "fmt"

    "go_services/pkg/domain"
    "go_services/pkg/calculator"
    "person_calc/internal/service"
    
    "github.com/joho/godotenv"
)

func init() {
	_ = godotenv.Load("/workspaces/ElectroTSN/.env")
}

var (
    singleCalc = domain.PersonCalc {
        PlaceNumber: 26,
        FullName:    "Михайленко С.Г.",

        Single: &domain.SingleZone {
            Tariff: domain.TariffCalc {
                TariffName: "Тариф 1",
                CurrentInd: 39062.50,
                LastInd:    38823.50,
                Step1Price: 5.05,
                Step2Price: 5.47,
                Step3Price: 9.40,
            },
        },
    }
    duoCalc = domain.PersonCalc {
        PlaceNumber: 18,
        FullName:    "Ким Тимур Владимирович",

        Duo: &domain.DuoCalc {
            T1: domain.TariffCalc {
                TariffName: "День Т1",
                CurrentInd: 14438.65,
                LastInd:    13574.52,
                Step1Price: 5.05,
                Step2Price: 5.47,
                Step3Price: 9.40,
            },
            T2: domain.TariffCalc {
                TariffName: "Ночь Т1",
                CurrentInd: 4132.30,
                LastInd:    3885.21,
                Step1Price: 3.52,
                Step2Price: 4.21,
                Step3Price: 6.99,
            },
        },
    }
)

func main() {
    // генерация domain.PersonCalc
    if err := calculator.SingleZone(&singleCalc); err != nil {
        panic(err)
    }
    if err := calculator.DuoZone(&duoCalc); err != nil {
        panic(err)
    }

    // генерация файла xlsx
    singleXlsx, err := service.NewSingleCalcXlsx(singleCalc)
    if err != nil {
        panic(err)
    }
    singleFile, err := os.Create("/workspaces/ElectroTSN/spec/fixtures/files/singleFile.xlsx")
    defer singleFile.Close()
    _, err = io.Copy(singleFile, singleXlsx)
    if err != nil {
        panic(err)
    }
    fmt.Println("Good single")

    duoXlsx, err := service.NewDuoCalcXlsx(duoCalc)
    if err != nil {
        panic(err)
    }
    duoFile, err := os.Create("/workspaces/ElectroTSN/spec/fixtures/files/duoFile.xlsx")
    defer duoFile.Close()
    _, err = io.Copy(duoFile, duoXlsx)
    if err != nil {
        panic(err)
    }
    fmt.Println("Good duo")
}
