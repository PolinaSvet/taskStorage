/*
	2024/07/11:	script generates data
*/

TRUNCATE TABLE stages, tasks_labels, tasks, labels, users;

-- Сбросьте значения всех последовательностей
DO $$DECLARE r RECORD;
BEGIN
  FOR r IN (SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public') LOOP
    EXECUTE 'SELECT setval(''' || r.sequence_name || ''', 1, false)';
  END LOOP;
END$$;


DO $$
DECLARE
  	i INT;
	str001 TEXT;
	str002 TEXT;
	bi001 TEXT;
	bi002 TEXT;
BEGIN
	
	--users: insert
	i:=1;
  	WHILE i <= 100 LOOP
		str001 := 'User_' || LPAD(i::TEXT, 10, '0');
    	PERFORM * FROM users_func_insert(('{
				  "name": "'||str001||'"
				}')::jsonb);
    	i := i + 1;
  	END LOOP;


	--labels: insert
	i:=1;
	WHILE i <= 100 LOOP
		str001 := 'Label_' || LPAD(i::TEXT, 10, '0');
    	PERFORM * FROM labels_func_insert(('{
				  "name": "'||str001||'"
				}')::jsonb);
    	i := i + 1;
  	END LOOP;

END;
$$;



