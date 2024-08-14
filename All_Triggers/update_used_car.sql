create or replace TRIGGER update_used_car
BEFORE INSERT ON BILLS
FOR EACH ROW
DECLARE
    v_customer_id CUSTOMER.CUSTOMER_ID%TYPE;
    v_customer_name CUSTOMER.NAME%TYPE;
    v_car_id USED_CAR.CAR_ID%TYPE;
    v_dealer_id USED_CAR.DEALER_ID%TYPE;
    v_car_name USED_CAR.CAR_NAME%TYPE;
    v_car_discount USED_CAR.DISCOUNT%TYPE;
    v_dealer_name USED_CAR.DEALER_NAME%TYPE;
    v_car_mrp USED_CAR.RESALE_MRP%TYPE;
    v_discount USED_CAR.DISCOUNT%TYPE;
    p_amount USED_CAR.PURCHASE_AMOUNT%TYPE;
    v_sold_price USED_CAR.SOLD_PRICE%TYPE;
    v_profit USED_CAR.PROFIT%TYPE;
    new_reg_no BILLS.REGISTRATION_NUMBER%TYPE;
BEGIN
    new_reg_no := UPPER(:NEW.REGISTRATION_NUMBER);

    SELECT NAME INTO v_customer_name
    FROM CUSTOMER
    WHERE PHONE = :NEW.CUSTOMER_ID;


    SELECT u.RESALE_MRP, u.DISCOUNT, u.PURCHASE_AMOUNT, u.CAR_ID, u.DEALER_ID, u.CAR_NAME, u.DEALER_NAME,
           c.CUSTOMER_ID
    INTO v_car_mrp, v_discount, p_amount, v_car_id, v_dealer_id, v_car_name, v_dealer_name, v_customer_id
    FROM USED_CAR u
    JOIN CUSTOMER c ON c.PHONE = :NEW.CUSTOMER_ID
    WHERE u.REGISTRATION_NUMBER = new_reg_no;


    IF v_discount = NULL OR v_discount = '' THEN
        v_sold_price := v_car_mrp;
    ELSE
        v_sold_price := v_car_mrp - v_discount;
    END IF;


    v_profit := v_sold_price - p_amount;

    UPDATE USED_CAR
    SET ISAVAILABLE = 'SOLD',
        SOLD_PRICE = v_sold_price,
        PROFIT = v_profit
    WHERE REGISTRATION_NUMBER = new_reg_no;


    :NEW.CUSTOMER_ID := v_customer_id;
    :NEW.CUSTOMAR_NAME := v_customer_name;
    :NEW.CAR_ID := v_car_id;
    :NEW.ORIGINAL_PRICE := v_car_mrp;
    :NEW.DEALER_ID := v_dealer_id;
    :NEW.CAR_NAME := v_car_name;
    :NEW.DISCOUNT := v_discount;
    :NEW.DEALER_NAME := v_dealer_name;
    :NEW.AMOUNT_PAID := v_sold_price;


EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No record found for the provided registration number or customer phone number.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
