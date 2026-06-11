-- CUSTOMERS TABLE---

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    PhoneNo VARCHAR(15),
    City VARCHAR(50),
    AccountType VARCHAR(20),
    AccountNo INT
);

  --CUSTOMERS TABLE DATA--

INSERT INTO Customers VALUES
(1,'Rahul Sharma','9876543210','Pune','Savings',1001),
(2,'Sneha Patil','9988776655','Mumbai','Current',1002),
(3,'Aman Verma','9123456780','Nagpur','Savings',1003),
(4,'Priya Singh','9012345678','Delhi','Current',1004),
(5,'Karan Mehta','9871203456','Hyderabad','Savings',1005),
(6,'Neha Joshi','9988001122','Pune','Current',1006),
(7,'Rohit Kumar','9765432109','Bangalore','Savings',1007),
(8,'Pooja Sharma','9876540001','Chennai','Savings',1008),
(9,'Vivek Shah','9001122334','Ahmedabad','Current',1009),
(10,'Anjali Verma','9988771100','Jaipur','Savings',1010);

------------------------------------------------------------------------------------------------

 
-- ACCOUNTS TABLE--
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    Balance NUMERIC(12,2),
    OpenDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

   --ACCOUNTS TABLE DATA--
 
INSERT INTO Accounts VALUES
(1001,1,55000,'2025-01-10'),
(1002,2,120000,'2024-11-20'),
(1003,3,35000,'2025-03-15'),
(1004,4,98000,'2025-02-01'),
(1005,5,75000,'2025-01-25'),
(1006,6,150000,'2024-12-18'),
(1007,7,42000,'2025-04-10'),
(1008,8,88000,'2025-05-05'),
(1009,9,200000,'2024-09-30'),
(1010,10,67000,'2025-03-22');

----------------------------------------------------------------------------------------------------------

  -- TRANSACTIONS TABLE--

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount NUMERIC(12,2),
    TransactionDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

    --TRANSACTIONS TABLE--
  
INSERT INTO Transactions VALUES
(1,1001,'Deposit',10000,'2026-06-01'),
(2,1001,'Withdraw',5000,'2026-06-02'),
(3,1002,'Deposit',25000,'2026-06-02'),
(4,1003,'Withdraw',3000,'2026-06-03'),
(5,1004,'Deposit',15000,'2026-06-04'),
(6,1005,'Deposit',12000,'2026-06-05'),
(7,1006,'Withdraw',7000,'2026-06-05'),
(8,1007,'Deposit',9000,'2026-06-06'),
(9,1008,'Withdraw',4500,'2026-06-06'),
(10,1009,'Deposit',30000,'2026-06-07'),
(11,1010,'Withdraw',2000,'2026-06-07'),
(12,1002,'Withdraw',10000,'2026-06-08'),
(13,1003,'Deposit',5000,'2026-06-08'),
(14,1005,'Withdraw',3500,'2026-06-09'),
(15,1007,'Deposit',15000,'2026-06-09');

-------------------------------------------------------------------------------------------

  --LOANS TABLE--

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanAmount NUMERIC(12,2),
    LoanType VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

   --LOANS TABLE DATA--

INSERT INTO Loans VALUES
(1,1,500000,'Home Loan'),
(2,2,200000,'Car Loan'),
(3,4,100000,'Education Loan'),
(4,5,300000,'Business Loan'),
(5,6,150000,'Personal Loan'),
(6,8,250000,'Home Loan'),
(7,9,400000,'Business Loan'),
(8,10,180000,'Car Loan');

---------------------------------------------------------


SELECT * FROM Customers;
SELECT * FROM Accounts;
SELECT * FROM Transactions;
SELECT * FROM Loans;

--------------------------------------------------------------

 --Display customer names, account numbers, and account balances using INNER JOIN--
 
SELECT c.CustomerName,
       c.AccountNo,
       a.Balance
FROM Customers c
INNER JOIN Accounts a
ON c.CustomerID = a.CustomerID;

--Top 3 Highest Balance Customers--

SELECT c.CustomerName,
       a.Balance
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC
LIMIT 3;

---------------------------------------------------------------------------

----Customers with Loan Amount and Loan Type----

SELECT c.CustomerName,
       l.LoanAmount,
       l.LoanType
FROM Customers c
JOIN Loans l
ON c.CustomerID = l.CustomerID;

--------------------------------------------------------------------------

--Total Deposit and Withdrawal Amount--

SELECT TransactionType,
       SUM(Amount) AS TotalAmount
FROM Transactions
GROUP BY TransactionType;

---------------------------------------------------------
--Customer-wise Total Transaction Amount--

SELECT c.CustomerName,
       SUM(t.Amount) AS TotalTransactionAmount
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
JOIN Transactions t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerName;
------------------------------------------------------------
--Customers Having Balance Greater Than Average Balance--

SELECT c.CustomerName,
       a.Balance
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
WHERE a.Balance >
(
    SELECT AVG(Balance)
    FROM Accounts
);

-----------------------------------------------------------

---Highest Transaction Amount Per Customer---

SELECT c.CustomerName,
       MAX(t.Amount) AS HighestTransaction
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
JOIN Transactions t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerName;

---------------------------------------------------------------

---Customers Who Have Not Taken Any Loan--

SELECT c.CustomerName
FROM Customers c
LEFT JOIN Loans l
ON c.CustomerID = l.CustomerID
WHERE l.CustomerID IS NULL;

-------------------------------------------------------------------

---Total Number of Transactions Per Customer---

SELECT c.CustomerName,
       COUNT(t.TransactionID) AS TotalTransactions
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
JOIN Transactions t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerName;

---------------------------------------------------------------------
---Rank Customers by Balance--

SELECT c.CustomerName,
       a.Balance,
       RANK() OVER(ORDER BY a.Balance DESC) AS RankNo
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID;

--------------------------------------------------------------------------

--Dense Rank Customers by Balance--

SELECT c.CustomerName,
       a.Balance,
       DENSE_RANK() OVER(ORDER BY a.Balance DESC) AS DenseRankNo
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID;

---------------------------------------------------------------------------

---Previous Transaction Amount Using LAG()--

SELECT TransactionID,
       Amount,
       LAG(Amount) OVER(ORDER BY TransactionID) AS PreviousAmount
FROM Transactions;

-------------------------------------------------------------------------------

---Next Transaction Amount Using LEAD()--

SELECT TransactionID,
       Amount,
       LEAD(Amount) OVER(ORDER BY TransactionID) AS NextAmount
FROM Transactions;

--------------------------------------------------------------------------------------

--Running Total Using SUM() OVER()--

SELECT TransactionID,
       Amount,
       SUM(Amount) OVER(ORDER BY TransactionID) AS RunningTotal
FROM Transactions;

----------------------------------------------------------------------------------------

--Second Highest Account Balance--

SELECT MAX(Balance) AS SecondHighestBalance
FROM Accounts
WHERE Balance <
(
    SELECT MAX(Balance)
    FROM Accounts
);

---------------------------------------------------------------------------------------------
--Customers Who Performed More Than 2 Transactions--

SELECT c.CustomerName,
       COUNT(t.TransactionID) AS TransactionCount
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
JOIN Transactions t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerName
HAVING COUNT(t.TransactionID) > 2;
--------------------------------------------------------------------------------------
--Customer-wise Minimum and Maximum Transaction Amount--

SELECT c.CustomerName,
       MIN(t.Amount) AS MinimumTransaction,
       MAX(t.Amount) AS MaximumTransaction
FROM Customers c
JOIN Accounts a
ON c.CustomerID = a.CustomerID
JOIN Transactions t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerName;

--------------------------------------------------------------------------------------------
