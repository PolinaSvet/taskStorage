package cmd

import (
	//"fmt"
	"net/http"
	"taskdb/cmd/pkg/logger"
	"text/template"
)

type errorLogType struct {
	PageName string
	Values   []logger.ErrorResponse
}

func ServeHTTPerrorLog(w http.ResponseWriter, r *http.Request) {

	if r.URL.Path == "/errorLog/" {

		tmpl, err := template.ParseFiles(ErrorLogPage, TemplatePage)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		dataCode, err := logger.LoadErrorFromJSONFile()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		data := errorLogType{PageName: "Message Log",
			Values: dataCode}
		err = tmpl.Execute(w, data)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		return
	}

}
