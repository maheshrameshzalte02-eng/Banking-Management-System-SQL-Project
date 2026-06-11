-- CUSTOMERS TABLE---

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    PhoneNo VARCHAR(15),
    City VARCHAR(50),
    AccountType VARCHAR(20),
    AccountNo INT
);
----------------------------------------------------------------------

-- ACCOUNTS TABLE--
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    CustomerID INT,
    Balance NUMERIC(12,2),
    OpenDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-------------------------------------------------------------------------

 -- TRANSACTIONS TABLE--

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionType VARCHAR(20),
    Amount NUMERIC(12,2),
    TransactionDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);
---------------------------------------------------------------------------

 --LOANS TABLE--

CREATE TABLE Loans (
    LoanID INT PRIMARY KEY,
    CustomerID INT,
    LoanAmount NUMERIC(12,2),
    LoanType VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
