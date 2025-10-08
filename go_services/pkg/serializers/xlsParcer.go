package serializers

import (
    "fmt"
    "bytes"

    "github.com/xuri/excelize/v2"
    "go_services/pkg/domain"
)

func ParsPersonCalcXls(in []byte) (domain.PersonCalc, error) {
    f, err := excelize.OpenReader(bytes.NewReader(in))
    if err != nil {
        fmt.Println(err)
        return domain.PersonCalc{}, err
    }
    defer func() {
        if err := f.Close(); err != nil {
            fmt.Println(err)
        }
    }()
    var out domain.PersonCalc
    out.FullName, err = f.GetCellValue("Расчеты", "C3")
    if err != nil {
        fmt.Println(err)
        return domain.PersonCalc{}, err
    }
    return out, nil
}