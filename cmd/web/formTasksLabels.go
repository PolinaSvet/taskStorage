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

type TasksLabelsHtml struct {
	PageDescribe string
	Error        string
	Inform       string
	Values       []postgres.TaskLabelView
	ValuesTasks  []postgres.TaskView
	ValuesLabels []postgres.Label
}

func processHandlerFormTasksLabelsActions(w http.ResponseWriter, r *http.Request) {

	if r.URL.Path != "/formTasksLabelsList" {
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

		tmpl, err := template.ParseFiles(TasksLabelsPageList, TemplatePage)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		errStr := ""
		infStr := ""
		var tasksLabelsHtml TasksLabelsHtml
		var labels []postgres.Label
		var tasks []postgres.TaskView
		var tasksLabels []postgres.TaskLabelView

		//insert, update, delete data
		if strings.Contains(requestData.Action, "tasksLabels_") {
			id, err := DBase.IUDTasksLabels(requestData.Action, requestData.Value)
			if err != nil || id == 0 {
				errStr = fmt.Sprintf("Error %v: %v %v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, err)
				logger.SetLogError(fmt.Errorf(errStr))
			} else {
				infStr = fmt.Sprintf("Info %v: %v id=%v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, id)
				logger.SetLogInform(fmt.Errorf(infStr))
			}
		}

		//select all data
		if (requestData.Action == "select_all_data") || requestData.Action == "select_filter_data" {
			tasksLabels, err = DBase.ViewTasksLabels(requestData.Value)
			if err != nil {
				errStr = err.Error()
				logger.SetLogError(fmt.Errorf(errStr))
			}
		}
		tasksLabelsHtml = TasksLabelsHtml{PageDescribe: "TasksLabels List", Error: errStr, Inform: infStr, Values: tasksLabels, ValuesLabels: labels, ValuesTasks: tasks}

		err = tmpl.Execute(w, tasksLabelsHtml)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		response := ""
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)

	}
}

func ServeHTTPFormTasksLabels(w http.ResponseWriter, r *http.Request) {

	tmpl, err := template.ParseFiles(TasksLabelsPage, TemplatePage)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// open page, load all tables
	// load tasks
	jsonData := `{
		"id": 0
	  }`
	var jsonDataMap map[string]interface{}
	err = json.Unmarshal([]byte(jsonData), &jsonDataMap)
	if err != nil {
		errStr := err.Error()
		logger.SetLogError(fmt.Errorf(errStr))
	}

	tasks, err := DBase.ViewTasks(jsonDataMap)
	if err != nil {
		errStr := err.Error()
		logger.SetLogError(fmt.Errorf(errStr))
	}

	//load labels
	labels, err := DBase.ViewLabels(jsonDataMap)
	if err != nil {
		errStr := err.Error()
		logger.SetLogError(fmt.Errorf(errStr))
	}

	data := TasksLabelsHtml{PageDescribe: "TasksLabels List", Error: "", Inform: "", Values: nil, ValuesLabels: labels, ValuesTasks: tasks}

	err = tmpl.Execute(w, data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	return
}
