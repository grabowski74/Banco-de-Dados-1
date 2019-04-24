/*
    Roteiro 04
    Matheus Silva Araujo
    117210375
*/

-- Question01
SELECT * FROM department;

-- Question02
SELECT * FROM dependent;

-- Question03
SELECT * FROM dept_locations;

-- Question04
SELECT * FROM employee;

-- Question05
SELECT * FROM project;

-- Question06
SELECT * FROM works_on;

-- Question07
SELECT fname, lname FROM employee WHERE sex = 'M';

-- Question08
SELECT fname FROM employee WHERE superssn IS null;

-- Question09
SELECT e.fname, s.fname FROM employee AS e, employee AS s WHERE e.superssn = s.ssn;

-- Question10
SELECT e.fname FROM employee AS e, employee AS s WHERE e.superssn = s.ssn AND s.fname = 'Franklin';

-- Question11
SELECT a.dname, b.dlocation FROM department AS a, dept_locations AS b WHERE a.dnumber = b.dnumber;

-- Question12
SELECT a.dname FROM department AS a, dept_locations AS b WHERE a.dnumber = b.dnumber AND b.dlocation LIKE '%S%';

-- Question13
SELECT DISTINCT a.fname, a.lname FROM employee AS a, dependent AS b WHERE a.ssn = b.essn;

-- Question14
SELECT (fname || ' ' || minit || '. ' || lname) as full_name, salary FROM employee WHERE salary > 50000;

-- Question15
SELECT p.pname, d.dname FROM project AS p, department AS d WHERE p.dnum = d.dnumber;

-- Question16
SELECT p.pname, m.fname FROM project AS p, employee AS m, department as d WHERE p.dnum = d.dnumber AND m.ssn = d.mgrssn AND p.pnumber > 30;

-- Question17
SELECT p.pname, e.fname FROM project AS p, employee AS e, works_on AS w WHERE w.pno = p.pnumber AND w.essn = e.ssn;

-- Question18
SELECT e.fname, d.dependent_name, d.relationship FROM dependent AS d, employee as e, works_on as w WHERE w.essn = e.ssn AND d.essn = e.ssn AND w.pno = 91;