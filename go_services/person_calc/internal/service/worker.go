package service

// на вход получает receipt_job, дергает но нему ручки и выдает стракты
// дергать ручки, проверять флаги актуальности, сохранять в переменные, передавать в стракты
import (
    "go_services/pkg/domain"
    "fmt"
)

package service

import (
    "go_services/pkg/domain"
)

func Collect(
    u         domain.User,
    t         domain.Tariff,
    current_i domain.Indication,
    prev_i    domain.Indication,
) domain.PersonCalc {
    rez := domain.NewPersonCalc(u, t, current_i, prev_i)
    return rez
}
