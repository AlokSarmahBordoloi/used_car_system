create or replace FUNCTION is_phone_in_customer(cphone NUMBER)
RETURN NUMBER
IS
v_count NUMBER;
BEGIN
    IF REGEXP_LIKE(cphone, '^[6-9][0-9]{9}$') THEN

        SELECT COUNT(*)
        INTO v_count
        FROM CUSTOMER
        WHERE PHONE = cphone;

        IF v_count > 0 THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;


    ELSE
        RETURN 0;
    END IF;

    EXCEPTION
            WHEN NO_DATA_FOUND THEN
            RETURN 0;

END is_phone_in_customer;​
