/* GROUP 2 */


CREATE DATABASE SportEventbooking;
USE SportEventbooking;

DROP SportEventbooking;


-------------------------------------------------------------------------------------------------
/* Creating customer table */
CREATE TABLE CUSTOMER (
    customer_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
	email VARCHAR(50),
	password VARCHAR(50),
	gender VARCHAR(10),
	phone INT NOT NULL,
	address VARCHAR(30),
	date_of_birth DATE
);

/* adding constraint primary key to customer table */
ALTER TABLE CUSTOMER
	ADD CONSTRAINT customer_pk primary key(customer_id);

/* adding constraint UNIQUE key to customer table */
ALTER TABLE CUSTOMER
	ADD CONSTRAINT unique_email UNIQUE (email);

/* adding another constraint UNIQUE key to customer table */
ALTER TABLE CUSTOMER
	ADD CONSTRAINT unique_password UNIQUE (password);

/* change phone datatype */
ALTER TABLE CUSTOMER
ALTER COLUMN phone VARCHAR(15);

/*add constraint to check that date of birth is less than current date*/
ALTER TABLE CUSTOMER
	ADD CONSTRAINT check_date_of_birth
	CHECK (date_of_birth < GETDATE());

/*add constraint to check the gender of Customer has to be Male or Female */
ALTER TABLE CUSTOMER
  ADD CONSTRAINT check_gender
      CHECK (gender IN ('Male', 'Female'));

/* adding a DEFAULT constraint named df_address to the address column */
ALTER TABLE CUSTOMER
	ADD CONSTRAINT df_address DEFAULT 'Toronto, Canada' FOR address;
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating TICKET table */
CREATE TABLE TICKET (
    ticket_id INT NOT NULL,
    booking_date DATE NOT NULL,
    status VARCHAR(20),
    seat_num INT NOT NULL,
    venue_id INT,
    payment_id INT,
    ticket_name VARCHAR(50),
    price INT NOT NULL,
    description VARCHAR(80)
);
/* adding constraint primary key to Ticket */
ALTER TABLE TICKET
	ADD CONSTRAINT ticket_pk primary key(ticket_id);

/* adding constraint Foreign key to Ticket table */
ALTER TABLE TICKET
	ADD CONSTRAINT venue_id_ticket_fk
	FOREIGN KEY(venue_id) REFERENCES VENUE(venue_id);

/* adding constraint Foreign key to Ticket table */
ALTER TABLE TICKET
	ADD CONSTRAINT payment_id_ticket_fk
	FOREIGN KEY(payment_id) REFERENCES PAYMENT(payment_id);

/* adding constraint UNIQUE key to ticket table */
ALTER TABLE TICKET
	ADD CONSTRAINT unique_seat_num UNIQUE (seat_num);

/* adding constraint to Check that Price should be greater than 0 */
ALTER TABLE TICKET
    ADD CONSTRAINT tickets_price
      CHECK (price>=0);

/* adding constraint to Check that booking_date must be greater than or equal to the current date */
ALTER TABLE TICKET
	ADD CONSTRAINT check_date_constraint CHECK (booking_date >= GETDATE());

-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating CUSTOMER_TICKET table */
CREATE TABLE CUSTOMER_TICKET (
    customer_id INT NOT NULL,
    ticket_id INT NOT NULL,
	status VARCHAR(30),
	quantity INT NOT NULL,
	PRIMARY KEY( customer_id, ticket_id ),
);

/* adding constraint Foreign key to CUSTOMER_TICKET table */
alter table CUSTOMER_TICKET
	add constraint customer_ticket_customer_id
	FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id);

/* adding constraint Foreign key to CUSTOMER_TICKET table */
alter table CUSTOMER_TICKET
	add constraint customer_ticket_ticket_id
	FOREIGN KEY(ticket_id) REFERENCES TICKET(ticket_id);


/* adding constraint to check the quantity should be greater than or equal to 1 */
ALTER TABLE CUSTOMER_TICKET
    ADD CONSTRAINT quantity_tickets
      CHECK (quantity>=1);

-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating FEEDBACK table */
CREATE TABLE FEEDBACK (
    feedback_id INT NOT NULL,
    rating INT,
    comments VARCHAR(50),
    customer_id INT
);
/* adding constraint primary key to FEEDBACK */
alter table FEEDBACK
	add constraint feedback_pk primary key(feedback_id);

/* adding constraint Foreign key to FEEDBACK table */
alter table FEEDBACK
	add constraint feedback_customer_id
	FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id);
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating BOOKING_REFUND table */
CREATE TABLE BOOKING_REFUND (
    refund_id INT NOT NULL,
    ticket_id INT,
    refund_status VARCHAR(20),
    refund_amount INT NOT NULL,
);
/* adding constraint primary key to BOOKING_REFUNND */
alter table BOOKING_REFUND
	add constraint refund_pk primary key(refund_id);

/* adding constraint Foreign key to BOOKING_REFUND table */
alter table BOOKING_REFUND
	add constraint booking_refund_ticket_id
	FOREIGN KEY(ticket_id) REFERENCES TICKET(ticket_id);
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating PAYMENT table */
CREATE TABLE PAYMENT (
    payment_id INT NOT NULL,
    payment_type VARCHAR(50),
    payment_date DATE,
    price INT NOT NULL
);
/* adding constraint primary key to PAYMENT */
alter table PAYMENT
	add constraint payment_pk primary key(payment_id);

/* constraint to check payment type */
ALTER TABLE PAYMENT
    ADD CONSTRAINT chk_payment_type
      CHECK (payment_type IN ('Credit Card', 'Debit Card', 'Cash', 'Online Payment'));

-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating VENUE table */
CREATE TABLE VENUE (
    venue_id INT NOT NULL,
    venue_name VARCHAR(50),
	address VARCHAR(100),
	capacity INT,
	amenities VARCHAR(20),
	open_time TIME,
    close_time TIME,
	phone_num VARCHAR(20),
    game_id INT
);
/* adding constraint primary key to VENUE */
alter table VENUE
	add constraint venue_pk primary key(venue_id);

/* adding constraint Foreign key to VENUE table */
alter table VENUE
	add constraint venue_game_id
	FOREIGN KEY(game_id) REFERENCES Game(game_id);

/* Adding a Constraint Check that the open_time is before the close_time and that it's in the future compared to the current time */
ALTER TABLE VENUE
	ADD CONSTRAINT check_time
	CHECK (open_time < close_time AND open_time > CAST(GETDATE() AS TIME));

-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating Game table */
CREATE TABLE Game (
    game_id INT NOT NULL,
    game_name VARCHAR(50),
    game_description TEXT,
    player_id INT,
    sponsor_id INT
);
/* adding constraint primary key to Game */
alter table Game
	add constraint game_pk primary key(game_id);

/* adding constraint Foreign key to Game table */
alter table Game
	add constraint game_sponsor_id
	FOREIGN KEY (sponsor_id) REFERENCES SPONSOR(sponsor_id);

/* adding constraint Foreign key to Game table */
alter table Game
	add constraint game_player_id
	FOREIGN KEY (player_id) REFERENCES PLAYER(player_id);
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating PLAYER table */
CREATE TABLE PLAYER (
    player_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    date_of_birth DATE
);
/* adding constraint primary key to PLAYER */
alter table PLAYER
	add constraint player_pk primary key(player_id);

/* Constraint which checks that the age of players falls within the range of 18 to 65 */
alter table PLAYER
	add constraint check_age 
	CHECK (age >= 18 AND age <= 65);
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
/* Creating SPONSOR table */
CREATE TABLE SPONSOR (
    sponsor_id INT NOT NULL,
    sponsor_name VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    phone_number VARCHAR(20)
);
/* adding constraint primary key to SPONSOR */
alter table SPONSOR
	add constraint sponsor_pk primary key(sponsor_id);

/* adding constraint UNIQUE key to SPONSOR table */
ALTER TABLE SPONSOR
	ADD CONSTRAINT unique_sponsor_email UNIQUE (email);

-------------------------------------------------------------------------------------------------

/* Creating MANAGER table */
CREATE TABLE MANAGER (
    manager_id INT IDENTITY(1,1) NOT NULL, /* manager_id will be automatically generated by the system starting from 1, with an increment of 1 for each new row */
    first_name VARCHAR(50),
    last_name VARCHAR(50),
	email VARCHAR(50),
	phone VARCHAR(20),
	date_of_birth DATE,
	venue_id INT NOT NULL
);
/* adding constraint primary key to MANAGER */
alter table MANAGER
	add constraint manager_pk primary key(manager_id);

/*add constraint to check that date of birth is less than current date*/
ALTER TABLE MANAGER
	ADD CONSTRAINT check_dateofbirth
	CHECK (date_of_birth < GETDATE());

/* adding constraint Foreign key to Manager table */
ALTER TABLE MANAGER
	ADD CONSTRAINT manager_id_venue_fk
	FOREIGN KEY(venue_id) REFERENCES VENUE(venue_id);

/* adding constraint UNIQUE key to ticket table */
ALTER TABLE MANAGER
	ADD CONSTRAINT unique_manager_email UNIQUE (email);

/* adding constraint UNIQUE key to ticket table */
ALTER TABLE MANAGER
	ADD CONSTRAINT unique_manager_phone UNIQUE (phone);


/************************ Inserting values into CUSTOMER table *********************/
INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (1, 'Rushi', 'Suthar', 'abc@xyz.com', '123456789', 
'MALE', '4168906307', 'Gujarat, India','2002/06/21')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (2, 'Ajaysinh', 'Zala', 'def@xyz.com', '987654321', 
'MALE', '9898825152', 'Gujarat, India','1999/04/16')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (3, 'Ruchit', 'Chudasama', 'ghi@xyz.com', '876543210', 
'MALE', '2726158936', 'Gujarat, India','2001/01/01')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (4, 'Aman', 'Patel', 'jkl@xyz.com', '0143356723', 
'MALE', '7391752519', 'Toronto, Canada','2000/01/20')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (5, 'Jessica', 'Jones', 'lmn@xyz.com', 'jonesjessica123989', 
'FEMALE', '7527391519', 'Toronto, Canada','2001/02/19')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (6, 'Jennifer', 'Windget', 'opqa@xyz.com', 'jennwin0709', 
'FEMALE', '5197391752', 'Brampton, Canada','1999/11/28')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (7, 'Matt', 'Murdock', 'mattmurdock@xyz.com', 'matt17murdock', 
'MALE', '1391752519', 'Vaughan, Canada','2003/03/11')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (8, 'Cherrie', 'Jones', 'cherriejones@xyz.com', 'Cherrie0987Jones', 
'FEMALE', '1973917525', 'North York, Canada','2001/05/04')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (9, 'Peter', 'Pan', 'peter@xyz.com', 'PetePan1234', 
'MALE', '1973434525', 'Guelph, Canada','2004/01/20')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (10, 'Roma', 'Shah', 'roma92@xyz.com', 'Roma2233shah', 
'FEMALE', '1256917525', 'Scarborough, Canada','2001/09/18')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (11, 'Tom', 'Holland', 'tomholland@gmail.com', 'Tom111holland', 
'MALE', '1433913225', 'Ottawa, Canada','2001/12/21')

INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (12, 'Snoop', 'Dog', 'snoopp1@xyz.com', 'snoop123dogg', 
'MALE', '1256542576', 'Pickering, Canada','2002/07/12')

select * from CUSTOMER;

/*********************** Inserting data into the FEEDBACK table ***********************/
INSERT INTO FEEDBACK (feedback_id, rating, comments, customer_id)
VALUES 
    (1, 5, 'Excellent service!', 1),
    (2, 4, 'Good experience overall.', 2),
    (3, 3, 'Could be improved.', 3),
    (4, 5, 'Very satisfied with the product.', 4),
    (5, 3, 'Average experience.', 5),
    (6, 2, 'Disappointed with the service.', 6),
    (7, 4, 'Satisfied with the support.', 7),
    (8, 3, 'Fairly good, but room for improvement.', 8),
    (9, 5, 'Exceptional quality!', 9);

select * from FEEDBACK;

/************************ Inserting values into PAYMENT table *********************/
INSERT INTO PAYMENT (payment_id, payment_type, payment_date, price)
VALUES (1, 'Credit Card', '2024-04-15', 100);

INSERT INTO PAYMENT (payment_id, payment_type, payment_date, price)
VALUES 
    (2, 'Debit Card', '2024-04-02', 1500),
    (3, 'Credit Card', '2024-04-03', 1750),
    (4, 'Cash', '2024-04-04', 1200),
    (5, 'Credit Card', '2024-04-05', 1090),
    (6, 'Online Payment', '2024-04-06', 1101),
    (7, 'Credit Card', '2024-04-07', 1080),
    (8, 'Debit Card', '2024-04-08', 1301),
    (9, 'Cash', '2024-04-09', 700),
    (10, 'Debit Card', '2024-04-10', 1050),
    (11, 'Online Payment', '2024-04-11', 9500),
    (12, 'Debit Card', '2024-04-12', 1150);

select * from PAYMENT;

/************************ Inserting values into SPONSOR table *********************/
INSERT INTO SPONSOR (sponsor_id, sponsor_name, email, phone_number)
VALUES (1, 'Sponsor A', 'sponsor_a@example.com', '123-456-7890');

INSERT INTO SPONSOR (sponsor_id, sponsor_name, email, phone_number)
VALUES 
    (2, 'Sponsor B', 'sponsor_b@example.com', '987-654-3210'),
    (3, 'Sponsor C', 'sponsor_c@example.com', '555-555-5555'),
    (4, 'Sponsor D', 'sponsor_d@example.com', '111-222-3333'),
    (5, 'Sponsor E', 'sponsor_e@example.com', '444-555-6666'),
    (6, 'Sponsor F', 'sponsor_f@example.com', '777-888-9999'),
    (7, 'Sponsor G', 'sponsor_g@example.com', '000-111-2222'),
    (8, 'Sponsor H', 'sponsor_h@example.com', '333-444-5555'),
    (9, 'Sponsor I', 'sponsor_i@example.com', '666-777-8888'),
    (10, 'Sponsor J', 'sponsor_j@example.com', '999-000-1111'),
    (11, 'Sponsor K', 'sponsor_k@example.com', '222-333-4444'),
	(12, 'Sponsor L', 'sponsor_l@example.com', '122-323-3432');

select * from SPONSOR;

/************************ Inserting values into PLAYER table *********************/
INSERT INTO PLAYER (player_id, first_name, last_name, age, gender, date_of_birth)
VALUES (1, 'John', 'Doe', 25, 'Male', '1999-05-15');

INSERT INTO PLAYER (player_id, first_name, last_name, age, gender, date_of_birth)
VALUES 
	(2, 'Jane', 'Smith', 28, 'Female', '1996-09-20'),
    (3, 'Alice', 'Johnson', 30, 'Female', '1992-11-10'),
    (4, 'Bob', 'Brown', 27, 'Male', '1995-07-25'),
    (5, 'Emily', 'Davis', 29, 'Female', '1993-03-30'),
    (6, 'Michael', 'Wilson', 24, 'Male', '2000-01-05'),
    (7, 'Sarah', 'Martinez', 26, 'Female', '1998-08-12'),
    (8, 'David', 'Garcia', 31, 'Male', '1991-12-20'),
    (9, 'Jessica', 'Lopez', 23, 'Female', '2001-04-18'),
    (10, 'Daniel', 'Miller', 32, 'Male', '1990-10-15'),
    (11, 'Amanda', 'Taylor', 33, 'Female', '1989-06-08'),
	(12, 'Roman', 'Reyns', 22, 'Male', '1989-01-19');

select * from PLAYER;

/************************ Inserting values into Game table *********************/
INSERT INTO Game (game_id, game_name, game_description, player_id, sponsor_id)
VALUES (1, 'Cricket', 'Cricket is a bat-and-ball game that is played between two teams of eleven players on a field', 1, 1);

INSERT INTO Game (game_id, game_name, game_description, player_id, sponsor_id)
VALUES 
    (2, 'Football', 'A team sport that involves kicking a ball to score a goal. The objective is to score goals by getting the ball into the opposing team''s goal.', 2, 2),
    (3, 'Tennis', 'A racket sport that can be played individually against a single opponent (singles) or between two teams of two players each (doubles).', 3, 3),
    (4, 'Cricket', 'A bat-and-ball game played between two teams of eleven players on a field at the center of which is a 22-yard pitch with a wicket at each end.', 4, 4),
    (5, 'Golf', 'A club-and-ball sport in which players use various clubs to hit balls into a series of holes on a course in as few strokes as possible.', 5, 5),
    (6, 'Baseball', 'A bat-and-ball game played between two opposing teams who take turns batting and fielding.', 6, 6),
    (7, 'Soccer', 'A team sport played with a spherical ball between two teams of 11 players. It is played by approximately 250 million players in over 200 countries and dependencies, making it the world''s most popular sport.', 7, 7),
    (8, 'Hockey', 'A sport in which two teams play against each other by trying to maneuver a ball or a puck into the opponent''s goal using a hockey stick.', 8, 8),
    (9, 'Rugby', 'A team sport that originated in England in the first half of the 19th century. It is played by two teams with an oval ball that may be kicked, carried, or passed from hand to hand.', 9, 9),
    (10, 'Volleyball', 'A team sport in which two teams of six players are separated by a net. Each team tries to score points by grounding a ball on the other team''s court under organized rules.', 10, 10),
    (11, 'Badminton', 'A racquet sport played using racquets to hit a shuttlecock across a net. Although it may be played with larger teams, the most common forms of the game are "singles" and "doubles."', 11, 11),
	(12, 'Cricket', 'A bat-and-ball game played between two teams of eleven players on a field at the center of which is a 22-yard pitch with a wicket at each end.', 12, 12);

select * from Game;

/************************ Inserting values into Venue table *********************/
INSERT INTO VENUE (venue_id, venue_name, address, capacity, amenities, open_time, close_time, phone_num, game_id)
VALUES (1, 'Toronto Sports Ground', '10 Weston St', 1000, 'Wi-Fi', '08:00:00', '20:00:00', '123-456-7890', 1);

INSERT INTO VENUE (venue_id, venue_name, address, capacity, amenities, open_time, close_time, phone_num, game_id)
VALUES 
    (2, 'Stadium A', '456 Park Avenue', 800, 'Restrooms', '10:00:00', '18:00:00', '987-654-3210', 2),
    (3, 'Arena B', '789 Elm Street', 500, 'Concession Stand', '08:00:00', '20:00:00', '555-555-5555', 3),
    (4, 'Gymnasium D', '101 Oak Lane', 300, 'Bleachers', '12:00:00', '20:00:00', '111-222-3333', 4),
    (5, 'Pavilion E', '222 Pine Road', 200, 'Scoreboard', '08:00:00', '20:00:00', '444-555-6666', 5),
    (6, 'Venue F', '333 Cedar Boulevard', 150, 'Shaded Seating', '08:00:00', '20:00:00', '777-888-9999', 6),
    (7, 'Venue G', '444 Willow Avenue', 100, 'Stage', '08:00:00', '20:00:00', '000-111-2222', 7),
    (8, 'Venue H', '555 Maple Street', 80, 'Landscaping', '08:00:00', '20:00:00', '333-444-5555', 8),
    (9, 'Venue I', '666 Birch Drive', 60, 'Tables, Chairs', '08:00:00', '20:00:00', '666-777-8888', 9),
    (10, 'Venue J', '777 Oak Street', 40, 'Lines', '08:00:00', '20:00:00', '999-000-1111', 10),
    (11, 'Venue K', '888 Pine Lane', 20, 'Lanes', '08:00:00', '20:00:00', '222-333-4444', 11);

INSERT INTO VENUE (venue_id, venue_name, address, capacity, amenities, open_time, close_time, phone_num, game_id)
VALUES (12, 'Graham G', '120 Bathurst St, Toronto', 3500, 'Air Conditioners', '09:00:00', '12:00:00', '268-233-4214', 12);
	
select * from VENUE;

/************************ Inserting values into MANAGER table *********************/

INSERT INTO MANAGER (first_name, last_name, email, phone, date_of_birth, venue_id)
VALUES ('Robert', 'James', 'robert.james@example.com', '244-323-4332', '1980-05-15', 1);

INSERT INTO MANAGER (first_name, last_name, email, phone, date_of_birth, venue_id)
VALUES ('Nick', 'White', 'nick.white@example.com', '987-654-3210', '1976-01-01', 2),
    ('Emilia', 'Clent', 'emilia.clent@example.com', '555-555-5555', '1977-02-02', 3),
    ('Davis', 'Andrew', 'david.anderew@example.com', '111-222-3333', '1978-03-03', 4),
    ('Jeff', 'Bezors', 'jeff.bezors@example.com', '444-555-6666', '1979-04-04', 5),
    ('Michelle', 'Lenin', 'michelle.lenin@example.com', '777-888-9999', '1981-05-05', 6),
    ('Jenny', 'Hearyt', 'jennifer.hearyt@example.com', '000-111-2222', '1982-06-06', 7),
    ('Andrew', 'Tate', 'andrew.tate@example.com', '333-444-5555', '1983-07-07', 8),
    ('Stephanie', 'Harris', 'stephanie.harris@example.com', '666-777-8888', '1984-08-08', 9),
	('Jerry', 'Chris', 'jerry.c@example.com', '043-123-2542', '1981-12-12', 10),
    ('Omar', 'Siran', 'omar.siran@example.com', '833-294-9355', '1997-11-09', 11),
    ('CLay', 'Jenson', 'clay.jen@example.com', '916-707-8298', '1981-09-21',12);

select * from MANAGER;

/************************ Inserting values into TICKET table *********************/
INSERT INTO TICKET (ticket_id, booking_date, status, seat_num, venue_id, payment_id, ticket_name, price, description)
VALUES (1, '2024-04-15', 'booked', 11, 1, 1, 'Standard Ticket', 15000, 'General admission ticket for the event');

INSERT INTO TICKET (ticket_id, booking_date, status, seat_num, venue_id, payment_id, ticket_name, price, description)
VALUES 
    (2, '2024-04-15', 'pending', 982, 2, 2, 'VIP Ticket', 2000, 'Includes access to VIP lounge and front row seating'),
    (3, '2024-04-17', 'booked', 213, 3, 3, 'Student Ticket', 1000, 'Discounted ticket for students with valid ID'),
    (4, '2024-04-21', 'booked', 134, 4, 4, 'Premium Ticket', 2500, 'Includes premium seating and complimentary drinks'),
    (5, '2024-04-18', 'pending', 115, 5, 5, 'Group Ticket', 5000, 'Special discount for group bookings'),
    (6, '2024-04-20', 'booked', 126, 6, 6, 'Child Ticket', 1750, 'Ticket for children under 12 years old'),
    (7, '2024-04-19', 'booked', 147, 7, 7, 'Senior Ticket', 1200, 'Discounted ticket for seniors aged 65 and above'),
    (8, '2024-04-15', 'pending', 199, 8, 8, 'Family Ticket', 3000, 'Admission for a family of four'),
    (9, '2024-04-22', 'booked', 239, 9, 9, 'Early Bird Ticket', 1800, 'Special discount for early bird bookings'),
    (10, '2024-04-26', 'booked', 450, 10, 10, 'Weekend Pass', 3500, 'Access to all events over the weekend'),
    (11, '2024-04-27', 'pending', 231, 11, 11, 'Corporate Ticket', 5000, 'Exclusive benefits for corporate bookings');

/* Inserting Value Using Sequence */
INSERT INTO TICKET (ticket_id, booking_date, status, seat_num, venue_id, payment_id, ticket_name, price, description)
	VALUES (12, '2024-04-20', 'booked', NEXT VALUE FOR Seat_Num_Sequence, 12, 11, 'VIP Ticket', 15000, 'VIP ticket for the event');

select * from TICKET;

/************************ Inserting values into CUSTOMER_TICKET table *********************/
INSERT INTO CUSTOMER_TICKET (customer_id, ticket_id, status, quantity)
VALUES (1, 1, 'confirmed', 1);

INSERT INTO CUSTOMER_TICKET (customer_id, ticket_id, status, quantity)
VALUES 
    (2, 2, 'pending', 2),
    (3, 3, 'confirmed', 5),
    (4, 4, 'confirmed', 10),
    (5, 5, 'pending', 3),
    (6, 6, 'confirmed', 11),
    (7, 7, 'confirmed', 2),
    (8, 8, 'pending', 2),
    (9, 9, 'confirmed', 4),
    (10, 10, 'confirmed', 2),
    (11, 11, 'pending', 3);

select * from CUSTOMER_TICKET;

/************************ Displaying All Tables *********************/
select * from CUSTOMER;
select * from CUSTOMER_TICKET;
select * from TICKET;
select * from VENUE;
select * from FEEDBACK;
select * from Game;
select * from PLAYER;
select * from MANAGER;
select * from SPONSOR;
select * from PAYMENT;


/* Created Sequence which will generate numeric values starting from 101, incrementing by 1, 
and cycling back to 101 after reaching 1001 */
CREATE SEQUENCE Seat_Num_Sequence
    START WITH 101
    INCREMENT BY 1
    MAXVALUE 1001
    CYCLE;


/*********************************************************************************************************/
/****************************************** Constraint Testing*************************************************/




INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (13, 'Ram', 'patel', 'aasc@xyz.com', '123423789', 
'MALE', '4168902343', 'Toronto, CA','2024/06/01')
/*In the above query getting error as i am entering future date as date of birth */




INSERT INTO MANAGER (first_name, last_name, email, phone, date_of_birth, venue_id)
VALUES ('Rakes', 'Ramana', 'nick.white@example.com', '987-654-3210', '1923-03-11', 13);
/*In the above insert query getting duplicate key error as we are entering same email and phone number 
which is already in the database */





INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, address, date_of_birth ) values (NULL, 'Ram', 'patel', 'aasc@xyz.com', '123423789', 
'MALE', NULL, 'Toronto, CA','2002/06/01')
/* Cannot insert the value NULL into column 'customer_id' because
we are entering NULL in id and phone number column*/




INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, date_of_birth ) values (14, 'Rick', 'jonathan', 'was@xyz.com', '239239841', 
'MALE', '1249387615','2002/08/24')
/*Not entering Address in the Customer and we set default value as Toronto,Canada so it is
taking Toronto,Canada default value as a address*/




INSERT INTO TICKET (ticket_id, booking_date, status, seat_num, venue_id, payment_id, ticket_name, price, description)
	VALUES (14, '2024-04-24', 'booked', NEXT VALUE FOR Seat_Num_Sequence, 12, 11, 'Child Ticket', -100, 
	'Child ticket for the event');
/*Error thrown as entering negative value in the price column*/




INSERT INTO CUSTOMER_TICKET(customer_id, ticket_id) VALUES (2,2);
/*Throwing error Cannot insert duplicate key for primary key constraint as it is combined primary key and this 
combination is already exist in the database*/




INSERT INTO FEEDBACK (feedback_id, rating, comments, customer_id)
VALUES (1, 5, 'Excellent service!', 1);
/*Throwing error Cannot insert duplicate key for primary key constraint as it is combined primary key and this 
combination is already exist in the database*/




INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, date_of_birth ) values (15, 'Amran', 'khan', 'was@xyz.com', '232359841', 
'MALE', '1249323715','2002/08/28');
/*Throwing error for Unique Key constarint as we added same email as it ia already in database */



INSERT INTO CUSTOMER_TICKET(customer_id, ticket_id) VALUES (15,18);
/*Throwing FOREIGN KEY constraint error as customer_id and ticket_id with id 15 and 18 doesn't exist in table */


INSERT INTO MANAGER (first_name, last_name, email, phone, date_of_birth, venue_id)
VALUES ('Amrita', 'Shah', 'wesddec@example.com', '987-234-3230', '1999-01-01', 16);
/*Throwing error for foreign key constarint as inserting a row into the MANAGER table 
with a venue_id that does not exist in the VENUE table.*/


INSERT INTO Game (game_id, game_name, game_description, player_id, sponsor_id)
VALUES (14, 'Cricket', 'Cricket is a bat-and-ball game that is played between two teams of eleven players on a field', 18, 16);
/*Throwing error for foreign key constarint as inserting a row into the Game 
table with a sponsor_id that does not exist in the SPONSOR table */


INSERT INTO VENUE (venue_id, venue_name, address, capacity, amenities, open_time, close_time, phone_num, game_id)
VALUES (14, 'Eaton Sports Ground', '101 Downtown St', 1100, 'Wi-Fi', '13:00:00', '20:00:00', '123-026-7230', 16);
/*Throwing error for foreign key constarint as inserting a row into the Venue 
table with a game_id that does not exist in the game table */




INSERT INTO CUSTOMER(customer_id, first_name, last_name, email, password,
gender, phone, date_of_birth ) values (15, 'Rahul', 'shah', 'sdfes@xyz.com', '334239841', 
'BiSexual', '1223687615','2001/03/21')
/* CHECK constraint "check_gender" gender of Customer has to be Male or Female*/




INSERT INTO MANAGER (first_name, last_name, email, phone, date_of_birth, venue_id)
VALUES ('Manpreet', 'Brar', 'man.brar@example.com', '927-234-3210', '2024-05-11', 13);
/* We added wrong birth date as the constraint checks if the birthd date has to be less than current year
CHECK constraint "check_dateofbirth" */



INSERT INTO VENUE (venue_id, venue_name, address, capacity, amenities, open_time, close_time, phone_num, game_id)
VALUES (13, 'Stadium ALpha', '120 ELmhurst Dr', 1200, 'Restrooms', '21:00:00', '12:00:00', '127-334-5610', 2);
/* Error Occurs because the open_time is after the close_time */




INSERT INTO PLAYER (player_id, first_name, last_name, age, gender, date_of_birth)
VALUES (14, 'Usain', 'Bolt', 70, 'Male', '1920-05-15');
/* Error Occurs because the age should be between 18 to 65 */


----------------------------------------------------------------------------------



/*1. Write a query that display ticket id, customer first name, last name , and customer address */
SELECT t.ticket_id, c.first_name,c.last_name, c.address
FROM TICKET t
	JOIN Customer c ON t.ticket_id = c.customer_id;
	


/*2. Write a query that display the ticket name, status and customer id that 
have been pending payment by any customer. */
SELECT DISTINCT t.ticket_name, c.status, c.customer_id
FROM TICKET t
JOIN CUSTOMER_TICKET c ON t.payment_id = c.customer_id
WHERE c.status = 'Pending';


/*3. Write a Query to retrieve data from the VENUE table, selecting columns venue_name, address, 
capacity, amenities, phone_num, and game_id. It then orders the results based 
on the game_id column in ascending order */
SELECT venue_name, address, capacity, amenities, phone_num, game_id FROM VENUE ORDER BY game_id; 



/*4. Write a query which concatinate customer id as customer_no, first name and last name 
as customer name from customer table */
SELECT 'CUSTOMER ' + CAST(customer_id AS VARCHAR) AS customer_no,
       CONCAT(first_name, ' ', last_name) AS customer_name 
FROM CUSTOMER;


/*5. Write a query to get lowest price from the payment table using MIN */
SELECT MIN(price) AS "Lowest Price" FROM PAYMENT;


/*5. Write a query to get highest price from the payment table using MAX */
SELECT MAX(price) AS "Highest Price" FROM PAYMENT;


/*6. Write a Query to retrieve data from the TICKET table, selecting columns ticket_id, booking_date, 
status, seat_num, ticket_name. It then orders the results based 
on the venue_id column in ascending order */
SELECT ticket_id, booking_date, status, seat_num, ticket_name FROM TICKET ORDER BY venue_id;



/*7. Write a query that retrieves the maximum price for each ticket from the TICKET table */
SELECT ticket_id, MAX(price) AS max_price
	FROM TICKET
	GROUP BY ticket_id
	ORDER BY ticket_id;


/*8. Write a query that display the top high ticket purchase in total*/
SELECT p.payment_id, p.payment_type, p.payment_date, SUM(et.price) AS total_purchase
FROM PAYMENT p
	JOIN TICKET et ON p.payment_id = et.ticket_id
	GROUP BY p.payment_id, p.payment_type, p.payment_date
	ORDER BY total_purchase DESC;


/*9. Write a query that display the top lowest ticket purchase in total*/
SELECT p.payment_id, p.payment_type, p.payment_date, SUM(et.price) AS total_purchase
FROM PAYMENT p
	JOIN TICKET et ON p.payment_id = et.ticket_id
	GROUP BY p.payment_id, p.payment_type, p.payment_date
	ORDER BY total_purchase;