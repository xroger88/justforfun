package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

// this is the first go program written with VI by myself!!!
func main() {
	http.HandleFunc("/", printHello)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("....")
}

func printHello(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "Hello Go!\n")
}
