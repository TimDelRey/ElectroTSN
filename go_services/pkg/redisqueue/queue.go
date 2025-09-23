package redisqueue

import (
    "github.com/redis/go-redis/v9"
)

type Queue struct {
    Client *redis.Client
    Name   string
}

func NewQueue(addr, password string, db int, queueName string) *Queue {
    client := redis.NewClient(&redis.Options{
        Addr:     addr,
        Password: password,
        DB:       db,
    })
    return &Queue{
        Client: client,
        Name:   queueName,
    }
}
