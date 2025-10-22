package domain

type PersonReceipt struct {
    PersonCalc

    balance float64
    payment *float64
    bill    float64
}