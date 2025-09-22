package logger

import (
    "os"
    "io"
    "github.com/sirupsen/logrus"
)

var L *logrus.Logger

func Init() {
    // L = logrus.New()
    L = logrus.StandardLogger()
    L.SetReportCaller(true)
    L.SetFormatter(&logrus.TextFormatter{
        FullTimestamp: true,
    })

    if err := os.MkdirAll("./../../log", 0o755); err != nil {
		L.SetOutput(os.Stdout)
	}
    file, err := os.OpenFile("./../../log/logs.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
    if err == nil {
        L.SetOutput(io.MultiWriter(os.Stdout, file)) //поискать замену. мутиврайтер - должен быть долгим
    } else {
        L.Info("Failed to log to file, using default Stdout")
        L.SetOutput(os.Stdout)
    }
}
