package domain

// PersonCalc может быть получен из файла (расчет либо квитанция) в облаке либо собранным из апи ручек и джобы
type PersonCalc struct {
    PlaceNumber int
    FullName    string

    Single *SingleZone
    Duo    *DuoCalc

    Summ    float64
}

type SingleZone struct {
    Tariff TariffCalc
}

type DuoCalc struct {
    T1 TariffCalc
    T2 TariffCalc
}

type TariffCalc struct {
    TariffName      string
    CurrentInd      float64
    LastInd         float64
    DifValue        float64
    Ratio           int
    Step1Calc       float64
    Step2Calc       float64
    Step3Calc       float64
    Step1Price      float64
    Step2Price      float64
    Step3Price      float64
    Step1Arithmetic float64
    Step2Arithmetic float64
    Step3Arithmetic float64
}
