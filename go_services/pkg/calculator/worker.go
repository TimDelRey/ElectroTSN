package calculator

import(
    "fmt"
    "math"
    "strconv"
    "os"

    "go_services/pkg/domain"
    "go_services/pkg/logger"
)

var (
    firstVolumeBenefits, secondVolumeBenefits float64
)

func init() {
    var err error
    firstVolumeBenefits, err = strconv.ParseFloat(os.Getenv("FIRST_VOLUME_BENEFITS"), 64)
    if err != nil {
        firstVolumeBenefits = float64(150)
    }
    secondVolumeBenefits, err = strconv.ParseFloat(os.Getenv("SECOND_VOLUME_BENEFITS"), 64)
    if err != nil {
        secondVolumeBenefits = float64(450)
    }
}

func takeMin(sum *float64, limit float64) float64 {
    var take float64
    if *sum < limit {
        take = *sum
    } else {
        take = limit
    }
    *sum -= take
    return take
}

func roundingTo2(in float64) float64 {
    return math.Round(in * 100) / 100
}

func sharesInValue(v float64, percent int) (share1, share2 float64) {
    share1 = (v * float64(percent)) / 100
    share2 = v - share1
    return
}

func SingleZone(p *domain.PersonCalc) (err error) {
    // столбец расхода
    p.Single.Tariff.DifValue = p.Single.Tariff.CurrentInd - p.Single.Tariff.LastInd
    if p.Single.Tariff.DifValue < 0 {
        err = fmt.Errorf("user %s: current reading is less than previous", p.FullName)
        logger.L.Error(err)
		return err
    }
    // столбец расчета объема
    sum := p.Single.Tariff.DifValue

    p.Single.Tariff.Step1Calc = takeMin(&sum, firstVolumeBenefits)
    p.Single.Tariff.Step2Calc = takeMin(&sum, secondVolumeBenefits)
    p.Single.Tariff.Step3Calc = sum

    // столбцы расчета начислений
    p.Single.Tariff.Step1Arithmetic = p.Single.Tariff.Step1Calc * p.Single.Tariff.Step1Price
    p.Single.Tariff.Step2Arithmetic = p.Single.Tariff.Step2Calc * p.Single.Tariff.Step2Price
    p.Single.Tariff.Step3Arithmetic = p.Single.Tariff.Step3Calc * p.Single.Tariff.Step3Price

    // столбец расчета итоговой суммы
    p.Summ = roundingTo2(p.Single.Tariff.Step1Arithmetic + p.Single.Tariff.Step2Arithmetic + p.Single.Tariff.Step3Arithmetic)

    return nil
}
    
func DuoZone(p *domain.PersonCalc) (err error) {

    // столбец расхода
    p.Duo.T1.DifValue = roundingTo2(p.Duo.T1.CurrentInd - p.Duo.T1.LastInd)
    p.Duo.T2.DifValue = roundingTo2(p.Duo.T2.CurrentInd - p.Duo.T2.LastInd)
    total := p.Duo.T1.DifValue + p.Duo.T2.DifValue

    if p.Duo.T1.DifValue < 0 || p.Duo.T2.DifValue < 0 {
        err = fmt.Errorf("user %s: current reading is less than previous", p.FullName)
        logger.L.Error(err)
		return err
    }
    // столбец процентного соотношения
    p.Duo.T1.Ratio, p.Duo.T2.Ratio = func(v1, v2 float64) (ratioT1, ratioT2 int) {
        if total > 0 {
            ratioT1 = int(math.Round(100.00 * v1 / total))
            ratioT2 = 100 - ratioT1
            return
        }
        return 50, 50
    }(p.Duo.T1.DifValue, p.Duo.T2.DifValue)

    // столбцы расчета объема
    maxValStep1T1, maxValStep1T2 := sharesInValue(firstVolumeBenefits, p.Duo.T1.Ratio)
    maxValStep2T1, maxValStep2T2 := sharesInValue(secondVolumeBenefits, p.Duo.T1.Ratio)

    sumT1 := p.Duo.T1.DifValue
    sumT2 := p.Duo.T2.DifValue
    
    p.Duo.T1.Step1Calc = takeMin(&sumT1, maxValStep1T1)
    p.Duo.T1.Step2Calc = takeMin(&sumT1, maxValStep2T1)
    p.Duo.T1.Step3Calc = sumT1

    p.Duo.T2.Step1Calc = takeMin(&sumT2, maxValStep1T2)
    p.Duo.T2.Step2Calc = takeMin(&sumT2, maxValStep2T2)
    p.Duo.T2.Step3Calc = sumT2

    // столбцы расчета начислений
    p.Duo.T1.Step1Arithmetic = roundingTo2(p.Duo.T1.Step1Calc * p.Duo.T1.Step1Price)
    p.Duo.T1.Step2Arithmetic = roundingTo2(p.Duo.T1.Step2Calc * p.Duo.T1.Step2Price)
    p.Duo.T1.Step3Arithmetic = roundingTo2(p.Duo.T1.Step3Calc * p.Duo.T1.Step3Price)

    p.Duo.T2.Step1Arithmetic = roundingTo2(p.Duo.T2.Step1Calc * p.Duo.T2.Step1Price) 
    p.Duo.T2.Step2Arithmetic = roundingTo2(p.Duo.T2.Step2Calc * p.Duo.T2.Step2Price)
    p.Duo.T2.Step3Arithmetic = roundingTo2(p.Duo.T2.Step3Calc * p.Duo.T2.Step3Price)


    // столбец расчета итоговой суммы
    p.Summ = roundingTo2(p.Duo.T1.Step1Arithmetic + p.Duo.T1.Step2Arithmetic + p.Duo.T1.Step3Arithmetic + p.Duo.T2.Step1Arithmetic + p.Duo.T2.Step2Arithmetic + p.Duo.T2.Step3Arithmetic)

    return nil
}
