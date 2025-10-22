package service

import (
    "go_services/pkg/domain"
)

func Run() {
    // раздел 1. Redis     // слушает редис
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()

    queue := redisqueue.NewQueue("redis:6379", "", 0, "person_calc:jobs")
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
                // раздел 2. Fetcher    // ходит в API

                // получение юзера
                netUser, err := client.GetUser(receipt.UserId)
                if err != nil {
                    panic(err)
                }
                // получнеие тарифа
                netTariff, err := client.Tariffs()
                if err != nil {
                    panic(err)
                }
                // получение текущих показаний
                netCurInt, err := client.GetInd(receipt.UserId, date.Format("2006-01-02"))
                if err != nil {
                    panic(err)
                }
                // получение предыдущих показаний
                prevDate := time.Date(date.Year(), date.Month(), 1, 0, 0, 0, 0, date.Location()).AddDate(0, 0, -1)
                netPrevInt, err := client.GetInd(receipt.UserId, prevDate.Format("2006-01-02"))
                if err != nil {
                    panic(err)
                }
                // конец раздела 2

                // раздел 3. Serializer // превращает []byte в structs
                // получение юзера
                users,err := serializers.ParsApi[domain.User](netUser)
                if err != nil {
                    panic(err)
                }
                user := users[0]
                // получнеие тарифа
                tariffs, err := serializers.ParsApi[domain.Tariff](netTariff)
                if err != nil {
                    panic(err)
                }
                date, err := time.Parse("2006-01-02", receipt.Date)
                if err != nil {
                    panic(err)
                }
                if date.Month() <= 6  && user.Tariff == "mono" {
                    for _, t := range tariffs {
                        if t.Title.strings.Contains("Одноставочный I-полугодие") {
                            tariff := t
                        }
                    } 
                if t.Month() > 6  && user.Tariff == "mono" {
                    for _, t := range tariffs {
                        if t.Title.strings.Contains("Одноставочный II-полугодие") {
                            tariff := t
                        }
                    }
                }
                if t.Month() <= 6  && user.Tariff != "mono" {
                    for _, t := range tariffs {
                        if t.Title.strings.Contains("Двуставочный I-полугодие") {
                            tariff := t
                        }
                    } 
                if t.Month() > 6  && user.Tariff != "mono" {
                    for _, t := range tariffs {
                        if t.Title.strings.Contains("Двуставочный II-полугодие") {
                            tariff := t
                        }
                    }
                }
                // получение текущих показаний
                curInds, err := serializers.ParsApi[domain.Indication](netCurInt)
                if err != nil {
                    panic(err)
                }
                for i := range curInds {
                    if i.Correct == true {
                        curInt := i
                    } else {
                        oldInt := i
                    }
                }
                // получение предыдущих показаний
                prevInds, err := serializers.ParsApi[domain.Indication](netPrevInt)
                if err != nil {
                    panic(err)
                }
                for i := range prevInds {
                    if i.Correct == true {
                        prevInt := i
                    }
                }
                // конец раздела 3

                // раздел 4. Builder  // строит domain.PersonCalc.  (обработать oldInt)
                file := domain.NewPersonCalc(user, tariff, curInt, prevInds)
                // конец раздела 4

                // раздел 5. Calculator // делает расчёты
                if user.Tariff == "mono" {
                    if err := calculator.SingleZone(&file); err != nil {
                        panic(err)
                    }
                } else {
                    if err := calculator.DuoZone(&file); err != nil {
                        panic(err)
                    }
                }
                // конец раздела 5
                
                // раздел 6. Exporter // создаёт файл
                if user.Tariff == "mono" {
                    singleXlsx, err := sdomain.NewSingleCalcXlsx(file)
                    if err != nil {
                        panic(err)
                    }
                } else {
                    duoXlsx, err := sdomain.NewDuoCalcXlsx(file)
                    if err != nil {
                        panic(err)
                    }
                }
                // конец раздела 6

                // раздел 7. Uploader // кладёт в S3
                clientCloud, err := s3.NewClient()
                if err != nil {
                    panic(err)
                }

                key := receipt.S3Key
                const contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

                err := clientCloud.UploadFile(key, file, contentType)
                if err != nil {
                    panic(err)
                }
                }
                // конец раздела 7

                // раздел 8. Notifier  // дергает complete
                _, err := client.CompleteReceipt(receipt.ReceiptId)
                if err != nil {
                    panic(err)
                }
                // конец раздела 8
            }
        }
    }

    sigs := make(chan os.Signal, 1)
    signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

    <-sigs
    fmt.Println(" Получен сигнал, выходим...")

    cancel()
    close(out)
    // конец раздела 1
}
