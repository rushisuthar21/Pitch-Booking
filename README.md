# Pitch Booking – Database Design & SQL Project

## 📌 Course Information
- **Course:** CSD 2206 – Database Design and SQL  
- **Term:** Winter 2024  
- **Instructor:** Mehrnoush Ashrafi  


## 🏢 Project Overview
**Pitch Booking** is an online sports event ticket booking platform designed to manage:
- Customers and ticket bookings  
- Sports games and venues  
- Payments and refunds  
- Players, sponsors, and managers  
- Customer feedback  

This project focuses on **database design, normalization, relationships, constraints, and SQL implementation**.

---

## 🎟️ Product
**Cricket Match Ticket**

**Attributes**
- Ticket ID  
- Customer Name  
- Event Description  
- Seat Number  
- Ticket Type  
- Price  
- Booking Status  

---

## 🔗 Entity Relationship Rules
- A **Customer** can book multiple tickets  
- A **Ticket** belongs to one venue and one game  
- Each **Payment** is associated with one ticket  
- A **Refund** may exist for a ticket  
- A **Venue** is managed by one manager  
- A **Game** includes players and sponsors  

---

## 🧱 Relational Schema
CUSTOMER(customer_id, first_name, last_name, email, password, gender, phone, address, date_of_birth)

TICKET(ticket_id, booking_date, status, seat_num, venue_id, payment_id, ticket_name, price, description)

CUSTOMER_TICKET(customer_id, ticket_id, status, quantity)

PAYMENT(payment_id, payment_type, payment_date, price)

BOOKING_REFUND(refund_id, ticket_id, refund_status, refund_amount)

FEEDBACK(feedback_id, rating, comments, customer_id)

VENUE(venue_id, venue_name, address, capacity, amenities, open_time, close_time, phone_num, game_id)

GAME(game_id, game_name, game_description, player_id, sponsor_id)

PLAYER(player_id, first_name, last_name, age, gender, date_of_birth)

SPONSOR(sponsor_id, sponsor_name, email, phone_number)

MANAGER(manager_id, first_name, last_name, email, phone, date_of_birth, venue_id)


---

## ⚙️ Database Creation
```sql
CREATE DATABASE SportEventbooking;
USE SportEventbooking;
🏗️ Table Creation (DDL)
CREATE TABLE CUSTOMER (
    customer_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    password VARCHAR(50),
    gender VARCHAR(10),
    phone VARCHAR(15),
    address VARCHAR(30),
    date_of_birth DATE
);

CREATE TABLE PAYMENT (
    payment_id INT NOT NULL,
    payment_type VARCHAR(50),
    payment_date DATE,
    price DECIMAL(5,2)
);

CREATE TABLE SPONSOR (
    sponsor_id INT NOT NULL,
    sponsor_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20)
);

CREATE TABLE PLAYER (
    player_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    date_of_birth DATE
);

CREATE TABLE GAME (
    game_id INT NOT NULL,
    game_name VARCHAR(50),
    game_description TEXT,
    player_id INT,
    sponsor_id INT
);

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

CREATE TABLE MANAGER (
    manager_id INT IDENTITY(1,1) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(20),
    date_of_birth DATE,
    venue_id INT
);

CREATE TABLE TICKET (
    ticket_id INT NOT NULL,
    booking_date DATE,
    status VARCHAR(20),
    seat_num INT,
    venue_id INT,
    payment_id INT,
    ticket_name VARCHAR(50),
    price DECIMAL(5,2),
    description VARCHAR(80)
);

CREATE TABLE CUSTOMER_TICKET (
    customer_id INT NOT NULL,
    ticket_id INT NOT NULL,
    status VARCHAR(30),
    quantity INT,
    PRIMARY KEY (customer_id, ticket_id)
);

CREATE TABLE FEEDBACK (
    feedback_id INT NOT NULL,
    rating INT,
    comments VARCHAR(50),
    customer_id INT
);

CREATE TABLE BOOKING_REFUND (
    refund_id INT NOT NULL,
    ticket_id INT,
    refund_status VARCHAR(20),
    refund_amount DECIMAL(5,2)
);
🔐 Constraints
ALTER TABLE CUSTOMER ADD CONSTRAINT customer_pk PRIMARY KEY(customer_id);
ALTER TABLE CUSTOMER ADD CONSTRAINT unique_email UNIQUE(email);
ALTER TABLE CUSTOMER ADD CONSTRAINT check_gender CHECK (gender IN ('Male','Female'));
ALTER TABLE CUSTOMER ADD CONSTRAINT check_dob CHECK (date_of_birth < GETDATE());

ALTER TABLE PAYMENT ADD CONSTRAINT payment_pk PRIMARY KEY(payment_id);
ALTER TABLE PAYMENT ADD CONSTRAINT chk_payment_type 
CHECK (payment_type IN ('Credit Card','Debit Card','Cash','Online Payment'));

ALTER TABLE PLAYER ADD CONSTRAINT player_pk PRIMARY KEY(player_id);
ALTER TABLE PLAYER ADD CONSTRAINT chk_age CHECK (age BETWEEN 18 AND 65);

ALTER TABLE SPONSOR ADD CONSTRAINT sponsor_pk PRIMARY KEY(sponsor_id);
ALTER TABLE SPONSOR ADD CONSTRAINT unique_sponsor_email UNIQUE(email);

ALTER TABLE GAME ADD CONSTRAINT game_pk PRIMARY KEY(game_id);
ALTER TABLE GAME ADD FOREIGN KEY (player_id) REFERENCES PLAYER(player_id);
ALTER TABLE GAME ADD FOREIGN KEY (sponsor_id) REFERENCES SPONSOR(sponsor_id);

ALTER TABLE VENUE ADD CONSTRAINT venue_pk PRIMARY KEY(venue_id);
ALTER TABLE VENUE ADD FOREIGN KEY (game_id) REFERENCES GAME(game_id);

ALTER TABLE MANAGER ADD CONSTRAINT manager_pk PRIMARY KEY(manager_id);
ALTER TABLE MANAGER ADD FOREIGN KEY (venue_id) REFERENCES VENUE(venue_id);

ALTER TABLE TICKET ADD CONSTRAINT ticket_pk PRIMARY KEY(ticket_id);
ALTER TABLE TICKET ADD FOREIGN KEY (venue_id) REFERENCES VENUE(venue_id);
ALTER TABLE TICKET ADD FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id);
ALTER TABLE TICKET ADD CONSTRAINT chk_price CHECK (price > 0);

ALTER TABLE CUSTOMER_TICKET ADD FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id);
ALTER TABLE CUSTOMER_TICKET ADD FOREIGN KEY (ticket_id) REFERENCES TICKET(ticket_id);
🔢 Sequence
CREATE SEQUENCE Seat_Num_Sequence
START WITH 101
INCREMENT BY 1
MAXVALUE 1001
CYCLE;
📥 Sample Insert Queries
INSERT INTO CUSTOMER VALUES
(1,'Rushi','Suthar','abc@xyz.com','123456','Male','4168906307','Toronto','2002-06-21');

INSERT INTO PAYMENT VALUES
(1,'Credit Card','2024-04-15',1500);

INSERT INTO SPONSOR VALUES
(1,'Sponsor A','sponsor_a@example.com','1234567890');

INSERT INTO PLAYER VALUES
(1,'John','Doe',25,'Male','1999-05-15');

INSERT INTO GAME VALUES
(1,'Cricket','Cricket match',1,1);

INSERT INTO VENUE VALUES
(1,'Toronto Sports Ground','10 Weston St',1000,'WiFi','08:00','20:00','1234567890',1);

INSERT INTO TICKET VALUES
(1,'2024-04-20','Booked',NEXT VALUE FOR Seat_Num_Sequence,1,1,'VIP Ticket',1500,'Premium seating');

INSERT INTO CUSTOMER_TICKET VALUES
(1,1,'Confirmed',2);
📊 Sample Queries (Joins, Aggregates, Subqueries)
-- Customers with booked tickets
SELECT c.first_name, t.ticket_name
FROM CUSTOMER c
JOIN CUSTOMER_TICKET ct ON c.customer_id = ct.customer_id
JOIN TICKET t ON ct.ticket_id = t.ticket_id;

-- Total revenue
SELECT SUM(price) AS Total_Revenue FROM PAYMENT;

-- Tickets per venue
SELECT venue_id, COUNT(ticket_id) AS Total_Tickets
FROM TICKET
GROUP BY venue_id
HAVING COUNT(ticket_id) > 1;

-- Customers who gave feedback
SELECT DISTINCT c.first_name
FROM CUSTOMER c
WHERE c.customer_id IN (SELECT customer_id FROM FEEDBACK);

✅ Conclusion
This project demonstrates:

Complete database lifecycle

Strong normalization

Real-world business rules

Advanced SQL usage with constraints, joins, and aggregates
