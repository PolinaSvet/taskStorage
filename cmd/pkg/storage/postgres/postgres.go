package postgres

import (
	"context"
	"fmt"

	"github.com/jackc/pgtype"
	"github.com/jackc/pgx/v4/pgxpool"
)

var mapFunctionSql = map[string]string{
	"users_insert":  "users_func_insert",
	"users_update":  "users_func_update",
	"users_delete":  "users_func_delete",
	"labels_insert": "labels_func_insert",
	"labels_update": "labels_func_update",
	"labels_delete": "labels_func_delete",
	"tasks_insert":  "tasks_func_insert",
	"tasks_update":  "tasks_func_update",
	"tasks_delete":  "tasks_func_delete",
}

// Хранилище данных.
type Storage struct {
	db *pgxpool.Pool
}

// Конструктор, принимает строку подключения к БД.
func New(constr string) (*Storage, error) {
	db, err := pgxpool.Connect(context.Background(), constr)
	if err != nil {
		return nil, err
	}
	s := Storage{
		db: db,
	}
	return &s, nil
}

func (s *Storage) Close() {
	s.db.Close()
}

type SqlResponse struct {
	ID  int    `json:"id"`
	Err string `json:"err"`
}

// Table: User
type User struct {
	Id   int
	Name string
}

func (s *Storage) IUDUsers(nameFunction string, jsonRequest map[string]interface{}) (int, error) {

	funcSql, ok := mapFunctionSql[nameFunction]
	if !ok {
		return 0, fmt.Errorf("error: no name function %s", nameFunction)
	}

	var jsonResponse SqlResponse
	err := s.db.QueryRow(context.Background(), "SELECT * FROM "+funcSql+"($1)", jsonRequest).Scan(&jsonResponse)
	if err != nil {
		return 0, err
	}
	if jsonResponse.Err != "" {
		return 0, fmt.Errorf(jsonResponse.Err)
	}
	return jsonResponse.ID, nil
}

func (s *Storage) SelectUsers(userId int) ([]User, error) {
	rows, err := s.db.Query(context.Background(), `
		SELECT * FROM users_func_select($1);
	`,
		userId,
	)
	if err != nil {
		return nil, err
	}
	var user []User
	for rows.Next() {
		var t User
		err = rows.Scan(
			&t.Id,
			&t.Name,
		)
		if err != nil {
			return nil, err
		}
		user = append(user, t)
	}
	return user, rows.Err()
}

// Table: Labels
type Label struct {
	Id   int
	Name string
}

func (s *Storage) IUDLabels(nameFunction string, jsonRequest map[string]interface{}) (int, error) {

	funcSql, ok := mapFunctionSql[nameFunction]
	if !ok {
		return 0, fmt.Errorf("error: no name function %s", nameFunction)
	}

	var jsonResponse SqlResponse
	err := s.db.QueryRow(context.Background(), "SELECT * FROM "+funcSql+"($1)", jsonRequest).Scan(&jsonResponse)
	if err != nil {
		return 0, err
	}
	if jsonResponse.Err != "" {
		return 0, fmt.Errorf(jsonResponse.Err)
	}
	return jsonResponse.ID, nil
}

func (s *Storage) SelectLabels(labelId int) ([]Label, error) {
	rows, err := s.db.Query(context.Background(), `
		SELECT * FROM labels_func_select($1);
	`,
		labelId,
	)
	if err != nil {
		return nil, err
	}
	var label []Label
	for rows.Next() {
		var t Label
		err = rows.Scan(
			&t.Id,
			&t.Name,
		)
		if err != nil {
			return nil, err
		}
		label = append(label, t)
	}
	return label, rows.Err()
}

// Table: Tasks
type TaskView struct {
	Id                   int
	Dt_opened            string
	Dt_closed_expect     string
	Dt_closed_finish     string
	Author               string
	Assigned             string
	Title                string
	Content              string
	Finish               bool
	Delay                bool
	Label_names          []string
	Dt_closed_expect_int int
	Dt_closed_finish_int int
	Author_id            int
	Assigned_id          int
}

func (s *Storage) IUDTasks(nameFunction string, jsonRequest map[string]interface{}) (int, error) {

	funcSql, ok := mapFunctionSql[nameFunction]
	if !ok {
		return 0, fmt.Errorf("error: no name function %s", nameFunction)
	}

	var jsonResponse SqlResponse
	err := s.db.QueryRow(context.Background(), "SELECT * FROM "+funcSql+"($1)", jsonRequest).Scan(&jsonResponse)
	if err != nil {
		return 0, err
	}
	if jsonResponse.Err != "" {
		return 0, fmt.Errorf(jsonResponse.Err)
	}
	return jsonResponse.ID, nil
}

func (s *Storage) ViewTasks(jsonRequest map[string]interface{}) ([]TaskView, error) {
	rows, err := s.db.Query(context.Background(), `
		SELECT * FROM tasks_func_view($1);
	`,
		jsonRequest,
	)

	if err != nil {
		return nil, err
	}

	var task []TaskView
	var labelNamesJSON pgtype.TextArray

	for rows.Next() {
		var t TaskView
		err = rows.Scan(
			&t.Id,
			&t.Dt_opened,
			&t.Dt_closed_expect,
			&t.Dt_closed_finish,
			&t.Author,
			&t.Assigned,
			&t.Title,
			&t.Content,
			&t.Finish,
			&t.Delay,
			&labelNamesJSON,
			&t.Dt_closed_expect_int,
			&t.Dt_closed_finish_int,
			&t.Author_id,
			&t.Assigned_id,
		)
		if err != nil {
			return nil, err
		}

		labelNames := make([]string, len(labelNamesJSON.Elements))
		for i, elem := range labelNamesJSON.Elements {
			labelNames[i] = elem.String
		}
		t.Label_names = labelNames

		task = append(task, t)
	}
	return task, rows.Err()
}

func (s *Storage) DelayTasks() (int, error) {

	var jsonResponse SqlResponse
	err := s.db.QueryRow(context.Background(), "SELECT * FROM tasks_func_delay();").Scan(&jsonResponse)
	if err != nil {
		return 0, err
	}
	if jsonResponse.Err != "" {
		return 0, fmt.Errorf(jsonResponse.Err)
	}
	return jsonResponse.ID, nil
}
