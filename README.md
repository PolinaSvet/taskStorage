
# PostgreSQL + Go

<div align="center">
	<img src="https://i.ibb.co/YQQpSb3/tasks.jpg">
</div>

## Структура программы:

**1) PostgreSQL (сервер БД):**

На уровне сервера БД Выполняется основная работа с данными: вставка, обновление, удаление, выборка данных. Весь обмен между сервером приложений и БД происходит посредствам пользовательских функций с использованием json-формата входных параметров.

Используется следующая структура БД:

- Таблица (Пользователи) ***users***
Пользовательские функции для работы с таблицей:
***users_func_insert(jsonb)*** - вставка данных
***users_func_update(jsonb)*** - обновление данных
***users_func_delete(jsonb)*** - удаление данных
***users_func_view(jsonb)*** - выборка данных

- Таблица (Метки) ***labels***
Пользовательские функции для работы с таблицей:
***labels_func_insert(jsonb)*** - вставка данных
***labels_func_update(jsonb)*** - обновление данных
***labels_func_delete(jsonb)*** - удаление данных
***labels_func_view(jsonb)*** - выборка данных

- Таблица (Задачи) ***tasks***
Пользовательские функции для работы с таблицей:
***tasks_func_insert(jsonb)*** - вставка данных
***tasks_func_update(jsonb)*** - обновление данных
***tasks_func_delete(jsonb)*** - удаление данных
***tasks_func_view(jsonb)*** - выборка данных по фильтру
***tasks_func_insert_pack(jsonb)*** - создание массива задач
***tasks_func_delay()*** - проверка задач на успешность выполнения(просрочена поставленная задача или нет)

- Таблица (Связь многие-ко-многим между задачами и метками) ***tasks_labels***
Пользовательские функции для работы с таблицей:
***tasks_labels_func_insert(jsonb)*** - вставка данных
***tasks_labels_func_update(jsonb)*** - обновление данных
***tasks_labels_func_delete(jsonb)*** - удаление данных
***tasks_labels_func_view(jsonb)*** - выборка данных по фильтру

Для загрузки конфигурации БД используем следующие скрипты:

- ***ui\static\sql\scriptCreateTable.sql*** - создает таблицы БД
- ***ui\static\sql\scriptCreateFunctions.sql*** - создает пользовательские функции БД
- ***ui\static\sql\scriptInsertData.sql*** - заполняет таблицы тестовыми данными

  

**2) Go (сервер приложения)**

Получает данные от клиента (WEB-интерфейс), передаёт серверу БД. От сервера БД получает ответ и передает обратно клиенту.

Работа с сервером БД описана в отдельном пакете:
- ***cmd\pkg\storage\postgres\postgres.go***

Используется следующая структура:

- Таблица (Пользователи) ***users***, структура: ***type User struct***
Пользовательские функции для работы с таблицей:
**func (s *Storage) IUDUsers(nameFunction string, jsonRequest map[string]interface{}) (int, error)*** - вставка, обновление, удаление
**func (s *Storage) ViewUsers(jsonRequest map[string]interface{}) ([]User, error)*** - выборка данных

- Таблица (Метки) ***labels***, структура: ***type Label struct***
Пользовательские функции для работы с таблицей:
**func (s *Storage) IUDLabels(nameFunction string, jsonRequest map[string]interface{}) (int, error)*** - вставка, обновление, удаление
**func (s *Storage) ViewLabels(jsonRequest map[string]interface{}) ([]User, error)*** - выборка данных

- Таблица (Задачи) ***tasks***, структура: ***type TaskView struct***
Пользовательские функции для работы с таблицей:
**func (s *Storage) IUDTasks(nameFunction string, jsonRequest map[string]interface{}) (int, error)*** - вставка, обновление, удаление
**func (s *Storage) ViewTasks(jsonRequest map[string]interface{}) ([]TaskView, error)*** - выборка данных по фильтру
**func (s *Storage) LoadPackTasks(jsonRequest []map[string]interface{}) (int, error)*** - создание массива задач
**func (s *Storage) DelayTasks() (int, error)*** - проверка задач на успешность выполнения(просрочена поставленная задача или нет)

- Таблица (Связь многие-ко-многим между задачами и метками) ***tasks_labels***, структура: ***type TaskLabelView struct***
Пользовательские функции для работы с таблицей:
**func (s *Storage) IUDTasksLabels(nameFunction string, jsonRequest map[string]interface{}) (int, error)*** - вставка, обновление, удаление
**func (s *Storage) ViewTasksLabels(jsonRequest map[string]interface{}) ([]TaskLabelView, error)*** - выборка данных по фильтру

 Работа с клиентом описана:

- Таблица (Пользователи) ***users***:
***cmd\web\formUsers.go***

- Таблица (Метки) ***labels***:
***cmd\web\formLabels.go***

- Таблица (Задачи) ***tasks***:
***cmd\web\formTasks.go***

- Таблица (Связь многие-ко-многим между задачами и метками) ***tasks_labels***:
***cmd\web\formTasksLabels.go***

**3) HTML+JavaScript (WEB-интерфейс)**

Работа клиентa описана:

- Таблица (Пользователи) ***users***:
***ui\html\formUsers.html***
***ui\html\formUsersList.html***

- Таблица (Метки) ***labels***:
***ui\html\formLabels.html***
***ui\html\formLabelsList.html***

- Таблица (Задачи) ***tasks***:
***ui\html\formTasks.html***
***ui\html\formTasksList.html***

- Таблица (Связь многие-ко-многим между задачами и метками) ***tasks_labels***:
***ui\html\formTasksLabels.html***
***ui\html\formTasksLabelsList.html***

Дополнительно используются:
- ***ui\static\script\script.js***
- ***ui\static\json\test_file_load.json*** - файл для создания массива задач

## ТРЕБОВАНИЯ К СИСТЕМЕ:

+ Система должна хранить задачи, содержащие:Автора,Ответственного,Время создания,Время завершения,Название задачи,Текст задачи.
+ К задаче могут быть привязаны метки.
+ Система должна хранить список пользователей.
+ Система должна предоставлять REST API, позволяющий выполнять CRUD-операции с задачами по протоколу HTTP, используя формат сериализации JSON.
+ Система должна поддерживать операцию массового создания задач на основе JSON с массивом задач.

  

Задача: создать пакет, который бы позволял выполнять все требуемые приложению операции с БД.

К таким операциям согласно ТЗ, относятся:
+ Получение списка задач.
+ Получения информации о конкретной задаче по ее номеру.
+ Создание задачи.
+ Обновление задачи.
+ Удаление задачи.
+ Создание массива задач (ui\static\json\test_file_load.json).

ЗАДАНИЕ

Разработайте SQL-запрос, который бы создавал БД tasks со следующими таблицами:

+ Пользователи.
+ Метки.
+ Задачи.
+ Связь многие-ко-многим между задачами и метками.

ЗАДАНИЕ

Разработайте пакет, который бы предоставлял необходимые методы для работы с БД.

API пакета storage должен позволять:

+ Создавать новые задачи.
+ Получать список всех задач.
+ Получать список задач по автору.
+ Получать список задач по метке.
+ Обновлять задачу по id.
+ Удалять задачу по id.

Все выше перечисленные требования к системе учтены в проекте.

  

## Revision

  

- 1: add tables Users, Labels and functions for working with it
- 2: add table Tasks and functions for working with it
- 3: modified table Tasks and functions for working with it
- 4: add table Tasks_labels and functions for working with it
- 5: modified table Tasks add download task package
- 6: description

## Usage:

**1.Enter this command to start the program:**

go run .


**2.Open the web browser and go to:**

```sh

http://127.0.0.1:8080/ or  localhost:8080

```

## Authors:

@PolinaSvet

**!!! It is for test now !!!**