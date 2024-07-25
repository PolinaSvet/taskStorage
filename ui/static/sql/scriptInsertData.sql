/*
	script generates data
*/

TRUNCATE TABLE tasks_labels, tasks, labels, users;

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

	--tasks: insert
	i:=1;
	WHILE i <= 50 LOOP
		str001 := 'Title_' || LPAD(i::TEXT, 10, '0');
		str002 := 'Content_' || LPAD(i::TEXT, 10, '0');
		bi001 := (extract(epoch from now())::BIGINT- (i*2 * 24 * 60 * 60))*1000;
		bi002 := (extract(epoch from now())::BIGINT- (i*1 * 24 * 60 * 60))*1000;
    	PERFORM * FROM tasks_func_insert(('{
		  "dt_opened": '||bi001||',
		  "dt_closed_expect": '||bi002||',
		  "author_id": '||i||',
		  "assigned_id": '||(i+1)||',
		  "title": "'||str001||'",
		  "content": "'||str002||'"
		}')::jsonb);

		str001 := 'Title_' || LPAD((i+10)::TEXT, 10, '0');
		str002 := 'Content_' || LPAD((i+10)::TEXT, 10, '0');
		bi001 := (extract(epoch from now())::BIGINT*1000);
		bi002 := (extract(epoch from now())::BIGINT+ (i * 24 * 60 * 60))*1000;
    	PERFORM * FROM tasks_func_insert(('{
		  "dt_opened": '||bi001||',
		  "dt_closed_expect": '||bi002||',
		  "author_id": '||i||',
		  "assigned_id": '||(i)||',
		  "title": "'||str001||'",
		  "content": "'||str002||'"
		}')::jsonb);

    	i := i + 1;
  	END LOOP;

	--tasks_labels: insert
	i:=1;
	WHILE i <= 10 LOOP
    	PERFORM * FROM tasks_labels_func_insert(('{
		  		"task_id": '||i||',
		  		"label_id": '||i||'
				}')::jsonb);

		PERFORM * FROM tasks_labels_func_insert(('{
				  "task_id": '||i||',
				  "label_id": '||(i+1)||'
				}')::jsonb);
		
		PERFORM * FROM tasks_labels_func_insert(('{
				  "task_id": '||(i+5)||',
				  "label_id": '||(i+3)||'
				}')::jsonb);
    	i := i + 1;
  	END LOOP;

END;
$$;



