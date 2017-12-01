CREATE TABLE salons (
  "salon_id" NUMBER PRIMARY KEY,
  "location" VARCHAR2(64) NOT NULL
);

CREATE TABLE service_type (
  "service_id"    NUMBER PRIMARY KEY,
  "services_type" VARCHAR2(32) NOT NULL,
  "description"   VARCHAR2(64) NOT NULL,
  "price"         NUMBER       NOT NULL
);
CREATE TABLE position (
  "position_id" NUMBER PRIMARY KEY,
  "pos_name"    VARCHAR2(32) NOT NULL,
  "function"    VARCHAR2(32)
);

CREATE TABLE employees (
  "empl_id"     NUMBER PRIMARY KEY,
  "photo"       BLOB,
  "empl_name"   VARCHAR2(32) NOT NULL,
  "birth_date"  DATE         NOT NULL,
  "phone"       NUMBER       NOT NULL,
  "position_id" NUMBER       NOT NULL,
  CONSTRAINT position_key
  FOREIGN KEY ("position_id") REFERENCES position ("position_id")
  ON DELETE CASCADE
);

CREATE TABLE client (
  "client_id"   NUMBER PRIMARY KEY,
  "client_name" VARCHAR2(64) NOT NULL,
  "phone"       VARCHAR2(64)
);

CREATE TABLE dog (
  "dog_id"    NUMBER PRIMARY KEY,
  "dog_name"  VARCHAR2(64) NOT NULL,
  "dog_breed" VARCHAR2(32) NOT NULL,
  "client_id" NUMBER,
  CONSTRAINT client_id_key
  FOREIGN KEY ("client_id") REFERENCES client ("client_id") ON DELETE CASCADE,
  "weight"    NUMBER,
  "age"       NUMBER,
  "sex"       VARCHAR2(64)
);

CREATE TABLE salary (
  "empl_id" NUMBER NOT NULL,
  CONSTRAINT empl_id_key
  FOREIGN KEY ("empl_id") REFERENCES employees ("empl_id") ON DELETE CASCADE,
  "salary"  NUMBER NOT NULL
);

CREATE TABLE timetable (
  id              NUMBER PRIMARY KEY,
  "salon_id"      NUMBER,
  CONSTRAINT salon_id_keys
  FOREIGN KEY ("salon_id") REFERENCES salons ("salon_id") ON DELETE CASCADE,

  "service_id"    NUMBER,
  CONSTRAINT service_id_keys
  FOREIGN KEY ("service_id") REFERENCES service_type ("service_id") ON DELETE CASCADE,

  "empl_id"       NUMBER,
  CONSTRAINT empl_id_keys
  FOREIGN KEY ("empl_id") REFERENCES employees ("empl_id") ON DELETE CASCADE,
  "client_id"     NUMBER,
  CONSTRAINT client_id_keys
  FOREIGN KEY ("client_id") REFERENCES client ("client_id") ON DELETE CASCADE,
  "date_and_time" TIMESTAMP,
  "dog_id"        NUMBER,
  CONSTRAINT dog_id_keys
  FOREIGN KEY ("dog_id") REFERENCES dog ("dog_id") ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER date_and_time_constraint
BEFORE INSERT OR UPDATE ON timetable
FOR EACH ROW
  BEGIN
    IF :NEW."date_and_time" < CURRENT_TIMESTAMP
    THEN
      RAISE_APPLICATION_ERROR(-2, 'Invalid date_and_time : must be after current timestamp');
    END IF;
  END;


CREATE SEQUENCE timetable_seq
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE OR REPLACE TRIGGER timetable_id_trg
BEFORE INSERT OR UPDATE ON timetable
FOR EACH ROW
  BEGIN
    IF :new.id IS NULL
    THEN
      SELECT timetable_seq.nextval
      INTO :new.id
      FROM dual;
    END IF;
  END;
CREATE TABLE payment (
  "payment_id"      NUMBER PRIMARY KEY,
  "type_of_payment" VARCHAR2(64) NOT NULL,
  "payment_system"  VARCHAR2(64),
  "bank_of_card"    VARCHAR2(64),
  CONSTRAINT type_oper
  CHECK (("type_of_payment" = 'cash'
          AND "payment_system"
              IS NULL AND
          "bank_of_card" IS NULL) OR
         ("type_of_payment" = 'card'
          AND "payment_system"
              IS NOT NULL AND
          "bank_of_card" IS NOT NULL))

);

CREATE TABLE history (
  "history_id" NUMBER,
  CONSTRAINT history_id_keys
  FOREIGN KEY ("history_id") REFERENCES timetable (id) ON DELETE CASCADE,
  "payment_id" NUMBER,
  CONSTRAINT payment_id_key
  FOREIGN KEY ("payment_id") REFERENCES payment ("payment_id") ON DELETE CASCADE
);
--------------------- INSEART ----------------------
INSERT INTO salons ("salon_id", "location") VALUES (1, 'Парк Победы');
INSERT INTO salons ("salon_id", "location") VALUES (2, 'Горьковская');
INSERT INTO salons ("salon_id", "location") VALUES (3, 'Петроградская');
INSERT INTO salons ("salon_id", "location") VALUES (4, 'Адмиралтейская');
INSERT INTO salons ("salon_id", "location") VALUES (5, 'Приморская');

INSERT INTO service_type ("service_id", "services_type", "description", "price") VALUES
  (1, 'Мытье', 'Мытье собаки шампунем и кондиционером', 500);
INSERT INTO service_type ("service_id", "services_type", "description", "price") VALUES
  (2, 'Стрижка', 'Стрижка собаки под машинку', 1800);
INSERT INTO service_type ("service_id", "services_type", "description", "price") VALUES
  (3, 'Модельная стрижка', 'Стржка собаки в определенной форме', 2300);
INSERT INTO service_type ("service_id", "services_type", "description", "price") VALUES
  (4, 'Стрижка когтей', 'Стрижка отросших когтей', 200);
INSERT INTO service_type ("service_id", "services_type", "description", "price") VALUES
  (5, 'Чистка зубов', 'ультразвуковая чистка камней', 1200);

INSERT INTO position ("position_id", "pos_name", "function") VALUES
  (1, 'Груммер', 'Стрижка собак');
INSERT INTO position ("position_id", "pos_name", "function") VALUES
  (2, 'Кассир', 'Расчет клиентов на кассе');
INSERT INTO position ("position_id", "pos_name", "function") VALUES
  (3, 'Охранник', 'Охрана помещения');
INSERT INTO position ("position_id", "pos_name", "function") VALUES
  (4, 'Администратор', 'Прием на работу груммеров');
INSERT INTO position ("position_id", "pos_name", "function") VALUES
  (5, 'Оператор', 'Запись на прием');

INSERT INTO employees ("empl_id", "photo", "empl_name", "birth_date", "phone", "position_id") VALUES
  (1, NULL, 'Татьяна', '11-12-1993', '89219294098', 1);
INSERT INTO employees ("empl_id", "photo", "empl_name", "birth_date", "phone", "position_id") VALUES
  (2, NULL, 'Екатерина', '19-05-1990', '89112345465', 2);
INSERT INTO employees ("empl_id", "photo", "empl_name", "birth_date", "phone", "position_id") VALUES
  (3, NULL, 'Алексей', '06-09-1989', '89968879323', 4);
INSERT INTO employees ("empl_id", "photo", "empl_name", "birth_date", "phone", "position_id") VALUES
  (4, NULL, 'Андрей', '03-01-1987', '89217778799', 5);
INSERT INTO employees ("empl_id", "photo", "empl_name", "birth_date", "phone", "position_id") VALUES
  (5, NULL, 'Всеволод', '01-01-1988', '89219923232', 3);


INSERT INTO client ("client_id", "client_name", "phone") VALUES
  (1, 'Анна', '89967726506');
INSERT INTO client ("client_id", "client_name", "phone") VALUES
  (2, 'Евгений', '89219294565');
INSERT INTO client ("client_id", "client_name", "phone") VALUES
  (3, 'Антон', '89321234343');
INSERT INTO client ("client_id", "client_name", "phone") VALUES
  (4, 'Дарья', '89356547689');
INSERT INTO client ("client_id", "client_name", "phone") VALUES
  (5, 'Александра', '89453211234');
INSERT INTO client ("client_id", "client_name", "phone") VALUES
  (6, 'Надежда', '89113456578');

INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex") VALUES
  (1, 'Эмми', 'Йоркширский терьер', 1, 2.5, 1, 'девочка');
INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex") VALUES
  (2, 'Джудди', 'Шпиц', 6, 2, 2, 'девочка');
INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex") VALUES
  (3, 'Шелдон', 'Чихухуа', 4, 3, 4, 'мальчик');
INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex") VALUES
  (4, 'Леонард', 'Питбуль', 3, 18, 3, 'мальчик');
INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex") VALUES
  (5, 'Пенни', 'Золотистый ретривер', 2, 16, 4, 'девочка');
INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex") VALUES
  (6, 'Корица', 'Йоркширский терьер', 5, 2, 2, 'девочка');

INSERT INTO salary ("empl_id", "salary") VALUES (1, 50000);
INSERT INTO salary ("empl_id", "salary") VALUES (2, 35000);
INSERT INTO salary ("empl_id", "salary") VALUES (3, 28000);
INSERT INTO salary ("empl_id", "salary") VALUES (4, 55000);
INSERT INTO salary ("empl_id", "salary") VALUES (5, 20000);

INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (1, 2, 1, 1, to_date('2017-12-11 17:00', 'YYYY-MM-DD HH24:MI'), 1);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (2, 1, 2, 2, to_date('2017-12-11 11:00', 'YYYY-MM-DD HH24:MI'), 2);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (3, 5, 3, 3, to_date('2017-12-16 19:00', 'YYYY-MM-DD HH24:MI'), 3);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (4, 3, 4, 4, to_date('2017-12-31 9:00', 'YYYY-MM-DD HH24:MI'), 4);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (5, 4, 5, 5, to_date('2017-12-27 16:00', 'YYYY-MM-DD HH24:MI'), 5);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (1, 1, 2, 6, to_date('2017-12-22 16:00', 'YYYY-MM-DD HH24:MI'), 6);

INSERT INTO payment ("payment_id", "type_of_payment", "payment_system", "bank_of_card") VALUES
  (1, 'card', 'mc', 'rocket');
INSERT INTO payment ("payment_id", "type_of_payment", "payment_system", "bank_of_card") VALUES
  (2, 'cash', NULL, NULL);

INSERT INTO history ("history_id", "payment_id") VALUES (1, 1);
INSERT INTO history ("history_id", "payment_id") VALUES (2, 2);

----------------------------- CRUD ------------------------------

CREATE OR REPLACE PACKAGE temp AS
  ids NUMBER;

  -- SALONS --
  PROCEDURE add_salons(salons_id NUMBER, s_location VARCHAR2);

  TYPE SALONS_REC IS RECORD (
    s_salon_id NUMBER,
    s_locations VARCHAR2(64)
  );
  TYPE SALONS_LIST IS TABLE OF SALONS_REC;
  FUNCTION get_salons(s_salon_id NUMBER, s_locations VARCHAR2)
    RETURN SALONS_LIST PIPELINED;

  FUNCTION delete_salons(s_salon_id NUMBER, s_locations VARCHAR2)
    RETURN NUMBER;

  PROCEDURE update_salons(salons_id NUMBER, s_location VARCHAR2);

  -- SERVICE_TYPE
  PROCEDURE add_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER);

  TYPE SERVICE_TYPE_REC IS RECORD (
    s_service_id NUMBER,
    s_services_type VARCHAR2(64),
    s_description VARCHAR2(64),
    s_price NUMBER
  );
  TYPE SERVICE_TYPE_LIST IS TABLE OF SERVICE_TYPE_REC;

  FUNCTION get_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER)
    RETURN SERVICE_TYPE_LIST PIPELINED;

  FUNCTION delete_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER)
    RETURN NUMBER;

  PROCEDURE update_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER);

  -- POSITION
  PROCEDURE add_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2);

  TYPE POSITION_REC IS RECORD (
    s_position_id NUMBER,
    s_pos_name VARCHAR2(64),
    s_function VARCHAR2(64)
  );
  TYPE POSITION_LIST IS TABLE OF POSITION_REC;

  FUNCTION get_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2)
    RETURN POSITION_LIST PIPELINED;

  FUNCTION delete_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2)
    RETURN NUMBER;

  PROCEDURE update_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2);

  -- EMPLOYEES
  PROCEDURE add_employees(s_empl_id     NUMBER, s_empl_name VARCHAR2, s_birth_date DATE, s_phone NUMBER,
                          s_position_id NUMBER);

  TYPE EMPLOYEES_REC IS RECORD (
    s_empl_id NUMBER,
    s_empl_name VARCHAR2(64),
    s_birth_date DATE,
    s_phone NUMBER,
    s_position_id NUMBER );
  TYPE EMPLOYEES_LIST IS TABLE OF EMPLOYEES_REC;

  FUNCTION get_employees(s_empl_id    NUMBER, s_empl_name VARCHAR2,
                         s_birth_date DATE, s_phone NUMBER, s_position_id NUMBER)
    RETURN EMPLOYEES_LIST PIPELINED;

  FUNCTION delete_employees(s_empl_id    NUMBER, s_empl_name VARCHAR2,
                            s_birth_date DATE, s_phone NUMBER, s_position_id NUMBER)
    RETURN NUMBER;

  PROCEDURE update_employees(s_empl_id    NUMBER, s_empl_name VARCHAR2,
                             s_birth_date DATE, s_phone NUMBER, s_position_id NUMBER);

  -- CLIENT
  PROCEDURE add_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2);

  TYPE CLIENT_REC IS RECORD (
    s_client_id NUMBER,
    s_client_name VARCHAR2(64),
    s_phone VARCHAR2(64)
  );
  TYPE CLIENT_LIST IS TABLE OF CLIENT_REC;

  FUNCTION get_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2)
    RETURN CLIENT_LIST PIPELINED;

  FUNCTION delete_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2)
    RETURN NUMBER;

  PROCEDURE update_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2);

  -- DOG
  PROCEDURE add_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                    s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2);

  TYPE DOG_REC IS RECORD (
    s_dog_id NUMBER,
    s_dog_name VARCHAR2(64),
    s_dog_breed VARCHAR2(32),
    s_client NUMBER,
    s_weight NUMBER,
    s_age NUMBER,
    s_sex VARCHAR2(64)
  );
  TYPE DOG_LIST IS TABLE OF DOG_REC;

  FUNCTION get_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                   s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2)
    RETURN DOG_LIST PIPELINED;

  FUNCTION delete_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                      s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2)
    RETURN NUMBER;

  PROCEDURE update_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                       s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2);

  -- SALARY
  PROCEDURE add_salary(s_empl_id NUMBER, s_salary NUMBER);

  TYPE SALARY_REC IS RECORD (
    s_empl_id NUMBER,
    s_salary NUMBER
  );
  TYPE SALARY_LIST IS TABLE OF SALARY_REC;

  FUNCTION get_salary(s_empl_id NUMBER, s_salary NUMBER)
    RETURN SALARY_LIST PIPELINED;

  FUNCTION delete_salary(s_empl_id NUMBER, s_salary NUMBER)
    RETURN NUMBER;

  PROCEDURE update_salary(s_empl_id NUMBER, s_salary NUMBER);

  -- HISTORY

  PROCEDURE add_history(s_history_id NUMBER, s_payment_id NUMBER);

  TYPE HISTORY_REC IS RECORD (
    s_history_id NUMBER,
    s_payment_id NUMBER
  );
  TYPE HISTORY_LIST IS TABLE OF HISTORY_REC;

  FUNCTION get_history(s_history_id NUMBER, s_payment_id NUMBER)
    RETURN HISTORY_LIST PIPELINED;

  FUNCTION delete_history(s_history_id NUMBER, s_payment_id NUMBER)
    RETURN NUMBER;

  PROCEDURE update_history(s_history_id NUMBER, s_payment_id NUMBER);

END temp;

CREATE OR REPLACE PACKAGE BODY temp AS

  -- CREATE --

  PROCEDURE add_salons(salons_id NUMBER, s_location VARCHAR2) AS
    BEGIN
      INSERT INTO salons ("salon_id", "location") VALUES (salons_id, s_location);
    END add_salons;

  PROCEDURE add_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER) AS
    BEGIN
      INSERT INTO service_type ("service_id", "services_type", "description", "price")
      VALUES (s_service_id, s_services_type, s_description, s_price);
    END add_service_type;

  PROCEDURE add_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2) AS
    BEGIN
      INSERT INTO position ("position_id", "pos_name", "function") VALUES (s_position_id, s_pos_name, s_function);
    END add_position;

  PROCEDURE add_employees(s_empl_id     NUMBER, s_empl_name VARCHAR2, s_birth_date DATE, s_phone NUMBER,
                          s_position_id NUMBER) AS
    BEGIN
      INSERT INTO employees ("empl_id", "empl_name", "birth_date", "phone", "position_id")
      VALUES (s_empl_id, s_empl_name, s_birth_date, s_phone, s_position_id);
    END add_employees;

  PROCEDURE add_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2) AS
    BEGIN
      INSERT INTO client ("client_id", "client_name", "phone")
      VALUES (s_client_id, s_client_name, s_phone);
    END add_client;


  PROCEDURE add_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                    s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2) AS
    BEGIN
      INSERT INTO dog ("dog_id", "dog_name", "dog_breed", "client_id", "weight", "age", "sex")
      VALUES (s_dog_id, s_dog_name, s_dog_breed, s_client_id, s_weight, s_age, s_sex);
    END add_dog;

  PROCEDURE add_salary(s_empl_id NUMBER, s_salary NUMBER) AS
    BEGIN
      INSERT INTO salary ("empl_id", "salary") VALUES (s_empl_id, s_salary);
    END add_salary;

  PROCEDURE add_history(s_history_id NUMBER, s_payment_id NUMBER) AS
    BEGIN
      INSERT INTO history ("history_id", "payment_id") VALUES (s_history_id, s_payment_id);
    END add_history;

  -- SELECT --

  FUNCTION get_salons(s_salon_id IN NUMBER, s_locations IN VARCHAR2)
    RETURN SALONS_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        s."salon_id" salon_id,
        s."location" locations
      FROM salons s
      WHERE s."salon_id" = s_salon_id AND s."location" = s_locations)
      LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_salons;

  FUNCTION get_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER)
    RETURN SERVICE_TYPE_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        syst."service_id"    services_id,
        syst."services_type" services_type,
        syst."description"   description,
        syst."price"         price
      FROM service_type syst
      WHERE syst."service_id" = s_service_id AND syst."services_type" = s_services_type
            AND syst."description" = s_description AND syst."price" = s_price )
      LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_service_type;

  FUNCTION get_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2)
    RETURN POSITION_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        p."position_id" position_id,
        p."pos_name"    pos_name,
        p."function"    functions
      FROM position p
      WHERE p."position_id" = s_position_id AND p."pos_name" = s_pos_name AND p."function" = s_function)
      LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_position;

  FUNCTION get_employees(s_empl_id    NUMBER, s_empl_name VARCHAR2,
                         s_birth_date DATE, s_phone NUMBER, s_position_id NUMBER)
    RETURN EMPLOYEES_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        e."empl_id"     empl_id,
        e."empl_name"   empl_name,
        e."birth_date"  birth_date,
        e."phone"       phone,
        e."position_id" position_id
      FROM employees e
      WHERE e."empl_id" = s_empl_id AND e."empl_name" = s_empl_name
            AND e."birth_date" = s_birth_date AND e."phone" = s_phone AND e."position_id" = s_position_id )
      LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_employees;

  FUNCTION get_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2)
    RETURN CLIENT_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        cl."client_id"   client_id,
        cl."client_name" client_name,
        cl."phone"       phone
      FROM client cl
      WHERE cl."client_id" = s_client_id AND cl."client_name" = s_client_name AND cl."phone" = s_phone
      ) LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_client;

  FUNCTION get_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                   s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2)
    RETURN DOG_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        d."dog_id"    dog_id,
        d."dog_name"  dog_name,
        d."dog_breed" dog_breed,
        d."client_id" client_id,
        d."weight"    weight,
        d."age"       age,
        d."sex"       sex
      FROM dog d
      WHERE d."dog_id" = s_dog_id AND d."dog_name" = s_dog_name AND d."dog_breed" = s_dog_breed AND
            d."client_id" = s_client_id AND d."weight" = s_weight AND d."age" = s_age AND d."sex" = s_sex )
      LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_dog;


  FUNCTION get_salary(s_empl_id NUMBER, s_salary NUMBER)
    RETURN SALARY_LIST PIPELINED AS
    BEGIN
      FOR i IN (
      SELECT
        sal."empl_id" empl_id,
        sal."salary"  salary
      FROM salary sal
      WHERE sal."empl_id" = s_empl_id AND sal."salary" = s_salary )
      LOOP PIPE ROW (i);
      END LOOP;
      RETURN;
    END get_salary;

  FUNCTION get_history(s_history_id NUMBER, s_payment_id NUMBER)
    RETURN HISTORY_LIST PIPELINED AS
    BEGIN
      FOR i IN (
        SELECT h."history_id" history_id, h."payment_id" payment_id
        FROM history h
          WHERE h."history_id"=s_history_id AND h."payment_id"=s_payment_id)
        LOOP PIPE ROW (i);
        END LOOP;
        RETURN;
    END get_history;

  -- DELETE --
  FUNCTION delete_salons(s_salon_id NUMBER, s_locations VARCHAR2)
    RETURN NUMBER IS
  PRAGMA AUTONOMOUS_TRANSACTION;
    salon_id  NUMBER;
    locations VARCHAR2(64);
    BEGIN ids := 0;
      SELECT
        "salon_id",
        "location"
      INTO salon_id, locations
      FROM salons
      WHERE "salon_id" = s_salon_id AND "location" = s_locations;
      DELETE FROM salons
      WHERE salon_id = "salon_id" AND locations = "location"
      RETURNING "salon_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_salons;

  FUNCTION delete_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2, s_price NUMBER)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    service_ids    NUMBER;
    services_types VARCHAR2(64);
    descriptions   VARCHAR2(64);
    prices         NUMBER;
    BEGIN ids := 0;
      SELECT
        "service_id",
        "services_type",
        "description",
        "price"
      INTO service_ids, services_types, descriptions, prices
      FROM service_type
      WHERE "service_id" = s_service_id AND "services_type" = s_services_type
            AND "description" = s_description AND "price" = s_price;
      DELETE FROM service_type
      WHERE service_ids = "service_id"
            AND services_types = "services_type"
            AND descriptions = "description"
            AND prices = "price"
      RETURNING "service_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_service_type;

  FUNCTION delete_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    position_ids NUMBER;
    pos_names    VARCHAR2(64);
    functions    VARCHAR2(64);
    BEGIN ids := 0;
      SELECT
        "position_id",
        "pos_name",
        "function"
      INTO position_ids, pos_names, functions
      FROM position
      WHERE "position_id" = s_position_id AND "pos_name" = s_pos_name AND "function" = s_function;
      DELETE FROM position
      WHERE position_ids = "position_id" AND pos_names = "pos_name" AND functions = "function"
      RETURN "position_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_position;

  FUNCTION delete_employees(s_empl_id    NUMBER, s_empl_name VARCHAR2,
                            s_birth_date DATE, s_phone NUMBER, s_position_id NUMBER)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    empl_ids     NUMBER;
    empl_names   VARCHAR2(64);
    birth_dates  DATE;
    phones       NUMBER;
    position_ids NUMBER;
    BEGIN ids := 0;
      SELECT
        "empl_id",
        "empl_name",
        "birth_date",
        "phone",
        "position_id"
      INTO empl_ids, empl_names, birth_dates, phones, position_ids
      FROM employees
      WHERE "empl_id" = s_empl_id AND "empl_name" = s_empl_name
            AND "birth_date" = s_birth_date AND "phone" = s_phone AND "position_id" = s_position_id;
      DELETE FROM employees
      WHERE empl_ids = "empl_id" AND empl_names = "empl_name" AND birth_dates = "birth_date"
            AND phones = "phone" AND position_ids = "position_id"
      RETURN "empl_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_employees;

  FUNCTION delete_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    client_ids   NUMBER;
    client_names VARCHAR2(64);
    phones       VARCHAR2(64);
    BEGIN ids := 0;
      SELECT
        "client_id",
        "client_name",
        "phone"
      INTO client_ids, client_names, phones
      FROM client
      WHERE "client_id" = s_client_id AND "client_name" = s_client_name AND "phone" = s_phone;
      DELETE FROM client
      WHERE client_ids = "client_id" AND client_names = "client_name" AND phones = "phone"
      RETURN "client_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_client;

  FUNCTION delete_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                      s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    dog_ids    NUMBER;
    dog_names  VARCHAR2(64);
    dog_breeds VARCHAR2(32);
    clients    NUMBER;
    weights    NUMBER;
    ages       NUMBER;
    sexs       VARCHAR2(64);
    BEGIN ids := 0;
      SELECT
        "dog_id",
        "dog_name",
        "dog_breed",
        "client_id",
        "weight",
        "age",
        "sex"
      INTO
        dog_ids, dog_names, dog_breeds, clients, weights, ages, sexs
      FROM dog
      WHERE "dog_id" = s_dog_id AND "dog_name" = s_dog_name AND
            "dog_breed" = s_dog_breed AND "client_id" = s_client_id
            AND "weight" = s_weight AND "age" = s_age AND "sex" = s_sex;
      DELETE FROM dog
      WHERE dog_ids = "dog_id" AND dog_names = "dog_name" AND
            dog_breeds = "dog_breed" AND clients = "client_id" AND weights = "weight" AND
            ages = "age" AND sexs = "sex"
      RETURN "dog_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_dog;

  FUNCTION delete_salary(s_empl_id NUMBER, s_salary NUMBER)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    empl_ids NUMBER;
    salarys  NUMBER;
    BEGIN ids := 0;
      SELECT
        "empl_id",
        "salary"
      INTO empl_ids, salarys
      FROM salary
      WHERE "empl_id" = s_empl_id AND "salary" = s_salary;
      DELETE FROM salary
      WHERE empl_ids = "empl_id" AND salarys = "salary"
      RETURN "empl_id"
      INTO ids;
      COMMIT;
      RETURN ids;
    END delete_salary;

  FUNCTION delete_history(s_history_id NUMBER, s_payment_id NUMBER)
    RETURN NUMBER IS PRAGMA AUTONOMOUS_TRANSACTION;
    history_ids NUMBER;
    payment_ids NUMBER;
    BEGIN ids := 0;
      SELECT
        "history_id",
        "payment_id"
      INTO history_ids, payment_ids
      FROM history
      WHERE "history_id" = s_history_id AND "payment_id" = s_payment_id;
      DELETE FROM history
      WHERE history_ids = "history_id" AND payment_ids = "payment_id"
      RETURN "history_id" INTO ids;
      COMMIT;
      RETURN ids;
    END delete_history;

  -- UPDATE --
  PROCEDURE update_salons(salons_id NUMBER, s_location VARCHAR2) AS
    BEGIN
      UPDATE salons
      SET "location" = s_location
      WHERE (salons_id = "salon_id");
    END update_salons;

  PROCEDURE update_service_type(s_service_id NUMBER, s_services_type VARCHAR2, s_description VARCHAR2,
                                s_price      NUMBER) AS
    BEGIN
      UPDATE service_type
      SET "services_type" = s_services_type, "description" = s_description, "price" = s_price
      WHERE (s_service_id = "service_id");
    END update_service_type;

  PROCEDURE update_position(s_position_id NUMBER, s_pos_name VARCHAR2, s_function VARCHAR2) AS
    BEGIN
      UPDATE position
      SET "pos_name" = s_pos_name, "function" = s_function
      WHERE s_position_id = "position_id";
    END update_position;

  PROCEDURE update_employees(s_empl_id    NUMBER, s_empl_name VARCHAR2,
                             s_birth_date DATE, s_phone NUMBER, s_position_id NUMBER) AS
    BEGIN
      UPDATE employees
      SET "empl_id" = s_empl_id, "empl_name" = s_empl_name, "birth_date" = s_birth_date,
        "phone"     = s_phone, "position_id" = s_position_id
      WHERE s_empl_id = "empl_id";
    END update_employees;

  PROCEDURE update_client(s_client_id NUMBER, s_client_name VARCHAR2, s_phone VARCHAR2) AS
    BEGIN
      UPDATE client
      SET "client_id" = s_client_id, "client_name" = s_client_name, "phone" = s_phone
      WHERE s_client_id = "client_id";
    END update_client;

  PROCEDURE update_dog(s_dog_id NUMBER, s_dog_name VARCHAR2, s_dog_breed VARCHAR2, s_client_id NUMBER,
                       s_weight NUMBER, s_age NUMBER, s_sex VARCHAR2) AS
    BEGIN
      UPDATE dog
      SET "dog_name" = s_dog_name,
        "dog_breed"  = s_dog_breed, "client_id" = s_client_id,
        "weight"     = s_weight, "age" = s_age, "sex" = s_sex
      WHERE s_dog_id = "dog_id";
    END update_dog;

  PROCEDURE update_salary(s_empl_id NUMBER, s_salary NUMBER) AS
    BEGIN
      UPDATE salary
      SET "salary" = s_salary
      WHERE s_empl_id = "empl_id";
    END update_salary;

  PROCEDURE update_history(s_history_id NUMBER, s_payment_id NUMBER) AS
    BEGIN
      UPDATE history
      SET "payment_id" = s_payment_id
      WHERE s_history_id = "history_id";
    END update_history;
END temp;
------------------------------------- HOW TO USE -------------------------------------

--------------- SALONS --------------

-- ADD
BEGIN
  temp.add_salons(7, 'Крестовский остров');
END;

-- SELECT
SELECT *
FROM TABLE (temp.get_salons(7, 'Крестовский остров'));

-- DELETE
SELECT temp.delete_salons(7, 'Крестовский остров')
FROM dual;

-- UPDATE --
BEGIN
  temp.update_salons(1, 'Чернышевская');
END;


----------------  SERVICE_TYPE ---------------

-- ADD
BEGIN
  temp.add_service_type(6, 'стрижка лапок', 'стрижка шерсти меду подушечками', 150);
END;
-- SELECT
SELECT *
FROM TABLE (temp.get_service_type(6, 'стрижка лапок', 'стрижка шерсти меду подушечками', 160));
-- DELETE
SELECT temp.delete_service_type(6, 'стрижка лапок', 'стрижка шерсти меду подушечками', 150)
FROM dual;
-- UPDATE
BEGIN
  temp.update_service_type(6, 'стрижка лапок', 'стрижка шерсти меду подушечками', 160);
END;

------------- POSITION ---------------

-- ADD
BEGIN
  temp.add_position(6, 'Груммер', 'Стрижка собак');
END;
-- SELECT
SELECT *
FROM TABLE (temp.get_position(6, 'Груммер', 'Стрижка собак'));
-- DELETE
SELECT temp.delete_position(6, 'Груммер', 'Стрижка собак')
FROM dual;
-- UPDATE
BEGIN
  temp.update_position(6, 'Груммер', 'Модельная стрижка собак');
END;

------------ EMPLOYEES ---------------
-- ADD
BEGIN
  temp.add_employees(6, 'Эмми', '01-01-1989', 89002313232, 1);
END;
-- SELECT
SELECT *
FROM TABLE (temp.get_employees(6, 'Эмми', '01-01-1989', 89002313232, 1));
-- DELETE
SELECT temp.delete_employees(6, 'Эмми', '01-01-1989', 89002313232, 1)
FROM dual;
-- UPDATE
BEGIN
  temp.update_employees(6, 'Эмми', '01-01-1989', 89002313233, 1);
END;

------------ CLIENT ---------------
-- ADD
BEGIN
  temp.add_client(7, 'Говард', '89213233232');
END;
-- SELECT
SELECT *
FROM TABLE (temp.get_client(7, 'Говард', '89213233232'));
-- DELETE
SELECT temp.delete_client(7, 'Говард', '89213233232')
FROM dual;
-- UPDATE
BEGIN
  temp.update_client(7, 'Говард', '89213233200');
END;

------------ DOG ---------------
-- ADD
BEGIN
  temp.add_dog(7, 'Жуля', 'Йоркширский терьер', 5, 2, 2, 'девочка');
END;
-- SELECT
SELECT *
FROM TABLE (temp.get_dog(7, 'Жуля', 'Йоркширский терьер', 5, 2, 2, 'девочка'));
-- DELETE
SELECT temp.delete_dog(7, 'Жуля', 'Йоркширский терьер', 5, 2, 2, 'Девочка')
FROM dual;
-- UPDATE
BEGIN
  temp.update_dog(7, 'Жуля', 'Йоркширский терьер', 5, 2, 2, 'Мальчик');
END;

--------------- SALARY -------------
-- ADD
BEGIN
  temp.add_salary(6, 9000);
END;
-- SELECT
SELECT *
FROM TABLE (temp.get_salary(5, 20000));
-- DELETE
SELECT temp.delete_salary(6, 9000)
FROM dual;
-- UPDATE
BEGIN
  temp.update_salary(6, 9000);
END;

-- HISTORY
-- ADD
BEGIN
  temp.add_history(3, 1);
END;
-- SELECT
SELECT  * FROM TABLE (temp.get_history(3,1));
-- DELETE
SELECT temp.delete_history(3, 1) FROM dual;
-- UPDATE
BEGIN
  temp.update_history(3,2);
END;

COMMIT