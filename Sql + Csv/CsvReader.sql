DECLARE
  F UTL_FILE.FILE_TYPE;
  V_LINE VARCHAR2 (1000);
  V_LOAN_ID NUMBER(10,0);
  V_MEMBER_ID NUMBER(10,0);
  V_BOOK_ID NUMBER(10,0);
  V_REQUEST_DATE DATE;
  V_RETURN_DATE DATE;
  V_DETAILS VARCHAR2 (200);
  V_COUNTER INTEGER := 0;
 BEGIN
 	SAVEPOINT BEFORE_CSV_INSERT;
	F := UTL_FILE.FOPEN ('MYCSV', 'TEST.CSV', 'R');
	IF UTL_FILE.IS_OPEN(F) THEN
	  LOOP
	    BEGIN
	      UTL_FILE.GET_LINE(F, V_LINE, 1000);
	      IF V_LINE IS NULL THEN
	        EXIT;
	      END IF;
	      V_COUNTER := V_COUNTER + 1;
	      V_LOAN_ID := REGEXP_SUBSTR(V_LINE, '[^,]+', V_COUNTER, 1);
	      V_MEMBER_ID := REGEXP_SUBSTR(V_LINE, '[^,]+', V_COUNTER, 2);
	      V_BOOK_ID := REGEXP_SUBSTR(V_LINE, '[^,]+', V_COUNTER, 3);
	      V_REQUEST_DATE := REGEXP_SUBSTR(V_LINE, '[^,]+', V_COUNTER, 4);
	      V_RETURN_DATE := REGEXP_SUBSTR(V_LINE, '[^,]+', V_COUNTER, 5);
	      V_DETAILS := REGEXP_SUBSTR(V_LINE, '[^,]+', V_COUNTER, 6);
	      INSERT INTO ALL_LOANS VALUES(V_LOAN_ID, V_MEMBER_ID, V_BOOK_ID, V_REQUEST_DATE,V_RETURN_DATE,V_DETAILS);
	      COMMIT;
	    EXCEPTION
	    WHEN NO_DATA_FOUND THEN
	      DBMS_OUTPUT.PUT_LINE('ERROR OCCURED AT LINE ' || V_COUNTER);
	      ROLLBACK TO SAVEPOINT BEFORE_CSV_INSERT;
	      EXIT;
	    END;
	  END LOOP;
	END IF;
	UTL_FILE.FCLOSE(F);
END;
/
