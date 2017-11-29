
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
  FOREIGN KEY ("position_id") REFERENCES position ("position_id")
);

CREATE TABLE client (
  "client_id"   NUMBER PRIMARY KEY,
  "client_name" VARCHAR2(64) NOT NULL,
  "salon_id"    NUMBER       NOT NULL,
  FOREIGN KEY ("salon_id") REFERENCES salons ("salon_id"),
  "phone"       VARCHAR2(64)
);

CREATE TABLE dog (
  "dog_id"    NUMBER PRIMARY KEY,
  "dog_name"  VARCHAR2(64) NOT NULL,
  "dog_breed" VARCHAR2(32) NOT NULL,
  "client_id" NUMBER,
  FOREIGN KEY ("client_id") REFERENCES client ("client_id"),
  "weight"    NUMBER,
  "age"       NUMBER,
  "sex"       VARCHAR2(64)
);
CREATE TABLE salary (
  "salon_id"    NUMBER NOT NULL,
  FOREIGN KEY ("salon_id") REFERENCES salons ("salon_id"),
  "position_id" NUMBER NOT NULL,
  FOREIGN KEY ("position_id") REFERENCES position ("position_id"),
  "salary"      NUMBER NOT NULL
);

CREATE TABLE timetable (
  id              NUMBER PRIMARY KEY,
  "salon_id"      NUMBER,
  FOREIGN KEY ("salon_id") REFERENCES salons ("salon_id"),
  "service_id"    NUMBER,
  FOREIGN KEY ("service_id") REFERENCES service_type ("service_id"),
  "empl_id"       NUMBER,
  FOREIGN KEY ("empl_id") REFERENCES employees ("empl_id"),
  "client_id"     NUMBER,
  FOREIGN KEY ("client_id") REFERENCES client ("client_id"),
  "date_and_time" TIMESTAMP ,
  "dog_id"        NUMBER,
  FOREIGN KEY ("dog_id") REFERENCES dog ("dog_id")
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
  FOREIGN KEY ("history_id") REFERENCES timetable (id),
  "payment_id" NUMBER,
  FOREIGN KEY ("payment_id") REFERENCES payment ("payment_id")
);

INSERT INTO salons("salon_id", "location") VALUES (1, 'Парк Победы');
INSERT INTO salons("salon_id", "location") VALUES (2, 'Горьковская');
INSERT INTO salons("salon_id", "location") VALUES (3, 'Петроградская');
INSERT INTO salons("salon_id", "location") VALUES (4, 'Адмиралтейская');
INSERT INTO salons("salon_id", "location") VALUES (5, 'Приморская');

INSERT INTO service_type("service_id", "services_type", "description", "price") VALUES
  (1, 'Мытье', 'Мытье собаки шампунем и кондиционером', 500);
INSERT INTO service_type("service_id", "services_type", "description", "price") VALUES
  (2, 'Стрижка', 'Стрижка собаки под машинку', 1800);
INSERT INTO service_type("service_id", "services_type", "description", "price") VALUES
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


INSERT INTO client ("client_id", "client_name", "salon_id", "phone") VALUES
  (1, 'Анна', 1, '89967726506');
INSERT INTO client ("client_id", "client_name", "salon_id", "phone") VALUES
  (2, 'Евгений', 5, '89219294565');
INSERT INTO client ("client_id", "client_name", "salon_id", "phone") VALUES
  (3, 'Антон', 3, '89321234343');
INSERT INTO client ("client_id", "client_name", "salon_id", "phone") VALUES
  (4, 'Дарья', 2, '89356547689');
INSERT INTO client ("client_id", "client_name", "salon_id", "phone") VALUES
  (5, 'Александра', 4, '89453211234');
INSERT INTO client ("client_id", "client_name", "salon_id", "phone") VALUES
  (6, 'Надежда', 1, '89113456578');

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

INSERT INTO salary ("salon_id", "position_id", "salary") VALUES (1, 1, 50000);
INSERT INTO salary ("salon_id", "position_id", "salary") VALUES (2, 2, 35000);
INSERT INTO salary ("salon_id", "position_id", "salary") VALUES (3, 3, 28000);
INSERT INTO salary ("salon_id", "position_id", "salary") VALUES (4, 4, 55000);
INSERT INTO salary ("salon_id", "position_id", "salary") VALUES (5, 5, 20000);

INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (1, 2, 1, 1, to_date('2017-12-11 17:00', 'YYYY-MM-DD HH24:MI'), 1);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (2, 1, 2, 2, to_date('2017-12-11 11:00', 'YYYY-MM-DD HH24:MI'), 2);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (3, 5, 3, 3, to_date('2017-12-16 19:00', 'YYYY-MM-DD HH24:MI'), 3);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (4, 3, 4, 4, to_date('2017-12-31 9:00', 'YYYY-MM-DD HH24:MI'), 4);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (5, 4,5, 5, to_date('2017-12-27 16:00', 'YYYY-MM-DD HH24:MI'), 5);
INSERT INTO timetable ("salon_id", "service_id", "empl_id", "client_id", "date_and_time", "dog_id") VALUES
  (1, 1, 2, 6, to_date('2017-12-22 16:00', 'YYYY-MM-DD HH24:MI'), 6);

INSERT INTO payment ("payment_id", "type_of_payment", "payment_system", "bank_of_card") VALUES
  (1, 'card', 'mc', 'rocket');
INSERT INTO payment ("payment_id", "type_of_payment", "payment_system", "bank_of_card") VALUES
  (2, 'cash', NULL, NULL );

INSERT INTO history ("history_id", "payment_id") VALUES (1, 1);
INSERT INTO history ("history_id", "payment_id") VALUES (2, 2);


----------------------------- CRUD ------------------------------

CREATE OR REPLACE PACKAGE temp AS
  PROCEDURE add_salons(salons_id NUMBER, s_location VARCHAR2);

  TYPE salons_rec IS RECORD (
    salon_id NUMBER,
    locations VARCHAR2(64)
  );
  TYPE salons_list IS TABLE OF salons_rec;
  FUNCTION get_salons(salon_id NUMBER, locations VARCHAR2) RETURN salons_list PIPELINED;
END temp;


CREATE OR REPLACE PACKAGE BODY temp AS
---------------------------- SALONS -------------------------

  -- CREATE --

  PROCEDURE add_salons(salons_id NUMBER, s_location VARCHAR2) AS
  BEGIN
    INSERT INTO salons("salon_id", "location") VALUES (salons_id, s_location);
  END add_salons;



  -- SELECT --

  FUNCTION get_salons(salons_id in , s_location in VARCHAR2) RETURN salons_list PIPELINED AS
    BEGIN
      FOR i IN(
      SELECT s.SALON_ID, s.LOCATIONS FROM salons s
      WHERE s.SALON_ID = salons_rec, s.LOCATIONS = salons_rec)
      LOOP PIPE ROW (i);
        END LOOP;
      RETURN;
      END get_salons;
--

END temp;

  create or replace function testFunction(pObject_type in varchar2)
          return TypeTestList pipelined as
begin
  for i in (
      select tao.OBJECT_NAME, tao.OBJECT_ID, tao.OBJECT_TYPE
        from all_objects tao
       where tao.OBJECT_TYPE=pObject_type
     )
 loop
   pipe row (TypeTestObject(i.OBJECT_NAME, i.OBJECT_ID, i.OBJECT_TYPE));
  end loop;
 return;
end;



COMMIT;


------------------- HOW TO USE ------------------

--------------- SALONS --------------

-- ADD

BEGIN
  temp.add_salons(7, 'Крестовский остров');
END;

  SELECT temp.get_salons("salon_id", "location")  FROM salons;

SELECT temp.get_salons("salon_id","location") FROM salons;