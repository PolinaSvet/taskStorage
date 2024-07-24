/*
	script to create database structure
*/

DROP TABLE IF EXISTS tasks_labels, tasks, labels, users;

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
COMMENT ON TABLE users IS 'Table for storing users';

CREATE TABLE labels (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
COMMENT ON TABLE labels IS 'Table for storing labels';

CREATE TABLE tasks (
    id BIGSERIAL PRIMARY KEY,
    dt_opened BIGINT NOT NULL DEFAULT extract(epoch from now()), 
    dt_closed_expect BIGINT CHECK (dt_closed_expect > dt_opened), 
	dt_closed_finish BIGINT CHECK (dt_closed_finish > dt_opened), 
    author_id BIGINT REFERENCES users(id) DEFAULT 0, 
    assigned_id BIGINT REFERENCES users(id) DEFAULT 0, 
    title TEXT NOT NULL, 
    content TEXT NOT NULL,
	finish BOOL NOT NULL DEFAULT FALSE,
	delay BOOL NOT NULL DEFAULT FALSE
);
COMMENT ON TABLE tasks IS 'Table for storing tasks';
COMMENT ON COLUMN tasks.dt_closed_expect IS 'the task should be closed by this time';
COMMENT ON COLUMN tasks.dt_closed_finish IS 'real task closing time';
COMMENT ON COLUMN tasks.finish IS 'task completed';

CREATE TABLE tasks_labels (
	id BIGSERIAL PRIMARY KEY,
    task_id BIGINT REFERENCES tasks(id),
    label_id BIGINT REFERENCES labels(id)
);
COMMENT ON TABLE tasks_labels IS 'Table for storing many-to-many connection between tasks and labels';





