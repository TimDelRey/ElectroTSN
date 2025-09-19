package main

import (
    "context"
    "fmt"
    "time"

    "electrotsn/go_services/pkg/redisqueue"
)

func main() {
    ctx := context.Background()

    queue := redisqueue.NewQueue("localhost:6379", "", 0, "receipts")
    consumer := redisqueue.NewConsumer(queue)

    out := make(chan string)

    go func() {
        if err := consumer.Listen(ctx, out); err != nil {
            fmt.Printf("consumer error: %v\n", err)
        }
    }()

    for {
        select {
        case job := <-out:
            fmt.Printf("получил задачу из redis: %s\n", job)
            return
        case <-time.After(10 * time.Second):
            fmt.Println("ничего не пришло за 10 секунд")
            return
        }
    }
}
