package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
)

type Response struct {
	Hostname   string `json:"hostname"`
	IP         string `json:"ip"`
	CustomText string `json:"custom_text"`
}

func getIP() (string, error) {
	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		return "", err
	}
	defer conn.Close()

	addr := conn.LocalAddr().(*net.UDPAddr)

	return addr.IP.String(), nil
}

func handler(customText string) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		hostname, err := os.Hostname()
		if err != nil {
			http.Error(w, "Error getting hostname", http.StatusInternalServerError)
			return
		}

		ip, err := getIP()
		if err != nil {
			http.Error(w, "Error getting IP address", http.StatusInternalServerError)
			return
		}

		response := &Response{
			Hostname:   hostname,
			IP:         ip,
			CustomText: customText,
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	}
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Please provide a custom text argument.")
		os.Exit(1)
	}

	customText := os.Args[1]
	http.HandleFunc("/", handler(customText))

	port := "8080"
	fmt.Printf("Starting server on port %s...\n", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
