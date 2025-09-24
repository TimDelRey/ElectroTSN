package domain

import(
    "encoding/json"
    "fmt"
)

func ParsFunc[T any](data []byte) ([]T, error) {
    // data, err := getData()
    // if err != nil {
    //     return nil, err
    // }

    var arr []T
    if err := json.Unmarshal(data, &arr); err == nil {
        return arr, nil
    }

    var single T
    if err := json.Unmarshal(data, &single); err == nil {
        return []T{single}, nil
    }

    return nil, fmt.Errorf("invalid JSON")
}

