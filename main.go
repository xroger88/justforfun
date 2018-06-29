package main

import (
	"fmt"
	"net/http"
)

/***
// this is the first go program written with VI by myself!!!
func main() {
	http.HandleFunc("/", printHello)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("....")
}
***/

// for gcloud app engine
func init() {
	http.HandleFunc("/", printHello)
}

const content = `<?xml version="1.0" encoding="UTF-8" ?>
<Response>
	<Say>Hello Monkey!!</Say>
</Response>`

func printHello(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/xml")
	fmt.Fprint(w, content)
	//io.WriteString(w, "Hello Go!\n")
}
