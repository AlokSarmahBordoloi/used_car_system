create or replace FUNCTION is_car_registered(car_reg_number VARCHAR2)
RETURN NUMBER
IS
    v_count NUMBER;
    v_issold_value VARCHAR2(30);
    v_car_reg_no VARCHAR2(30);
BEGIN
    v_car_reg_no := UPPER(car_reg_number);
    IF REGEXP_LIKE(v_car_reg_no, '^[A-Z]{2}\d{2}[A-Z]{2}\d{4}$') THEN

        SELECT COUNT(*)
        INTO v_count
        FROM USED_CAR
        WHERE REGISTRATION_NUMBER = v_car_reg_no;

        IF v_count > 0 THEN

            SELECT ISAVAILABLE
            INTO v_issold_value
            FROM USED_CAR
            WHERE REGISTRATION_NUMBER = v_car_reg_no;

            IF v_issold_value = 'SOLD' THEN
                    RETURN 1;
            ELSE
                    RETURN 0;
            END IF;
        ELSE
            RETURN 1;
        END IF;
    ELSE
        RETURN 0;
    END IF;
END is_car_registered;
