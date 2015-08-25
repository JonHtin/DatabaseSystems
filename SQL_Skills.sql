
--2. Find the names of brown items sold by the Recreation department.
Select * FROM Department NATURAL JOIN Sale NATURAL JOIN Item
WHERE DepartmentName = 'Recreation' AND ItemColour = 'Brown';

--3. Of those items delivered, find the items not delivered to the Books department. 
Select * FROM Department NATURAL JOIN Delivery
WHERE DepartmentName Not Like 'Books';

--4. Find the departments that have never sold a geo positioning system
--THIS DOESN’T WORK:
/*
Select DepartmentName, COUNT(*) FROM Department NATURAL JOIN Sale NATURAL JOIN Item
WHERE ItemName = 'Geo positioning system'
Group By DepartmentID
HAVING COUNT(*)=0;
*/
--Only the departments that have sold it are in the table so nothing appears.

--This does tho:
SELECT DepartmentName FROM Department
WHERE DepartmentID NOT IN
	(SELECT DepartmentID FROM Sale NATURAL JOIN Item
	WHERE ItemName = "Geo Positioning System"); 

--5. Find the departments that have sold compasses and at least six other items.
SELECT DepartmentID, DepartmentName FROM Department NATURAL JOIN Sale NATURAL JOIN Item
WHERE DepartmentID IN
(SELECT DepartmentID FROM Sale
	GROUP BY DepartmentID
	HAVING COUNT(DISTINCT ItemID)>5)
AND ItemName LIKE 'Compass';

--6. Find the departments that sell at least 4 items. 
---(Alternative wording: Find the department/s that sell at least 4 different items.)
SELECT DepartmentID, DepartmentName FROM Sale NATURAL JOIN Department
GROUP BY DepartmentID
HAVING COUNT(DISTINCT ItemID)>3

--7. Find the departments that sell at least 4 items and list how many items each department sells 
--(Alternative wording: Find the departments that have made 4 or more transactions and 
--list how many transactions each department has made.)
SELECT DepartmentID, DepartmentName, COUNT(DISTINCT ItemID) FROM Sale NATURAL JOIN Department
GROUP BY DepartmentID
HAVING COUNT(DISTINCT ItemID)>3

--8. Find the employees who are in a the same department as their manager's department.
--NOTE: SELECT F.EmployeeID, F.LastName, S.EmployeeID, S.LastName, F.Country
--FROM Employee F INNER JOIN Employee S ON F.Country = S.Country
--WHERE F.EmployeeID < S.EmployeeID
--ORDER BY F.EmployeeID, S.EmployeeID;
--^above is an example of a self join. Below is the solution:
SELECT Emp.EmployeeID, Emp.EmployeeName
FROM Employee Emp INNER JOIN Employee Boss ON Emp.BossID = Boss.EmployeeID
WHERE Emp.DepartmentID = Boss.DepartmentID;

--9. Find the employees whose salary is less than half that of their managers.
SELECT Emp.EmployeeID, Emp.EmployeeName, Emp.EmployeeSalary, Boss.EmployeeSalary
FROM Employee Emp INNER JOIN Employee Boss ON Emp.BossID = Boss.EmployeeID
WHERE Emp.EmployeeSalary < Boss.EmployeeSalary/2;

--10. Find the brown items sold by no department on the second floor. 
Select DISTINCT ItemName FROM Department NATURAL JOIN Sale NATURAL JOIN Item 
WHERE DepartmentFloor != 2 AND ItemColour = 'Brown';
--***NOTE this is wrong, it doesn't pick up if the item isn't sold by any department.
	
--11. Find items delivered by all suppliers
SELECT ItemID, ItemName FROM Item NATURAL JOIN Supplier NATURAL JOIN Delivery
GROUP BY ItemID
HAVING COUNT(DISTINCT SupplierID) =
	(SELECT COUNT(DISTINCT SupplierID) FROM Supplier);

--12.  Find the items delivered by at least two suppliers.
SELECT ItemID, ItemName FROM Item NATURAL JOIN Supplier NATURAL JOIN Delivery
GROUP BY ItemID
HAVING COUNT(DISTINCT SupplierID) >= 2;

--13. Find the items not delivered by Nepalese Corp 
--(Alternative wording: Find any items that have never been delivered by Nepalese Corp.)
SELECT ItemName From Item
WHERE ItemID NOT IN
	(SELECT ItemID FROM Item NATURAL JOIN Supplier NATURAL JOIN Delivery
		WHERE SupplierName LIKE 'Nepalese Corp.');

--14. Find the items sold by at least two departments. 
Select DISTINCT ItemName FROM Department NATURAL JOIN Sale NATURAL JOIN Item 
GROUP BY ItemID
HAVING COUNT(DepartmentID)>=2;

--15. Find the items delivered for which there have been no sales.
SELECT DISTINCT ItemName FROM Delivery NATURAL JOIN Item
WHERE ItemID NOT IN
	(Select DISTINCT ItemID FROM Sale);

--16. Find the items delivered to all departments except Administration departments (Management, Marketing, Personnel, Accounting, Purchasing). 
SELECT ItemID, ItemName FROM Item NATURAL JOIN Delivery NATURAL JOIN Department
WHERE ItemID IN
	(SELECT DISTINCT ItemID FROM Delivery NATURAL JOIN Department
		WHERE DepartmentName NOT IN ('Management', 'Marketing', 'Personnel',  
								'Accounting', 'Purchasing')
	)
GROUP BY ItemID
HAVING COUNT(DISTINCT DepartmentID) IN
	(SELECT COUNT(DISTINCT DepartmentID) FROM Department
		WHERE DepartmentName NOT IN ('Management', 'Marketing', 'Personnel',  
								'Accounting', 'Purchasing')
	);

--17. Find the name of the highest-paid employee in the Marketing department.
SELECT EmployeeName, MAX(EmployeeSalary) FROM Employee INNER JOIN Department
WHERE DepartmentName = 'Marketing';

--18. Find the names of employees who make 40 per cent less than the average salary. 
SELECT EmployeeName FROM Employee
WHERE EmployeeSalary <= (SELECT AVG(EmployeeSalary)*0.60 FROM Employee)

--19.

--20. Find the names of suppliers that do not supply compasses or geo positioning systems. 
SELECT SupplierName FROM Supplier 
WHERE SupplierID NOT IN (
	SELECT DISTINCT SupplierID FROM Supplier NATURAL JOIN Delivery NATURAL JOIN Item
    WHERE ItemName = 'Geopositioning system' OR ItemName = 'Compass');
