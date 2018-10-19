package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/websocket"
)

func usage() {
	fmt.Printf(`Usage: %s [ --help ] [ --no-origin-check ] [ --trace ]
`, os.Args[0])
}

func main() {
	settings := Settings{
		NatsAddr: "localhost:4222",
	}

	for _, arg := range os.Args[1:] {
		switch arg {
		case "--help":
			usage()
			return
		case "--no-origin-check":
			settings.WSUpgrader = &websocket.Upgrader{
				ReadBufferSize:  1024,
				WriteBufferSize: 1024,
				CheckOrigin:     func(r *http.Request) bool { return true },
			}
		case "--trace":
			settings.Trace = true
		default:
			fmt.Printf("Invalid args: %s\n\n", arg)
			usage()
			return
		}
	}

	gateway := NewGateway(settings)

	fs := http.FileServer(http.Dir("web/"))
	http.Handle("/web/", http.StripPrefix("/web/", fs))

	http.HandleFunc("/", printHello)
	http.HandleFunc("/nats", gateway.Handler)

	var httpErr error

	if _, err := os.Stat("./xroger88.crt"); err == nil {
		fmt.Println("file ", "xroger88.crt found switching to https")
		if httpErr = http.ListenAndServeTLS("0.0.0.0:8910", "xroger88.crt", "xroger88.key", nil); httpErr != nil {
			log.Fatal("The process exited with https error: ", httpErr.Error())
		}
	} else {
		httpErr = http.ListenAndServe("0.0.0.0:8910", nil)
		if httpErr != nil {
			log.Fatal("The process exited with http error: ", httpErr.Error())
		}
	}
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
