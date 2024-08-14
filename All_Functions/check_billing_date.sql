create or replace FUNCTION check_billing_date(billing_date_in IN DATE, reg_no IN VARCHAR2)
RETURN NUMBER
IS
    buying_date_used_car DATE;
BEGIN
    -- Retrieve the buying date of the car from the USED_CAR table
    SELECT BUYING_DATE INTO buying_date_used_car
    FROM USED_CAR
    WHERE REGISTRATION_NUMBER = reg_no;

    -- Check if the billing date is less than the buying date
    IF billing_date_in < buying_date_used_car THEN
        -- Billing date is less than the buying date, return 0 (invalid)
        RETURN 0;
    ELSE
        -- Billing date is greater than or equal to the buying date, return 1 (valid)
        RETURN 1;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle the case where no record is found for the given car ID
        RETURN 0;
END;
