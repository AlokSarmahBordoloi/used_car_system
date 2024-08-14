create or replace FUNCTION check_is_admin(dealer_n_id NUMBER, p_email VARCHAR2)
RETURN NUMBER
IS
row_count NUMBER;
BEGIN
    IF REGEXP_LIKE(dealer_n_id, '^\d+$') AND REGEXP_LIKE(p_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN

        SELECT COUNT(*)
        INTO row_count
        FROM DEALER
        WHERE EMAIL = p_email AND DEALER_ID = dealer_n_id;

        IF row_count > 0 THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    ELSE
        RETURN 0;
    END IF;

END check_is_admin;
