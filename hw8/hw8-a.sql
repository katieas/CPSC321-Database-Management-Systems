/**********************************************************************
 * NAME: Katie Stevens
 * CLASS: CPSC 321 Database Management Systems
 * DATE: 11/28/21
 * HOMEWORK: HW8
 * DESCRIPTION: Factbook table queries
 **********************************************************************/

USE kstevens3_DB;

SELECT * FROM Country;
SELECT * FROM Province;
SELECT * FROM City;
SELECT * FROM Border;

-- TODO: add queries with comments below

-- (a)
SELECT country_code, SUM(area)
FROM Province
GROUP BY country_code;

-- (b)
SELECT c.country_code, c.country_name, c.gdp, c.inflation, SUM(c1.population)
FROM Country c JOIN City c1 USING (country_code)
GROUP BY country_code;

-- (c)
SELECT p.country_code, p.province_name, p.area, SUM(c1.population)
FROM Province p JOIN City c1 USING (province_name)
GROUP BY p.province_name
HAVING SUM(c1.population) > 400000;

-- (d)
SELECT country_code, country_name, COUNT(*)
FROM Country c JOIN City c1 USING (country_code)
GROUP BY c.country_code
ORDER BY COUNT(*) DESC;

-- (e)
SELECT c.country_code, c.gdp, SUM(area), COUNT(*)
FROM Country c JOIN Province p USING (country_code)
     JOIN City c1 USING (province_name)
GROUP BY c.country_code
HAVING SUM(area) < 40000 AND SUM(gdp) > 30000
ORDER BY COUNT(*), gdp DESC;

-- (f)
SELECT c.country_code, COUNT(*)
FROM Country c JOIN Province p USING (country_code)
     JOIN City c1 USING (province_name)
GROUP BY c.country_code
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                        FROM Country c JOIN Province p USING (country_code)
                             JOIN City c1 USING (province_name)
                        GROUP BY c.country_code);

