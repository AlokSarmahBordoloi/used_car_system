create or replace FUNCTION is_dealer_phone(v_phone NUMBER)
RETURN NUMBER
IS
v_count NUMBER;
BEGIN
    IF REGEXP_LIKE(v_phone, '^[6-9][0-9]{9}$') THEN
        SELECT COUNT(*)
        INTO v_count
        FROM DEALER
        WHERE PHONE = v_phone;

        IF v_count > 0 THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    ELSE
        RETURN 0;
    END IF;
END is_dealer_phone;
