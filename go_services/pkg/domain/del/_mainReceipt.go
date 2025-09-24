package main

import (
    "context"
    "fmt"
    "os"
    "os/signal"
    "syscall"
    "time"

    "go_services/pkg/domain"
    "go_services/pkg/redisqueue"
)

func main() {
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()

    queue := redisqueue.NewQueue("redis:6379", "", 0, "receipts:jobs")
    consumer := redisqueue.NewConsumer(queue)

    out := make(chan domain.Receipt, 100)

    go func() {
        if err := consumer.Listen(ctx, out); err != nil {
            fmt.Printf("consumer error: %v\n", err)
        }
    }()

    numWorkers := 2
    for i := 0; i < numWorkers; i++ {
        go func(id int) {
            for receipt := range out {
                fmt.Printf("Worker %d обрабатывает квиташку: %+v\n", id, receipt)
                time.Sleep(2 * time.Second)
                fmt.Printf("Worker %d закончил обработку ReceiptID=%d\n", id, receipt.ReceiptId)
            }
        }(i)
    }

    sigs := make(chan os.Signal, 1)
    signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

    <-sigs
    fmt.Println(" Получен сигнал, выходим...")

    cancel()
    close(out)

    time.Sleep(1 * time.Second)
}
