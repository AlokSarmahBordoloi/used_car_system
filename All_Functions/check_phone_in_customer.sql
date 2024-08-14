create or replace FUNCTION check_phone_in_customer(cphone NUMBER)
RETURN NUMBER
IS
v_count NUMBER;
BEGIN
    SELECT PHONE
    INTO v_count
    FROM CUSTOMER
    WHERE PHONE = cphone;

    IF v_count = cphone THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;

END check_phone_in_customer;
