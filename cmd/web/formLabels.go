package cmd

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"text/template"
	"time"

	"taskdb/cmd/pkg/logger"
	"taskdb/cmd/pkg/storage/postgres"
)

type LabelsHtml struct {
	Error  string
	Inform string
	Values []postgres.Label
}

func processHandlerFormLabelsActions(w http.ResponseWriter, r *http.Request) {

	if r.URL.Path != "/formLabelsList" {
		return
	}

	if r.Method == http.MethodPost {

		type RequestData struct {
			Action string                 `json:"action"`
			Value  map[string]interface{} `json:"value"`
		}

		var requestData RequestData

		if err := json.NewDecoder(r.Body).Decode(&requestData); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		tmpl, err := template.ParseFiles(LabelsPageList, TemplatePage)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		errStr := ""
		infStr := ""

		//insert, update, delete data
		if strings.Contains(requestData.Action, "labels_") {
			id, err := DBase.IUDLabels(requestData.Action, requestData.Value)
			if err != nil || id == 0 {
				errStr = fmt.Sprintf("Error %v: %v %v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, err)
				logger.SetLogError(fmt.Errorf(errStr))
			} else {
				infStr = fmt.Sprintf("Info %v: %v id=%v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, id)
				logger.SetLogInform(fmt.Errorf(infStr))
			}
		}

		//select all data
		jsonData := `{
			"id": 0
		  }`
		var jsonDataMap map[string]interface{}
		err = json.Unmarshal([]byte(jsonData), &jsonDataMap)
		if err != nil {
			errStr := err.Error()
			logger.SetLogError(fmt.Errorf(errStr))
		}

		labels, err := DBase.ViewLabels(jsonDataMap)
		if err != nil {
			errStr = err.Error()
			logger.SetLogError(fmt.Errorf(errStr))
		}
		labelsHtml_ := LabelsHtml{Error: errStr, Inform: infStr, Values: labels}

		err = tmpl.Execute(w, labelsHtml_)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		response := ""
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)

	}
}

func ServeHTTPFormLabels(w http.ResponseWriter, r *http.Request) {

	tmpl, err := template.ParseFiles(LabelsPage, TemplatePage)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	data := TypePage{PageDescribe: "Labels List"}

	err = tmpl.Execute(w, data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	return
}
