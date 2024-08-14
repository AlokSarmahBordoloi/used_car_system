create or replace FUNCTION is_email_in_dealer(p_email VARCHAR2)
RETURN NUMBER
IS
email_count NUMBER;
BEGIN
    IF REGEXP_LIKE(p_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        SELECT COUNT(*)
        INTO email_count
        FROM DEALER
        WHERE EMAIL = p_email;
        IF email_count > 0 THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    ELSE
        RETURN 0;
    END IF;
END is_email_in_dealer;
