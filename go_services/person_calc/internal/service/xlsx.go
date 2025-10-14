package service

import (
    "io"
    "fmt"

    "go_services/pkg/domain"
    "github.com/xuri/excelize/v2"
)

const sheet = "Calculation"

func NewSingleCalcXlsx(c domain.PersonCalc) (io.Reader, error) {
    file := exelize.NewFile()
    defer func() {
        if err := file.Close(); err != nil {
            fmt.Println(err)
        }
    }()
    page, err := file.NewSheet(sheet)
    if err != nil {
        fmt.Println(err)
        return
    }



    // Generator cells merge
    // Generator borders
    // Geterator Headers
    // Generator calc values

}

func mergeCells(f *exelize.NewFile()) error {  
    if err := f.MergeCell(sheet, "A1", "C1"); err != nil {
        log.Fatal(err)
    } 
}

func paintBorders(f *exelize.NewFile()) error {   
}

func setHeaders(f *exelize.NewFile()) error {   
}

func setValues(f *exelize.NewFile()) error {  
    f.SetCellValue(sheet, "B4", c.PlaceNumber)
    f.SetCellValue(sheet, "C4", c.FullName)
    f.SetCellValue(sheet, "D4", c.Single.Tariff.TariffName)
    f.SetCellValue(sheet, "E4", c.Single.Tariff.CurrentInd)
    f.SetCellValue(sheet, "F4", c.Single.Tariff.LastInd)
    f.SetCellValue(sheet, "G4", c.Single.Tariff.DifValue)
    f.SetCellValue(sheet, "H4", c.Single.Tariff.Step1Calc)
    f.SetCellValue(sheet, "I4", c.Single.Tariff.Step2Calc)
    f.SetCellValue(sheet, "J4", c.Single.Tariff.Step3Calc)
    f.SetCellValue(sheet, "K4", c.Single.Tariff.Step1Price)
    f.SetCellValue(sheet, "L4", c.Single.Tariff.Step2Price)
    f.SetCellValue(sheet, "M4", c.Single.Tariff.Step3Price)
    f.SetCellValue(sheet, "N4", c.Single.Tariff.Step1Arithmetic)
    f.SetCellValue(sheet, "O4", c.Single.Tariff.Step2Arithmetic)
    f.SetCellValue(sheet, "P4", c.Single.Tariff.Step3Arithmetic)
    f.SetCellValue(sheet, "Q4", c.Summ) 
}
