package domain

import (
    "io"
    "strings"
    "bytes"

    "go_services/pkg/domain"
    "go_services/pkg/domain/samples"
    "github.com/xuri/excelize/v2"
)

const sheet = "Calculation"

func NewSingleCalcXlsx(c domain.PersonCalc) (io.Reader, error) {
    file := excelize.NewFile()

    page, err := file.NewSheet(sheet)
    if err != nil {
        return nil, err
    }

    file.SetActiveSheet(page)

    if err := setCellsWidth(file, samples.CalcSingleWidth); err != nil {
        return nil, err
    }
    if err := setCellsHeight(file, samples.CalcHeight); err != nil {
        return nil, err
    }
    if err := setSingleStyle(file); err != nil {
        return nil, err
    }
    if err := mergeCells(file, samples.CalcSingleHeaders); err != nil {
        return nil, err
    }
    if err := setHeaders(file, samples.CalcSingleHeaders); err != nil {
        return nil, err
    }
    if err := setSingleValues(file, c); err != nil {
        return nil, err
    }
    var buf bytes.Buffer
    if err := file.Write(&buf); err != nil {
        return nil, err
    }
    return &buf, nil
}

func NewDuoCalcXlsx(c domain.PersonCalc) (io.Reader, error) {
    file := excelize.NewFile()

    page, err := file.NewSheet(sheet)
    if err != nil {
        return nil, err
    }

    file.SetActiveSheet(page)

    if err := setCellsWidth(file, samples.CalcDuoWidth); err != nil {
        return nil, err
    }
    if err := setCellsHeight(file, samples.CalcHeight); err != nil {
        return nil, err
    }
    if err := setDuoStyle(file); err != nil {
        return nil, err
    }
    if err := mergeCells(file, samples.CalcDuoHeaders); err != nil {
        return nil, err
    }
    if err := setHeaders(file, samples.CalcDuoHeaders); err != nil {
        return nil, err
    }
    if err := setDuoValues(file, c); err != nil {
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

func setCellsWidth(f *excelize.File, w map[string]float64) error {
    for i, v := range w {
        if err := f.SetColWidth(sheet, i, i, v); err != nil {
            return err
        }
    }
    return nil
}

func setCellsHeight(f *excelize.File, h map[int]float64) error {
    for i, v := range h {
        if err := f.SetRowHeight(sheet, i, v); err != nil {
            return err
        }
    }
    return nil
}

func baseStyle(fontSize float64, horizontal string, wrap bool) *excelize.Style {
    return &excelize.Style{
        Border: []excelize.Border{
            {Type: "left",       Color: "000000", Style: 2},
            {Type: "top",        Color: "000000", Style: 2},
            {Type: "bottom",     Color: "000000", Style: 2},
            {Type: "right",      Color: "000000", Style: 2},
            {Type: "horizontal", Color: "000000", Style: 1},
            {Type: "vertical",   Color: "000000", Style: 1},
        },
        Font: &excelize.Font{
            Family: "Arial",
            Size:   fontSize,
        },
        Alignment: &excelize.Alignment{
            Horizontal: horizontal,
            Vertical:   "center",
            WrapText:   wrap,
        },
    }
}

func setMainStyle(f *excelize.File, from, to string) error {
    style, err := f.NewStyle(baseStyle(7, "center", true))
    if err != nil {
        return err
    }
    return f.SetCellStyle(sheet, from, to, style)
}

func setNameStyle(f *excelize.File, from, to string) error {
    style, err := f.NewStyle(baseStyle(7, "left", false))
    if err != nil {
        return err
    }
    return f.SetCellStyle(sheet, from, to, style)
}

func setRatioStyle(f *excelize.File, from, to string) error {
    s := baseStyle(6, "center", true)
    s.Alignment.TextRotation = 90
    style, err := f.NewStyle(s)
    if err != nil {
        return err
    }
    return f.SetCellStyle(sheet, from, to, style)
}

func setValueStyle(f *excelize.File, from, to string) error {
    style, err := f.NewStyle(baseStyle(7, "right", true))
    if err != nil {
        return err
    }
    return f.SetCellStyle(sheet, from, to, style)
}

func setSingleStyle(f *excelize.File) error {
    if err := setMainStyle(f, "B2", "Q4"); err != nil {
        return err
    }
    if err := setNameStyle(f, "B4", "D4"); err != nil {
        return err
    }
    if err := setValueStyle(f, "E4", "Q4"); err != nil {
        return err
    }
    return nil
}

func setDuoStyle(f *excelize.File) error {
    if err := setMainStyle(f, "B2", "R5"); err != nil {
        return err
    }
    if err := setNameStyle(f, "B4", "D5"); err != nil {
        return err
    }
    if err := setRatioStyle(f, "H3", "H3"); err != nil {
        return err
    }
    if err := setValueStyle(f, "E4", "R5"); err != nil {
        return err
    }
    if err := mergeCells(f, map[string]string {
            "B4:B5":"",
            "C4:C5":"",
            "R4:R5":"",
        }); err != nil {
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

func setSingleValues(f *excelize.File, c domain.PersonCalc) error {
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

func setDuoValues(f *excelize.File, c domain.PersonCalc) error {
        values := map[string]any{
        "B4": c.PlaceNumber,
        "C4": c.FullName,
        "D4": c.Duo.T1.TariffName,
        "D5": c.Duo.T2.TariffName,
        "E4": c.Duo.T1.CurrentInd,
        "E5": c.Duo.T2.CurrentInd,
        "F4": c.Duo.T1.LastInd,
        "F5": c.Duo.T2.LastInd,
        "G4": c.Duo.T1.DifValue,
        "G5": c.Duo.T2.DifValue,
        "H4": c.Duo.T1.Ratio,
        "H5": c.Duo.T2.Ratio,
        "I4": c.Duo.T1.Step1Calc,
        "I5": c.Duo.T2.Step1Calc,
        "J4": c.Duo.T1.Step2Calc,
        "J5": c.Duo.T2.Step2Calc,
        "K4": c.Duo.T1.Step3Calc,
        "K5": c.Duo.T2.Step3Calc,
        "L4": c.Duo.T1.Step1Price,
        "L5": c.Duo.T2.Step1Price,
        "M4": c.Duo.T1.Step2Price,
        "M5": c.Duo.T2.Step2Price,
        "N4": c.Duo.T1.Step3Price,
        "N5": c.Duo.T2.Step3Price,
        "O4": c.Duo.T1.Step1Arithmetic,
        "O5": c.Duo.T2.Step1Arithmetic,
        "P4": c.Duo.T1.Step2Arithmetic,
        "P5": c.Duo.T2.Step2Arithmetic,
        "Q4": c.Duo.T1.Step3Arithmetic,
        "Q5": c.Duo.T2.Step3Arithmetic,
        "R4": c.Summ,
    }

    for cell, val := range values {
        if err := f.SetCellValue(sheet, cell, val); err != nil {
            return err
        }
    }
    return nil
}
