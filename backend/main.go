package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	address := "0.0.0.0"
	port := "7001"
	router := mux.NewRouter()

	router.HandleFunc("/hello/{name}", func(w http.ResponseWriter, r *http.Request) {

		vars := mux.Vars(r)
		name := vars["name"]
		fmt.Fprintln(w, "Hello ", name)
	})
	log.Println("Starting server")
	if err := http.ListenAndServe(address+":"+port, router); err != nil {
		log.Panic((err))
	}
}

func add(a int32, b int32) int32 {
	return a + b
}