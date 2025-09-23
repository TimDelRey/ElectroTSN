## Заметки
- Логика работы сервиса *collective_electro_calc* <br>
> Монолит Rails создает джобу и кладет в РЕДИС  <br>
> Консюмеры сервиса слушает редис и шлют json в канал out  <br>
- Что бы логи сервисов корректно создавали папку с логами, файл `main.go` должен быть в workspaces: `./go_services/service_name/cmd/worker/` <br>