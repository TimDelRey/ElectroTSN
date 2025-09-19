package main

import (
    "context"
    "fmt"
    "time"

    "go_services/pkg/redisqueue"
)

func main() {
    ctx := context.Background()

    // ключ должен совпадать с Sidekiq
    queue := redisqueue.NewQueue("redis:6379", "", 0, "receipts:jobs")
    consumer := redisqueue.NewConsumer(queue)

    out := make(chan redisqueue.ReceiptJob)

    go func() {
        if err := consumer.Listen(ctx, out); err != nil {
            fmt.Printf("consumer error: %v\n", err)
        }
    }()

    for {
        select {
        case job := <-out:
            fmt.Printf("получил задачу из redis: %+v\n", job)
            return
        case <-time.After(10 * time.Second):
            fmt.Println("ничего не пришло за 10 секунд")
            return
        }
    }
}
