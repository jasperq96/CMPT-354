/* Schema
Customer = {customerID, firstName, lastName, income, birthDate }
Account = {accNumber, type, balance, branchNumberBranch}
Owns = {customerIDCustomer, accNumberAccount}
Transactions = {transNumber, accNumberAccount, amount}
Employee = {sin, firstName, lastName, salary, branchNumberBranch}
Branch = {branchNumber, branchName, managerSINEmployee, budget}
*/

with JT as (
	select distinct a.branchNumber
	from Customer C 
	inner join Owns O on C.customerID = O.customerID 
	inner join Account A on a.accNumber = O.accNumber 
	where C.firstName = 'Jack' and C.lastName = 'Anderson'
)
select C2.customerId, C2.firstName, C2.lastName, C2.birthDate
from Customer C2 
inner join Owns O2 on O2.customerID = C2.customerID
inner join Account A2 on A2.accNumber = O2.accNumber 
inner join JT on JT.branchNumber = A2.branchNumber
group by C2.customerID, C2.firstName, C2.lastName, C2.birthDate
having count(distinct A2.branchNumber) = (select count(*) from JT) --AND firstName <> 'Jack' AND lastName <> 'Anderson'





/* Question 14
select A.accNumber, balance, sum(amount) as Total_Transactions, balance - sum(amount) as Money_Left
from Account A
inner join Transactions T ON T.accNumber = A.accNumber 
inner join Branch B ON B.branchNumber = A.branchNumber AND branchName = 'London'
group by A.accNumber, A.balance
having max(transNumber) >= 10
order by A.accNumber
*/

/* Question 13
select C.customerID, lastName, firstName, income, avg(balance) AS average_balance
from Customer C
inner join Owns O ON C.customerID = O.customerID
inner join Account A ON A.accNumber = O.accNumber

group by C.customerID, lastName, firstName, income
having count(O.accNumber) >= 3 AND lastName like 'Jo%s%' OR firstName like 'A%[aeiou]_'
order by C.customerID
*/

/* Question 12
-- avg income for 60+ $55256
-- avg income for <60 $53090
select avg(A.income) as Average_income_above_60, avg(B.income) as Average_income_below_60
from Customer A, Customer B
where datepart(year, cast(getdate() as Date)) - datePart(year, A.birthDate) > 60.0 
AND datepart(year, cast(getdate() as Date)) - datePart(year, B.birthDate) < 60.0
*/

/* Question 11
select branchName, min(salary) as minimumSalary, max(salary)as maximumSalary, avg(salary) as averageSalary
from Employee E
inner join Branch B ON B.branchNumber = E.branchNumber
group by branchName
order by branchName
*/

/* Question 10
select count(distinct firstName) as Different_first_names, count(sin) as Total_Employees
from Employee E
inner join  Branch B ON B.branchNumber = E.branchNumber AND branchName = 'Latveria'
*/

/* Question 9
select SUM(salary) as Total_Salary
from Employee E
inner join  Branch B ON B.branchNumber = E.branchNumber AND branchName = 'London'
*/

/* Question 8
select sin, firstName, lastName, salary
from Employee E
inner join Branch B ON E.branchNumber = B.branchNumber AND branchName = 'New York'
where salary = ALL(
select max(salary) 
from Employee em
inner join Branch Br ON em.branchNumber = Br.branchNumber AND branchName = 'New York'
)
order by sin
*/

/* Question 7
with JT as (
	select distinct a.branchNumber
	from Customer C 
	inner join Owns O on C.customerID = O.customerID 
	inner join Account A on a.accNumber = O.accNumber 
	where C.firstName = 'Jack' and C.lastName = 'Anderson'
)
select C2.customerId, C2.firstName, C2.lastName, C2.birthDate
from Customer C2 
inner join Owns O2 on O2.customerID = C2.customerID
inner join Account A2 on A2.accNumber = O2.accNumber 
inner join JT on JT.branchNumber = A2.branchNumber
group by C2.customerID, C2.firstName, C2.lastName, C2.birthDate
having count(distinct A2.branchNumber) = (select count(*) from JT) AND firstName <> 'Jack' AND lastName <> 'Anderson'
)

*/

/* Question 6
select sin, firstName, salary, B.branchName
from Employee E
left join Branch B ON E.sin = B.managerSIN
where E.salary > 75000
order by salary DESC
*/

/* Question 5
select distinct C.customerID
from Customer C
inner join Owns O ON O.customerID = C.customerID
inner join Account A ON A.accNumber = O.accNumber
inner join Branch B ON B.branchNumber = A.branchNumber AND branchName = 'London'
where C.customerID not in (
select C2.customerID 
from Customer C2
inner join Owns O2 ON O2.customerID = C2.customerID
inner join Account A2 ON A2.accNumber = O2.accNumber
inner join Branch B2 ON B2.branchNumber = A2.branchNumber AND B2.branchName = 'Moscow'
) AND C.customerID not in (
select distinct O.customerID
from Owns O
inner join Owns P ON P.accNumber = O.accNumber AND P.customerID <> O.customerID
inner join Owns PA ON PA.customerID = P.customerID AND PA.accNumber <> P.accNumber
inner join Account A ON A.accNumber = PA.accNumber
inner join Branch B ON B.branchNumber = A.branchNumber AND branchName = 'Moscow'
)
order by C.customerID
*/

/* Question 4
select distinct C.customerID, type, A.accNumber, balance
from Customer C
inner join Owns O ON O.customerID = C.customerID
inner join Account A ON A.accNumber = O.accNumber AND A.type <> 'BUS'
where C.customerID in(
select C2.customerID
from Customer C2
inner join Owns O2 ON O2.customerID = C2.customerID
inner join Account A2 ON A2.accNumber = O2.accNumber AND A2.type <> 'BUS'
group by C2.customerID
having count(distinct type) >= 2
)
order by customerID, type, A.accNumber
*/

/* Question 3
select E.firstName, E.lastName, E.salary
from Employee E, Employee V
where E.salary > V.salary*2 AND V.firstName = 'Victor' AND V.lastName = 'Doom'
order by lastName, firstName
*/

/* Question 2

select branchName, accNumber, balance
from Account A
inner join Branch B ON B.branchNumber = A.branchNumber
where balance > 110000 AND budget > 2000000
order by branchName, accNumber
*/

/* Question 1
select firstName, lastName, income
from Customer
where income > 95000
order by lastName, firstName
*/