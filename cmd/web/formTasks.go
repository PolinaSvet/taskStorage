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
	PageDescribe string
	Error        string
	Inform       string
	Values       []postgres.TaskView
	ValuesUsers  []postgres.User
	ValuesLabels []postgres.Label
}

func processHandlerFormTasksActions(w http.ResponseWriter, r *http.Request) {

	if r.URL.Path != "/formTasksList" {
		return
	}

	if r.Method == http.MethodPost {

		type RequestData struct {
			Action    string                   `json:"action"`
			Value     map[string]interface{}   `json:"value"`
			ValuePack []map[string]interface{} `json:"valuePack"`
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

		//fmt.Printf("%#v", requestData)

		errStr := ""
		infStr := ""
		var tasksHtml TasksHtml
		var users []postgres.User
		var labels []postgres.Label
		var tasks []postgres.TaskView

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

		//delay
		if requestData.Action == "check_delay" {
			id, err := DBase.DelayTasks()
			if err != nil || id == 0 {
				errStr = fmt.Sprintf("Error %v: %v %v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, err)
				logger.SetLogError(fmt.Errorf(errStr))
			} else {
				infStr = fmt.Sprintf("Info %v: %v id=%v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, id)
				logger.SetLogInform(fmt.Errorf(infStr))
			}
		}

		//load_pack_data
		if requestData.Action == "load_pack_data" {
			id, err := DBase.LoadPackTasks(requestData.ValuePack)
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
			tasks, err = DBase.ViewTasks(requestData.Value)
			if err != nil {
				errStr = err.Error()
				logger.SetLogError(fmt.Errorf(errStr))
			}
		}
		tasksHtml = TasksHtml{PageDescribe: "Tasks List", Error: errStr, Inform: infStr, Values: tasks, ValuesUsers: users, ValuesLabels: labels}

		err = tmpl.Execute(w, tasksHtml)
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

	// open page, load all tables
	// load useres
	jsonData := `{
		"id": 0
	  }`
	var jsonDataMap map[string]interface{}
	err = json.Unmarshal([]byte(jsonData), &jsonDataMap)
	if err != nil {
		errStr := err.Error()
		logger.SetLogError(fmt.Errorf(errStr))
	}

	users, err := DBase.ViewUsers(jsonDataMap)
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

	data := TasksHtml{PageDescribe: "Tasks List", Error: "", Inform: "", Values: nil, ValuesUsers: users, ValuesLabels: labels}

	err = tmpl.Execute(w, data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	return
}
