create or replace TRIGGER before_insert_used_car
BEFORE INSERT ON USED_CAR
FOR EACH ROW
DECLARE
    prev_owner_id PREV_OWNER.PREV_OWNER_ID%TYPE;
    -- dealer_id DEALER.DEALER_ID%TYPE;
    dealer_name DEALER.NAME%TYPE;

    -- to format the make month and year inserted as 12-2007
    -- input_string VARCHAR2(10) := '04-2020';
    first_number VARCHAR2(2);
    second_number VARCHAR2(4);
    dash_position NUMBER;
    car_age USED_CAR.CAR_AGE%TYPE;


    -- buy_date USED_CAR.BUYING_DATE%TYPE;
    make_date DATE;
    make_year NUMBER;
    make_month NUMBER;
    age_years NUMBER;
    age_months NUMBER;
BEGIN

    dash_position := INSTR(:NEW.MAKE_MONTH_AND_YEAR, '-');

    first_number := SUBSTR(:NEW.MAKE_MONTH_AND_YEAR, 1, dash_position - 1);

    second_number := SUBSTR(:NEW.MAKE_MONTH_AND_YEAR, dash_position + 1);

    make_date := TO_DATE('01-' || first_number || '-' || second_number, 'DD-MM-YYYY');


    -- Assign make date (replace with actual date)
    -- make_date := TO_DATE('01-01-2015', 'DD-MM-YYYY');

    -- Extracting year and month from make date
    SELECT EXTRACT(YEAR FROM make_date), EXTRACT(MONTH FROM make_date)
    INTO make_year, make_month
    FROM DUAL;

    -- Current system date
    DECLARE
        current_date DATE;
    BEGIN
        current_date := SYSDATE;

        -- Extracting year and month from system date
        SELECT EXTRACT(YEAR FROM current_date), EXTRACT(MONTH FROM current_date)
        INTO age_years, age_months
        FROM DUAL;

        -- Calculating age in years and months
        age_years := age_years - make_year;
        age_months := age_months - make_month;

        -- Adjusting age if months are negative
        IF age_months < 0 THEN
            age_years := age_years - 1;
            age_months := 12 + age_months;
        END IF;
    END;


    IF :NEW.PREV_OWNER_ID IS NULL OR :NEW.PREV_OWNER_ID = '' THEN
        prev_owner_id := NULL;
    ELSE
        BEGIN
            SELECT PREV_OWNER_ID INTO prev_owner_id
            FROM PREV_OWNER
            WHERE PHONE = :NEW.PREV_OWNER_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                prev_owner_id := NULL;
        END;
    END IF;


    -- SELECT DEALER_ID INTO dealer_id
    -- FROM DEALER
    -- WHERE PHONE = :NEW.DEALER_ID;

    SELECT NAME INTO dealer_name
    FROM DEALER
    WHERE DEALER_ID = :NEW.DEALER_ID;


    IF :NEW.DISCOUNT = '' OR :NEW.DISCOUNT = NULL THEN
        :NEW.DISCOUNT := 0;
    END IF;

    :NEW.DEALER_NAME := dealer_name;
    -- :NEW.DEALER_ID := dealer_id;
    :NEW.PREV_OWNER_ID := prev_owner_id;

    :NEW.CAR_NAME := UPPER(:NEW.CAR_NAME);
    :NEW.MODEL := UPPER(:NEW.MODEL);
    :NEW.COLOR := UPPER(:NEW.COLOR);
    :NEW.REGISTRATION_NUMBER := UPPER(:NEW.REGISTRATION_NUMBER);
    :NEW.ISAVAILABLE := 'AVAILABLE';
    :NEW.CAR_AGE := age_years || '.' || age_months || ' years';


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'PREV_OWNER_ID or DEALER_ID not found in the respective tables.');
END;
