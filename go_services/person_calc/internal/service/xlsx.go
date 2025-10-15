package service

import (
    "io"
    "fmt"
    "strings"
    "bytes"

    "go_services/pkg/domain"
    "github.com/xuri/excelize/v2"
)

const sheet = "Calculation"

func NewSingleCalcXlsx(c domain.PersonCalc) (io.Reader, error) {
    file := excelize.NewFile()

    _, err := file.NewSheet(sheet)
    if err != nil {
        return nil, err
    }
    
    if err := paintBorders(file); err != nil {
        return nil, err
    }
    if err := mergeCells(file, domain.CalcHeaders); err != nil {
        return nil, err
    }
    if err := setHeaders(file, domain.CalcHeaders); err != nil {
        return nil, err
    }
    if err := setValues(file, c); err != nil {
        return nil, err
    }

    var buf bytes.Buffer
    if err := file.Write(&buf); err != nil {
        return nil, err
    }
    return &buf, nil
}

func mergeCell(f *excelize.File, in string) error {
    parts := strings.Split(in, ":")
    if len(parts) == 2 {
        if err := f.MergeCell(sheet, parts[0], parts[1]); err != nil {
            return err
        }
    }
    return nil
}

func paintBorders(f *excelize.File) error {  
    style, err := f.NewStyle(&excelize.Style{
        Border: []excelize.Border{
            {Type: "left",       Color: "000000", Style: 2},
            {Type: "top",        Color: "000000", Style: 2},
            {Type: "bottom",     Color: "000000", Style: 2},
            {Type: "right",      Color: "000000", Style: 2},
            {Type: "horizontal", Color: "000000", Style: 1},
            {Type: "vertical",   Color: "000000", Style: 1},
        },
    })
    if err != nil {
        return err
    }
    if err := f.SetCellStyle(sheet, "B2", "Q4", style); err != nil {
        return err
    }
    return nil
}

func mergeCells(f *excelize.File, h map[string]string) error { 
    for i := range h {
        if err := mergeCell(f, i); err != nil {
            return err
        }
    }
    return nil
}

func setHeaders(f *excelize.File, h map[string]string) error { 
    for i, v := range h {
        parts := strings.Split(i, ":")
        if err := f.SetCellValue(sheet, parts[0], v); err != nil {
            return err
        }
    }
    return nil
}

func setValues(f *excelize.File, c domain.PersonCalc) error {
    values := map[string]any{
        "B4": c.PlaceNumber,
        "C4": c.FullName,
        "D4": c.Single.Tariff.TariffName,
        "E4": c.Single.Tariff.CurrentInd,
        "F4": c.Single.Tariff.LastInd,
        "G4": c.Single.Tariff.DifValue,
        "H4": c.Single.Tariff.Step1Calc,
        "I4": c.Single.Tariff.Step2Calc,
        "J4": c.Single.Tariff.Step3Calc,
        "K4": c.Single.Tariff.Step1Price,
        "L4": c.Single.Tariff.Step2Price,
        "M4": c.Single.Tariff.Step3Price,
        "N4": c.Single.Tariff.Step1Arithmetic,
        "O4": c.Single.Tariff.Step2Arithmetic,
        "P4": c.Single.Tariff.Step3Arithmetic,
        "Q4": c.Summ,
    }

    for cell, val := range values {
        if err := f.SetCellValue(sheet, cell, val); err != nil {
            return err
        }
    }
    return nil
}
