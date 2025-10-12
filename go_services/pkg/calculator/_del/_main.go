package main

import (
    "go_services/pkg/domain"
    "go_services/pkg/calculator"

    "github.com/cheynewallace/tabby"
    "github.com/joho/godotenv"
)

func init() {
	_ = godotenv.Load("/workspaces/ElectroTSN/.env")
}

var (
    singleData = domain.PersonCalc {
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
    duoData = domain.PersonCalc {
        PlaceNumber: 18,
        FullName:    "Ким Тимур Владимирович",

        Duo: &domain.DuoCalc {
            T1: domain.TariffCalc {
                TariffName: "Дневной Т1",
                CurrentInd: 14438.65,
                LastInd:    13574.52,
                Step1Price: 5.05,
                Step2Price: 5.47,
                Step3Price: 9.40,
            },
            T2: domain.TariffCalc {
                TariffName: "Ночной Т1",
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
    // SingleZone(p domain.PersonCalc) (domain.PersonCalcResult, error)
    if err := calculator.DuoZone(&duoData); err != nil {
        panic(err)
    }
    if err := calculator.SingleZone(&singleData); err != nil {
        panic(err)
    }

    t1 := tabby.New()
    t1.AddHeader("Уч.",
        "Потр.",
        "Тариф",
        "Тек.",
        "Пред.",
        "Расход",
        "Р1",
        "Р2",
        "Р3",
        "Ц1",
        "Ц2",
        "Ц3",
        "Н1",
        "Н2",
        "Н3",
        "Сумма",
    )
        t1.AddLine(
        singleData.PlaceNumber,
        singleData.FullName,
        singleData.Single.Tariff.TariffName,
        singleData.Single.Tariff.CurrentInd,
        singleData.Single.Tariff.LastInd,
        singleData.Single.Tariff.DifValue,
        singleData.Single.Tariff.Step1Calc,
        singleData.Single.Tariff.Step2Calc,
        singleData.Single.Tariff.Step3Calc,
        singleData.Single.Tariff.Step1Price,
        singleData.Single.Tariff.Step2Price,
        singleData.Single.Tariff.Step3Price,
        singleData.Single.Tariff.Step1Arithmetic,
        singleData.Single.Tariff.Step2Arithmetic,
        singleData.Single.Tariff.Step3Arithmetic,
        singleData.Summ,
    )
    t1.Print()

    t2 := tabby.New()
    t2.AddHeader(
        "Уч.",
        "Потр.",
        "Тариф",
        "Тек.",
        "Пред.",
        "Расход",
        "%",
        "Р1",
        "Р2",
        "Р3",
        "Ц1",
        "Ц2",
        "Ц3",
        "Н1",
        "Н2",
        "Н3",
        "Сумма",
    )
    t2.AddLine(
        duoData.PlaceNumber,
        duoData.FullName,
        duoData.Duo.T1.TariffName,
        duoData.Duo.T1.CurrentInd,
        duoData.Duo.T1.LastInd,
        duoData.Duo.T1.DifValue,
        duoData.Duo.T1.Ratio,
        duoData.Duo.T1.Step1Calc,
        duoData.Duo.T1.Step2Calc,
        duoData.Duo.T1.Step3Calc,
        duoData.Duo.T1.Step1Price,
        duoData.Duo.T1.Step2Price,
        duoData.Duo.T1.Step3Price,
        duoData.Duo.T1.Step1Arithmetic,
        duoData.Duo.T1.Step2Arithmetic,
        duoData.Duo.T1.Step3Arithmetic,
        duoData.Summ,
    )
    t2.AddLine(
        duoData.PlaceNumber,
        duoData.FullName,
        duoData.Duo.T2.TariffName,
        duoData.Duo.T2.CurrentInd,
        duoData.Duo.T2.LastInd,
        duoData.Duo.T2.DifValue,
        duoData.Duo.T2.Ratio,
        duoData.Duo.T2.Step1Calc,
        duoData.Duo.T2.Step2Calc,
        duoData.Duo.T2.Step3Calc,
        duoData.Duo.T2.Step1Price,
        duoData.Duo.T2.Step2Price,
        duoData.Duo.T2.Step3Price,
        duoData.Duo.T2.Step1Arithmetic,
        duoData.Duo.T2.Step2Arithmetic,
        duoData.Duo.T2.Step3Arithmetic,
        duoData.Summ,
    )
    t2.Print()
}
