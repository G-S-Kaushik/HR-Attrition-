use project;

select * from hr_1;
alter table hr_1 rename column ï»¿Age to Age;

select * from hr_2;
alter table hr_2 rename column `ï»¿Employee ID` to EmployeeID;

#############################################################################
 #Q1
 
create TABLE PHR AS (select DEPARTMENT, COUNT(ATTRITION) ATTRITION_YES FROM HR_1 WHERE ATTRITION ="YES" group by DEPARTMENT); 
CREATE TABLE PHR1 AS (select DEPARTMENT, COUNT(ATTRITION) TOTAL_ATTRITION FROM HR_1  group by DEPARTMENT); 
SELECT * FROM PHR;
SELECT * FROM PHR1;

SELECT D.DEPARTMENT, ROUND((ATTRITION_YES/TOTAL_ATTRITION)*100,2) "Attrition_Rate%" FROM PHR D INNER JOIN PHR1 E ON (D.DEPARTMENT=E.DEPARTMENT);

##################################################################################
#Q2

select JobRole, ROUND(avg(HourlyRate),2) AVG_HOURLYRATE,  count(GENDER) Male from hr_1 where JobRole="research scientist" and gender ="male";


###############################################################################################
#Q3

create table hr_22 select * ,
CASE WHEN (monthlyincome) > 0 AND (monthlyincome) < 9999
    THEN '0-9999'
    WHEN (monthlyincome) > 10000 AND (monthlyincome) < 19999
    THEN '10000-19999'
    WHEN (monthlyincome) > 20000 AND (monthlyincome) < 29999
    THEN '20000-29999'
    WHEN (monthlyincome) >30000 and (monthlyincome) < 39999 
    THEN '30000-39999'
    WHEN (monthlyincome) > 40000 AND (monthlyincome) < 49999
    THEN '40000-49999'
    WHEN (monthlyincome) > 50000 AND (monthlyincome) < 59999
    THEN '50000-59999'
    ELSE '600000'
    END as bin
    from hr_2;


create table Atrrition_yes as (select department, count(attrition) as yescount from hr_1 where attrition='YES' group by department);

create table tot_Attrition as (select department, count(attrition) as totalcount from hr_1 group by department);
show tables;
select * from atrrition_yes;
select * from tot_attrition;

create table Attrition_rate as (select a1.department,a1.yescount,a2.totalcount,(a1.yescount/a2.totalcount)*100 as Attritionrate from atrrition_yes as A1 join tot_attrition as A2 
on a1.department=a2.department);

create table total_monthlyincom (select department,count(monthlyincome) as monthlyincom,sum(monthlyincome) as total_income,bin from hr_1 join hr_22 on employeenumber=employeeid where attrition = 'yes' group by department,bin);
select * from total_monthlyincom group by department,bin;

create table kpi3 select a.department,a.attritionrate,
b.monthlyincom,total_income,b.bin
from attrition_rate as a join total_monthlyincom as b
on a.department=b.department order by bin ;

select * from kpi3;

#####################################################################################

#Q4

select department, ROUND(avg(totalworkingyears),2) "Avg Working Yers" from hr_1 h1 inner join hr_2 h2 on ( h1.employeenumber=h2.employeeID) group by department;

#####################################################################################
#Q5
select * from hr_1;
select * from hr_2;
SELECT JOBROLE, COUNT(WorkLifeBalance) WORKLIFEBALANCE, avg(WORKLIFEBALANCE) AVG_WORKLIFEBALANCE from hr_1 h1 inner join hr_2 h2 on ( h1.employeenumber=h2.employeeID) group by JOBROLE;

####################################################################################
#Q6 

create table hr_222 select *,
case 
when (yearsSincelastpromotion) >= 0 and (yearsSincelastpromotion) <=5 then '0-5'
when (yearsSincelastpromotion) > 5 and (yearsSincelastpromotion) <=10 then '6-10'
when (yearsSincelastpromotion) >10 and (yearsSincelastpromotion) <=15 then '11-15'
when (yearsSincelastpromotion) > 15 and (yearsSincelastpromotion) <= 20 then '16-20'
when (yearsSincelastpromotion) >20 and (yearsSincelastpromotion) <=25 then '21-25'
when (yearsSincelastpromotion) >25 and (yearsSincelastpromotion) <=30 then '26-30'
when (yearsSincelastpromotion) >30 and (yearsSincelastpromotion) <=35 then '31-35'
when (yearsSincelastpromotion) >=35 and (yearsSincelastpromotion) <=40 then '36-40'
end as yearsSinceLastPromotionbin
from hr_2 ;

select attrition,Department,EmployeeNumber,YearsSinceLastPromotion,YearsSinceLastPromotionbin from  hr_1 full join hr_222 on EmployeeID= EmployeeNumber;

create table Atrrition_yes as (select department, count(attrition) as yescount from hr_1 where attrition='YES' group by department);

create table tot_Attrition as (select department, count(attrition) as totalcount from hr_1 group by department);

create table Attrition_rate as (select a1.department,a1.yescount,a2.totalcount,(a1.yescount/a2.totalcount)*100 as Attritionrate from atrrition_yes as A1 join tot_attrition as A2 
on a1.department=a2.department);

select * from attrition_rate;



create table AttritionVsYearslastpromotion(select t1.Department,count(t2.YearsSinceLastPromotion) as yearssincelastpromotion,YearsSinceLastPromotionbin as bin ,t3.attritionrate,t3.yescount,t3.totalcount from hr_222 as t2 join hr_1 as t1 on 
t2.EmployeeID=t1.EmployeeNumber join Attrition_rate as t3 on t1.department=t3.department group by department,bin);


select * from Attritionvsyearslastpromotion order by bin;


