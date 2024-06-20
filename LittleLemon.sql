use littlelemondb;

INSERT INTO menuitems (MenuItemsID, CourseName, StarterName, DessertName)
VALUES
(1, 'Kabasa', 'Flatbread', 'Ice cream'),
(2, 'Greek salad', 'Olives', 'Greek yoghurt'),
(3, 'Pizza', 'Minestrone', 'Cheesecake');

INSERT INTO menus (MenuID, MenuItemsID, MenuName, Cuisine)
VALUES
(1, 1, 'Manti', 'Turkish'),
(2, 2, 'Moussaka', 'Greek'),
(3, 3, 'Aperitivo', 'Italian');

INSERT INTO staff (StaffID, Role, Salary)
VALUES
(1, 'Manager', 70000),
(2, 'Chef', 50000),
(3, 'Waiter', 40000);

INSERT INTO customers (CustomerID, FullName, ContactNumber, Email)
VALUES
(1, 'Vanessa McCarthy', 351258074, 'Vanessa.M@gmail.com'),
(2, 'Marcos Romero', 351474048, 'Marcos.R@gmail.com'),
(3, 'Anna Iversen', 351970582, 'Anna.I@gmail.com');

INSERT INTO delivery (DeliveryID, DeliveryDate, Status)
VALUES
(1, '2022-10-10', "Delivered"),
(2, '2022-11-12', "Delivered"),
(3, '2022-10-11', "Delivered"),
(4, '2022-10-13', "Not Delivered");

INSERT INTO orders (OrderID, MenuID, CustomerID, Quantity, Cost, DeliveryID)
VALUES
(1, 1, 1, 5, 250, 1),
(2, 2, 2, 3, 200, 2),
(3, 3, 3, 2, 100, 3),
(4, 3, 3, 1, 40, 4);

#######################################################################################
# Module 2 Exercise 1
#######################################################################################

# Task 1: Create a virtual table for orders

CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, Cost
FROM orders;

SELECT * FROM OrdersView;

# Task 2: Extract information on all customers with orders that cost more than $150

CREATE VIEW customers_150 AS
SELECT a.CustomerID, a.FullName, b.OrderID, b.Cost, c.MenuName, d.CourseName
FROM customers as a
INNER JOIN orders as b
ON a.CustomerID=b.CustomerID AND b.COST>150
INNER JOIN menus as c
on b.MenuID=c.MenuID
INNER JOIN menuitems as d
on c.MenuItemsID=d.MenuItemsID;

SELECT * FROM customers_150;

# Task 3: Find all menu items for which more than 2 orders have been placed

CREATE VIEW menuitems_2 AS
SELECT MenuName
FROM menus
WHERE MenuID = ANY (SELECT MenuID FROM orders WHERE Quantity>2);

SELECT * FROM menuitems_2;

#######################################################################################
# Module 2 Exercise 2
#######################################################################################

# Task 1: Create a procedure that displays the maximum ordered quantity in the orders table

CREATE PROCEDURE GetMaxQuantity()
SELECT MAX(Quantity)
FROM orders;

CALL GetMaxQuantity();

# Task 2: Create a prepared statement which returns OrderID, quantity, and cost from the orders table

PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, Cost FROM orders WHERE OrderID=?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

# Task 3: Create a procedure to delete an order record based on the user input of the order id

DELIMITER //
CREATE PROCEDURE CancelOrder(id INT)
BEGIN
DELETE FROM orders WHERE OrderID=id;
SELECT CONCAT('Order ', id, ' is cancelled') as Confirmation;
END //
DELIMITER ;

CALL CancelOrder(5);

#######################################################################################
# Module 2 Exercise 3
#######################################################################################

# Task 1: Populate the Bookings table

INSERT INTO bookings (BookingID, BookingDate, TableNumber, CustomerID, StaffID)
VALUES
(1, '2022-10-10', 5, 1, 1),
(2, '2022-11-12', 3, 3, 1),
(3, '2022-10-11', 2, 2, 2),
(4, '2022-10-13', 2, 1, 3);

SELECT * FROM bookings;

# Task 2: Create a procedure to check whether a table in the restaurant is already booked

DELIMITER //
CREATE PROCEDURE CheckBooking(checkdate DATE, checktable INT)
BEGIN
DROP TABLE IF EXISTS BookingStatus;
CREATE TABLE BookingStatus AS
SELECT CONCAT('Table ', checktable, ' is already booked') as BookingStatus,
COUNT(*) AS booking FROM bookings WHERE BookingDate=checkdate and TableNumber=checktable;
UPDATE BookingStatus
SET BookingStatus=CONCAT('Table ', checktable, ' is not booked')
WHERE booking=0;
SELECT BookingStatus FROM BookingStatus;
END //
DELIMITER ;

CALL CheckBooking('2022-11-12', 3);

#######################################################################################
# Module 2 Exercise 4
#######################################################################################

# Task 1: Create a procedure to add a new booking record

DELIMITER //
CREATE PROCEDURE AddBooking(BookingID INT, CustomerID INT, TableNumber INT, BookingDate DATE, StaffID INT)
BEGIN
INSERT INTO bookings (BookingID, BookingDate, TableNumber, CustomerID, StaffID)
VALUES (BookingID, BookingDate, TableNumber, CustomerID, StaffID);
SELECT 'New booking added' AS Confirmation;
END //
DELIMITER ;

CALL AddBooking(9, 3, 4, '2022-12-30', 1);

# Task 2: Create a procedure to update existing bookings

DELIMITER //
CREATE PROCEDURE UpdateBooking(BookingID INT, BookingDate DATE)
BEGIN
UPDATE bookings SET BookingDate=BookingDate WHERE BookingID=BookingID;
SELECT CONCAT('Booking ', BookingID, ' updated') AS Confirmation;
END //
DELIMITER ;

CALL UpdateBooking(9, '2022-12-17');

# Task 3: Create a procedure to cancel a booking

DELIMITER //
CREATE PROCEDURE CancelBooking(BookingID INT)
BEGIN
DELETE FROM bookings WHERE BookingID=BookingID;
SELECT CONCAT('Booking ', BookingID, ' cancelled') AS Confirmation;
END //
DELIMITER ;

CALL CancelBooking(9);


















