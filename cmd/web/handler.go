package cmd

import (
	"fmt"
	"log"
	"net/http"

	"taskdb/cmd/pkg/logger"
	"taskdb/cmd/pkg/storage/postgres"
)

const (
	ErrorPage    string = "ui/html/error.html"
	TemplatePage string = "ui/html/templates.html"
	ErrorLogPage string = "ui/html/errorLog.html"
	TasksPages   string = "ui/html/tasks.html"

	UseresPage     string = "ui/html/formUsers.html"
	UseresPageList string = "ui/html/formUsersList.html"
	LabelsPage     string = "ui/html/formLabels.html"
	LabelsPageList string = "ui/html/formLabelsList.html"
	TasksPage      string = "ui/html/formTasks.html"
	TasksPageList  string = "ui/html/formTasksList.html"
)

var DBase *postgres.Storage

type TypePage struct {
	PageDescribe string
}

type Err struct {
	Status int
	Text   string
}

type httpHandler struct {
	message  string
	pageName string
}

func Handler() {

	// Строка подключения к базе данных PostgreSQL
	connString := "postgres://postgres:root@localhost:5432/prgDbStorage"

	// Подключение к базе данных
	var err error
	DBase, err = postgres.New(connString)
	if err != nil {
		logger.SetLogError(err)
	}
	defer DBase.Close()

	//---------------------------------------------------------------------------

	mux := http.NewServeMux()
	fileServer := http.FileServer(http.Dir("ui"))
	log.Println("Запуск веб-сервера на http://127.0.0.1:8080")

	mux.Handle("/ui", http.NotFoundHandler())
	mux.Handle("/ui/", http.StripPrefix("/ui/", fileServer))

	mux.Handle("/", httpHandler{message: "/", pageName: TasksPage})
	mux.Handle("/tasks/", httpHandler{message: "/tasks/", pageName: TasksPage})

	mux.HandleFunc("/formUsers/", ServeHTTPFormUsers)
	mux.HandleFunc("/formUsersList", processHandlerFormUsersActions)

	mux.HandleFunc("/formLabels/", ServeHTTPFormLabels)
	mux.HandleFunc("/formLabelsList", processHandlerFormLabelsActions)

	mux.HandleFunc("/formTasks/", ServeHTTPFormTasks)
	mux.HandleFunc("/formTasksList", processHandlerFormTasksActions)

	mux.HandleFunc("/errorLog/", ServeHTTPerrorLog)

	fmt.Println("Server is listening...")
	err = http.ListenAndServe(":8080", mux)
	if err != nil {
		logger.SetLogError(fmt.Errorf("ERROR:Server not listening"))
	}

}
