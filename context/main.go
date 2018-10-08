package main

import (
	"context"
	"fmt"
	"log"
	"time"
)

func main() {
	ctx := context.Background()

	ctx, cancel := context.WithCancel(ctx)

	go func() {
		time.Sleep(time.Second)
		cancel()
	}()

	sleepAndTalk(ctx, 5*time.Second, "hello")
}

func sleepAndTalk(ctx context.Context, d time.Duration, msg string) {
	select {
	case <-time.After(d):
		fmt.Println(msg)
	case <-ctx.Done():
		log.Print("from here ", ctx.Err())
	}
}
