package redisqueue

type ReceiptJob struct {
    ReceiptID int    `json:"receipt_id"`
    UserID    int    `json:"user_id"`
    Date      *string `json:"date"`
    S3Key     string `json:"s3_key"`
}
