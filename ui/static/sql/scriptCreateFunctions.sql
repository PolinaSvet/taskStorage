/*
	script to create procedures
*/
DROP FUNCTION IF EXISTS users_func_delete, users_func_update, users_func_insert, users_func_select;
DROP FUNCTION IF EXISTS labels_func_delete, labels_func_update, labels_func_insert, labels_func_select;
DROP FUNCTION IF EXISTS tasks_func_delete, tasks_func_update, tasks_func_insert, tasks_func_select,tasks_func_view,tasks_func_delay;
DROP FUNCTION IF EXISTS tasks_labels_func_insert;

--=======================
--table: users
--=======================
--insert
CREATE FUNCTION users_func_insert(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	INSERT INTO users (name) VALUES ((json_data ->> 'name')::TEXT) RETURNING id INTO new_id;
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

--update
CREATE FUNCTION users_func_update(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	UPDATE users SET name = (json_data ->> 'name')::TEXT WHERE id = (json_data ->> 'id')::BIGINT RETURNING id INTO new_id; 
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;


--delete
CREATE FUNCTION users_func_delete(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	DELETE FROM users WHERE id = (json_data ->> 'id')::BIGINT; 

	SELECT json_build_object('id',(json_data ->> 'id')::BIGINT,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

--select
CREATE FUNCTION users_func_select(
		par_id BIGINT
) 
RETURNS TABLE (id BIGINT, name TEXT) AS $$
DECLARE
  	new_id BIGINT;
	new_err TEXT;
	func_name TEXT;
BEGIN
	RETURN QUERY
		SELECT users.id,
			   users.name   
		FROM users
		WHERE
			(par_id = 0 OR users.id = par_id)
		ORDER BY users.id;
END;
$$ LANGUAGE plpgsql;



--=======================
--table: labels
--=======================
--insert
CREATE FUNCTION labels_func_insert(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	INSERT INTO labels (name) VALUES ((json_data ->> 'name')::TEXT) RETURNING id INTO new_id;
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

--update
CREATE FUNCTION labels_func_update(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	UPDATE labels SET name = (json_data ->> 'name')::TEXT WHERE id = (json_data ->> 'id')::BIGINT RETURNING id INTO new_id; 
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;


--delete
CREATE FUNCTION labels_func_delete(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	DELETE FROM labels WHERE id = (json_data ->> 'id')::BIGINT; 

	SELECT json_build_object('id',(json_data ->> 'id')::BIGINT,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

--select
CREATE FUNCTION labels_func_select(
		par_id BIGINT
) 
RETURNS TABLE (id BIGINT, name TEXT) AS $$
DECLARE
  	new_id BIGINT;
	new_err TEXT;
	func_name TEXT;
BEGIN
	RETURN QUERY
		SELECT labels.id,
			   labels.name   
		FROM labels
		WHERE
			(par_id = 0 OR labels.id = par_id)
		ORDER BY labels.id;
END;
$$ LANGUAGE plpgsql;


--=======================
--table: tasks
--=======================
--insert
CREATE FUNCTION tasks_func_insert(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	INSERT INTO tasks (
		dt_opened, 
		dt_closed_expect, 
		author_id,
		assigned_id,
		title,
		content,
		finish
		) 
	VALUES (
		(json_data ->> 'dt_opened')::BIGINT, 
		(json_data ->> 'dt_closed_expect')::BIGINT, 
		(json_data ->> 'author_id')::BIGINT, 
		(json_data ->> 'assigned_id')::BIGINT,
		(json_data ->> 'title')::TEXT,
		(json_data ->> 'content')::TEXT,
		FALSE
		)
	RETURNING id INTO new_id;
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;


--update
CREATE FUNCTION tasks_func_update(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	UPDATE labels SET name = (json_data ->> 'name')::TEXT WHERE id = (json_data ->> 'id')::BIGINT RETURNING id INTO new_id; 
    
	UPDATE tasks SET 
		dt_closed_expect = CASE WHEN (json_data ->> 'dt_closed_expect') IS NOT NULL THEN (json_data ->> 'dt_closed_expect')::BIGINT ELSE dt_closed_expect END,
		author_id = CASE WHEN (json_data ->> 'author_id') IS NOT NULL THEN (json_data ->> 'author_id')::BIGINT ELSE author_id END,
		assigned_id = CASE WHEN (json_data ->> 'assigned_id') IS NOT NULL THEN (json_data ->> 'assigned_id')::BIGINT ELSE assigned_id END,
		title = CASE WHEN (json_data ->> 'title') IS NOT NULL THEN (json_data ->> 'title')::TEXT ELSE title END,
		content = CASE WHEN (json_data ->> 'content') IS NOT NULL THEN (json_data ->> 'content')::TEXT ELSE content END,
		finish = CASE WHEN (json_data ->> 'finish') IS NOT NULL THEN (json_data ->> 'finish')::BOOL ELSE finish END,
		dt_closed_finish = CASE 
	        WHEN (json_data ->> 'finish') IS NOT NULL AND (json_data ->> 'finish')::BOOL = true THEN extract(epoch from now())
	        WHEN (json_data ->> 'finish') IS NOT NULL AND (json_data ->> 'finish')::BOOL = false THEN NULL
	        ELSE dt_closed_finish
	    END
	WHERE 
		id = (json_data ->> 'id')::BIGINT
	RETURNING id INTO new_id;
	
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;


--delete
CREATE FUNCTION tasks_func_delete(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	DELETE FROM tasks_labels WHERE task_id = (json_data ->> 'id')::BIGINT; 

	DELETE FROM tasks WHERE id = (json_data ->> 'id')::BIGINT; 

	SELECT json_build_object('id',(json_data ->> 'id')::BIGINT,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

--update delay
CREATE FUNCTION tasks_func_delay(
) 
RETURNS jsonb AS $$
DECLARE
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	UPDATE tasks SET 
		delay = CASE 
			WHEN ((tasks.dt_closed_expect < extract(epoch from now())) AND (tasks.dt_closed_finish IS NULL)) 
					OR(tasks.dt_closed_expect < tasks.dt_closed_finish)
			THEN  TRUE
			ELSE FALSE END;
	
	SELECT json_build_object('id',0,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

--select
CREATE FUNCTION tasks_func_view(
		json_data jsonb
) 
RETURNS TABLE (
	id BIGINT,
    dt_opened TEXT, 
    dt_closed_expect TEXT, 
	dt_closed_finish TEXT, 
    author TEXT, 
    assigned TEXT, 
    title TEXT, 
    content TEXT,
	finish BOOL,
	delay BOOL,
	label_names TEXT[]
	
) AS $$
DECLARE
  	par_id BIGINT = 0;
    par_author_id BIGINT = 0;
    par_assigned_id BIGINT = 0;
    par_label_id BIGINT = 0;
	par_finish BOOL = NULL;
    par_delay BOOL = NULL;
    
	arr_task_label_id BIGINT[];
BEGIN

	IF (json_data ->> 'id') IS NOT NULL THEN
		par_id = (json_data ->> 'id')::BIGINT;
	END IF;

	IF (json_data ->> 'author_id') IS NOT NULL THEN
		par_author_id = (json_data ->> 'author_id')::BIGINT;
	END IF;

	IF (json_data ->> 'assigned_id') IS NOT NULL THEN
		par_assigned_id = (json_data ->> 'assigned_id')::BIGINT;
	END IF;

	IF (json_data ->> 'label_id') IS NOT NULL THEN
		par_label_id = (json_data ->> 'label_id')::BIGINT;
		arr_task_label_id := ARRAY(SELECT task_id 
							FROM tasks_labels 
							WHERE label_id = par_label_id);
	END IF;

	IF (json_data ->> 'finish') IS NOT NULL THEN
		par_finish = (json_data ->> 'finish')::BOOL;
	END IF;

	IF (json_data ->> 'delay') IS NOT NULL THEN
		par_delay = (json_data ->> 'delay')::BOOL;
	END IF;

	
	RETURN QUERY
		SELECT 
			tasks.id as id,
			COALESCE(TO_CHAR(TO_TIMESTAMP(tasks.dt_opened), 'DD.MM.YYYY HH24:MI:SS'), '') as dt_opened,
			COALESCE(TO_CHAR(TO_TIMESTAMP(tasks.dt_closed_expect), 'DD.MM.YYYY HH24:MI:SS'), '') as dt_closed_expect, 
			COALESCE(TO_CHAR(TO_TIMESTAMP(tasks.dt_closed_finish), 'DD.MM.YYYY HH24:MI:SS'), '') as dt_closed_finish, 
			COALESCE((
				SELECT users.name 
				FROM   users 
				WHERE  users.id = tasks.author_id
			), '') as author,
			COALESCE((
				SELECT users.name 
				FROM users 
				WHERE users.id = tasks.assigned_id
			), '') as assigned,
			COALESCE(tasks.title, '') as title,
			COALESCE(tasks.content, '') as content,
			COALESCE(tasks.finish, FALSE) as finish,
		    COALESCE(tasks.delay, FALSE) as delay,
			(
				SELECT array_agg(labels.name) 
				FROM labels 
				JOIN tasks_labels ON labels.id = tasks_labels.label_id 
				WHERE tasks_labels.task_id = tasks.id
			) AS label_names
		FROM 
			tasks
		WHERE
			(par_id = 0 OR tasks.id = par_id) AND
			(par_author_id = 0 OR tasks.author_id = par_author_id) AND 
			(par_assigned_id = 0 OR tasks.assigned_id = par_assigned_id) AND
			(arr_task_label_id IS NULL or tasks.id = ANY (arr_task_label_id)) AND
			(par_finish IS NULL OR tasks.finish = par_finish) AND
			(par_delay IS NULL OR tasks.delay = par_delay)
		ORDER BY 
			tasks.id;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION tasks_func_select(
		par_id BIGINT
) 
RETURNS TABLE (id BIGINT, title TEXT) AS $$
DECLARE
  	new_id BIGINT;
	new_err TEXT;
	func_name TEXT;
BEGIN
	RETURN QUERY
		SELECT tasks.id,
			   tasks.title   
		FROM tasks
		WHERE
			(par_id = 0 OR tasks.id = par_id)
		ORDER BY tasks.id;
END;
$$ LANGUAGE plpgsql;


--=======================
--table: tasks_labels
--=======================
--insert
CREATE FUNCTION tasks_labels_func_insert(
		json_data jsonb
) 
RETURNS jsonb AS $$
DECLARE
  	new_id BIGINT;
	err_mess TEXT;
	err_context TEXT;
	json_result jsonb;
BEGIN

	INSERT INTO tasks_labels (
		task_id, 
		label_id
	) 
	VALUES (
		(json_data ->> 'task_id')::BIGINT,
		(json_data ->> 'label_id')::BIGINT
	)
	RETURNING id INTO new_id;
	
	IF new_id IS NULL THEN
		RAISE EXCEPTION 'Parameter value cannot be null';
	END IF;

	SELECT json_build_object('id',new_id,'err','') INTO json_result;
  	RETURN json_result;

EXCEPTION
    WHEN others THEN
		GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
    	GET STACKED DIAGNOSTICS err_mess = MESSAGE_TEXT;

        SELECT json_build_object('id',null,'err',err_mess||err_context) INTO json_result;
  		RETURN json_result;  
END;
$$ LANGUAGE plpgsql;

