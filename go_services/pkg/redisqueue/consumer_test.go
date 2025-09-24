package redisqueue_test

import (
    "context"
    "encoding/json"
    "testing"
    "time"

    "go_services/pkg/redisqueue"
    "go_services/pkg/domain"
)

var testJobs = []domain.Receipt{
    {ReceiptId: 1, UserId: 11, Date: "2025-09-20", S3Key: "file1.pdf"},
    {ReceiptId: 2, UserId: 12, Date: "2025-09-21", S3Key: "file2.pdf"},
    {ReceiptId: 3, UserId: 13, Date: "2025-09-22", S3Key: "file3.pdf"},
    {ReceiptId: 4, UserId: 14, Date: "2025-09-23", S3Key: "file4.pdf"},
}

func TestConsumerReadsMultipleJobs(t *testing.T) {
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()

    queue := redisqueue.NewQueue("redis:6379", "", 0, "receipts:jobs")
    consumer := redisqueue.NewConsumer(queue)

    out := make(chan domain.Receipt, 10)

    if err := queue.Client.Del(ctx, queue.Name).Err(); err != nil {
        t.Fatalf("failed to clean test queue: %v", err)
    }

    for _, job := range testJobs {
        payload, _ := json.Marshal(job)
        if err := queue.Client.RPush(ctx, queue.Name, payload).Err(); err != nil {
            t.Fatalf("failed to push test job: %v", err)
        }
    }

    go func() {
        if err := consumer.Listen(ctx, out); err != nil {
            t.Errorf("consumer error: %v", err)
        }
    }()

    received := make([]domain.Receipt, 0, len(testJobs))
    timeout := time.After(5 * time.Second)

    for len(received) < len(testJobs) {
        select {
        case job := <-out:
            received = append(received, job)
        case <-timeout:
            t.Fatal("did not receive all jobs in time")
        }
    }

    for i, job := range received {
        expected := testJobs[i]
        if job.ReceiptId != expected.ReceiptId ||
            job.UserId != expected.UserId ||
            job.S3Key != expected.S3Key ||
            job.Date != expected.Date {
            t.Errorf("job %d does not match expected. got %+v, want %+v", i, job, expected)
        }
    }
}
