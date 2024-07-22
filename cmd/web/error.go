package cmd

import (
	"net/http"
	"text/template"
)

func ErrorHandler(w http.ResponseWriter, code int) {
	tmpl, err := template.ParseFiles(ErrorPage, TemplatePage)
	if err != nil {
		http.Error(w, "Internal Server Error", 500)
		return
	}
	w.WriteHeader(code)
	errInf := Err{code, http.StatusText(code)}
	err = tmpl.Execute(w, errInf)
	if err != nil {
		http.Error(w, "Internal Server Error", 500)
		return
	}
}


