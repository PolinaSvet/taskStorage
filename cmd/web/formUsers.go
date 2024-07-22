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

type UsersHtml struct {
	Error  string
	Inform string
	Values []postgres.User
}

func processHandlerFormUsersActions(w http.ResponseWriter, r *http.Request) {

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

		tmpl, err := template.ParseFiles(UseresPageList, TemplatePage)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		errStr := ""
		infStr := ""

		//insert, update, delete data
		if strings.Contains(requestData.Action, "users_") {
			id, err := DBase.IUDUsers(requestData.Action, requestData.Value)
			if err != nil || id == 0 {
				errStr = fmt.Sprintf("Error %v: %v %v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, err)
				logger.SetLogError(fmt.Errorf(errStr))
			} else {
				infStr = fmt.Sprintf("Info %v: %v id=%v", time.Now().Format("2006-01-02 15:04:05.000"), requestData, id)
				logger.SetLogInform(fmt.Errorf(infStr))
			}
		}

		//select all data
		users, err := DBase.SelectUsers(0)
		if err != nil {
			errStr = err.Error()
			logger.SetLogError(fmt.Errorf(errStr))
		}
		usersHtml_ := UsersHtml{Error: errStr, Inform: infStr, Values: users}

		err = tmpl.Execute(w, usersHtml_)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		response := ""
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)

	}
}

func ServeHTTPFormUsers(w http.ResponseWriter, r *http.Request) {

	tmpl, err := template.ParseFiles(UseresPage, TemplatePage)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	data := TypePage{PageDescribe: "Users List"}

	err = tmpl.Execute(w, data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	return
}
