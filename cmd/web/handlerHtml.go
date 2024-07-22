package cmd

import (
	"log"
	"net/http"
	"text/template"
)

func (h httpHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {

	if r.URL.Path != h.message {
		ErrorHandler(w, http.StatusNotFound)
		return
	}

	if r.URL.Path != h.message {
		ErrorHandler(w, http.StatusNotFound)
		return
	}

	if r.Method != http.MethodGet {
		ErrorHandler(w, http.StatusMethodNotAllowed)
		return
	}

	tmpl, err := template.ParseFiles(h.pageName, TemplatePage)
	if err != nil {
		log.Println(err.Error())
		ErrorHandler(w, http.StatusInternalServerError)
		return
	}

	err = tmpl.Execute(w, nil)
	if err != nil {
		log.Println(err.Error())
		ErrorHandler(w, http.StatusInternalServerError)
		return
	}

}
