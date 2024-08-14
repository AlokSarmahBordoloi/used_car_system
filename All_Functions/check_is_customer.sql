create or replace FUNCTION check_is_customer(c_id NUMBER, c_email VARCHAR2)
RETURN NUMBER
IS
row_count NUMBER;
BEGIN
    IF REGEXP_LIKE(c_id, '^\d+$') AND REGEXP_LIKE(c_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN

        SELECT COUNT(*)
        INTO row_count
        FROM CUSTOMER
        WHERE EMAIL = c_email AND CUSTOMER_ID = c_id;

        IF row_count > 0 THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    ELSE
        RETURN 0;
    END IF;

END check_is_customer;
