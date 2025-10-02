package domain

import(
    "encoding/json"
    "fmt"
)

func ParsFunc[T any](data []byte) ([]T, error) {
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

func ParsMothColl(data []byte) (map[string][]Indication, error) {
    var inds map[string][]Indication
    if err := json.Unmarshal(data, &inds); err != nil {
        return nil, err
    }
    return inds, nil
}
