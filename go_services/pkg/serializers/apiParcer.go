package serializers

import(
    "encoding/json"
    "fmt"

    "go_services/pkg/domain"
)

func ParsApi[T any](data []byte) ([]T, error) {
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

func ParsApiMothColl(data []byte) (map[string][]domain.Indication, error) {
    var inds map[string][]domain.Indication
    if err := json.Unmarshal(data, &inds); err != nil {
        return nil, err
    }
    return inds, nil
}
