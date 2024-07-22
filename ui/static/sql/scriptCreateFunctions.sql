/*
	2024/07/11:	script to create procedures
*/
DROP FUNCTION IF EXISTS users_func_delete, users_func_update, users_func_insert, users_func_select;
DROP FUNCTION IF EXISTS labels_func_delete, labels_func_update, labels_func_insert, labels_func_select;

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

