package domain

type Receipt struct {
    ReceiptId int     `json:"receipt_id"`
    UserId    int     `json:"user_id`
    Date      string  `json:"date,`
    UploadUrl string  `json:"upload_url"`
}
