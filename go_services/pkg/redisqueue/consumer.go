package redisqueue

import (
    "context"
    "time"
)

type Consumer struct {
    Queue *Queue
}

func NewConsumer(q *Queue) *Consumer {
    return &Consumer{Queue: q}
}

func (c *Consumer) Listen(ctx context.Context, out chan<- string) error {
    for {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            res, err := c.Queue.Client.BLPop(ctx, 5*time.Second, c.Queue.Name).Result()
            if err != nil {
                continue
            }
            if len(res) == 2 {
                out <- res[1]
            }
        }
    }
}
