package domain

type PersonCalc struct {
    PlaceNumber       int
    FullName          string

    // tariff, indications, prices can be single or duo
    SingleTariff *string
    TariffT1     *string
    TariffT2     *string
    
    CurrentSingleInd *float64
    CurrentT1Ind     *float64
    CurrentT2Ind     *float64
    LastSingleInd    *float64
    LastT1Ind        *float64
    LastT2Ind        *float64

    // t1 and single price are same
    T1FirstStepPrice  *float64
    T2FirstStepPrice  *float64
    T1SecondStepPrice *float64
    T2SecondStepPrice *float64
    T1ThirdStepPrice  *float64
    T2ThirdStepPrice  *float64
}
