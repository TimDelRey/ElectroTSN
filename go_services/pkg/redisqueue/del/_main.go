package main

import (
    "context"
    "fmt"
    "time"

    "go_services/pkg/redisqueue"
    
    "os"
    "os/signal"
    "syscall"
)

func main() {
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()

    queue := redisqueue.NewQueue("redis:6379", "", 0, "receipts:jobs")
    consumer := redisqueue.NewConsumer(queue)

    out := make(chan redisqueue.ReceiptJob, 100)

    go func() {
        if err := consumer.Listen(ctx, out); err != nil {
            fmt.Printf("consumer error: %v\n", err)
        }
    }()

    for i := 0; i < 50; i++ {
        go func(id int) {
            for job := range out {
                fmt.Printf("Worker %d обрабатывает задачу: %+v\n", id, job)
                time.Sleep(2 * time.Second)
                fmt.Printf("Worker %d закончил задачу %d\n", id, job.ReceiptID)
            }
        }(i)
    }

    sigs := make(chan os.Signal, 1)
    signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

    <-sigs
    fmt.Println(" получен сигнал, выходим...")

    cancel()
    close(out)
}
