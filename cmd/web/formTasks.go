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

type TasksHtml struct {
	Error  string
	Inform string
	Values []postgres.TaskView
}

func processHandlerFormTasksActions(w http.ResponseWriter, r *http.Request) {

	if r.URL.Path != "/formTasksList" {
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

		tmpl, err := template.ParseFiles(TasksPageList, TemplatePage)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		errStr := ""
		infStr := ""

		//insert, update, delete data
		if strings.Contains(requestData.Action, "tasks_") {
			id, err := DBase.IUDTasks(requestData.Action, requestData.Value)
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
		var data map[string]interface{}
		err = json.Unmarshal([]byte(jsonData), &data)
		tasks, err := DBase.ViewTasks(data)
		if err != nil {
			errStr = err.Error()
			logger.SetLogError(fmt.Errorf(errStr))
		}
		tasksHtml_ := TasksHtml{Error: errStr, Inform: infStr, Values: tasks}

		err = tmpl.Execute(w, tasksHtml_)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		response := ""
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)

	}
}

func ServeHTTPFormTasks(w http.ResponseWriter, r *http.Request) {

	tmpl, err := template.ParseFiles(TasksPage, TemplatePage)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	data := TypePage{PageDescribe: "Tasks List"}

	err = tmpl.Execute(w, data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	return
}
