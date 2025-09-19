package redisqueue

import (
    "context"
    "encoding/json"
    "fmt"
    "time"
)

type Consumer struct {
    Queue *Queue
}

func NewConsumer(q *Queue) *Consumer {
    return &Consumer{Queue: q}
}

func (c *Consumer) Listen(ctx context.Context, out chan<- ReceiptJob) error {
    for {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            // BLPop ждёт элемент 5 секунд
            res, err := c.Queue.Client.BLPop(ctx, 5*time.Second, c.Queue.Name).Result()
            if err != nil {
                if err.Error() != "redis: nil" {
                    fmt.Printf("redis error: %v\n", err)
                }
                continue
            }

            if len(res) == 2 {
                var job ReceiptJob
                if err := json.Unmarshal([]byte(res[1]), &job); err != nil {
                    fmt.Printf("json unmarshal error: %v\n", err)
                    continue
                }
                out <- job
            }
        }
    }
}
