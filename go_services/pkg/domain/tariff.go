package domain

type Tariff struct {
    ID int `json:"id"`
    Title string `json:"title"`
    Discription string `json:"discription"`
    Default bool `json:"is_dafault"`
    FirstValue *float64 `json:"first_step_value"`
    SecondValue *float64 `json:"second_step_value"`
    ThirdValue *float64 `json:"third_step_value"`
}
