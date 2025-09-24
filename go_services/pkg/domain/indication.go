package domain

type Indication struct {
    IndicationId int `json:"id"`
    UserId int `json:"user_id"`
    DayData *float64 `json:"day_time_reading"`
    NightData *float64 `json:"night_time_reading"` 
    AllDayData *float64 `json:"all_day_reading"`
    Month string `json:"for_month"`
    Correct bool `json:"is_correct"`
}
