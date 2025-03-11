use Pharmacy_Claims;

/* Seeing all the tables */
SELECT * FROM dim_brand_drug;
select * from dim_drug;
select * from dim_from_drug;
select * from dim_member;
select * from fact_payment;

/*--------------------------------------------------------------------*/

/* PART - II */

ALTER TABLE dim_brand_drug
ADD PRIMARY KEY (drug_brand_generic_code);
SELECT * FROM dim_brand_drug;

ALTER TABLE dim_drug
ADD PRIMARY KEY (drug_ndc);
SELECT * FROM dim_drug;

ALTER TABLE dim_form_drug
MODIFY drug_form_code char(2),
ADD PRIMARY KEY (drug_form_code);
SELECT * FROM dim_form_drug;

ALTER TABLE dim_member
MODIFY member_id int,
ADD PRIMARY KEY (member_id);
SELECT * FROM dim_member;

ALTER TABLE fact_payment
MODIFY member_id int,
MODIFY drug_ndc int,
ADD COLUMN fact_id int NOT NULL AUTO_INCREMENT PRIMARY KEY;
SELECT * FROM fact_payment;


ALTER TABLE fact_payment
ADD FOREIGN KEY member_id_fk(member_id)
REFERENCES dim_member(member_id),
ADD FOREIGN KEY drug_ndc_fk(drug_ndc)
REFERENCES dim_drug(drug_ndc);

ALTER TABLE dim_drug
MODIFY drug_form_code char(2),
ADD FOREIGN KEY dim_from_drug_fk(drug_form_code)
REFERENCES dim_from_drug(drug_form_code),
ADD FOREIGN KEY dim_brand_drug_fk(drug_brand_generic_code)
REFERENCES dim_brand_drug(drug_brand_generic_code);

select * from dim_drug;
select * from dim_brand_drug;
select * from dim_from_drug;

ALTER TABLE dim_drug
MODIFY drug_form_code char(2),
ADD FOREIGN KEY drug_form_fk(drug_form_code)
REFERENCES dim_from_drug(drug_form_code),
ADD FOREIGN KEY drug_brand_fk(drug_brand_generic_code)
REFERENCES dim_brand_drug(drug_brand_generic_code);

/*-----------------------------------------------------------------------------*/

/* PART - IV */

/* 1.	Write a SQL query that identifies the number of prescriptions grouped by drug name. 
Paste your output to this query in the space below here; your code should be included in your .sql file. */

SELECT drug_name, COUNT(*) AS total_prescription
FROM dim_drug dg LEFT JOIN fact_payment fp
ON dg.drug_ndc = fp.drug_ndc 
GROUP BY drug_name 
ORDER BY COUNT(*) DESC;

/*2.	Write a SQL query that counts total prescriptions, counts unique (i.e. distinct) members,
 sums copay,andsumsinsurancepaid, for members grouped as either ‘age 65+’ or ’ < 65’. 
 Use case statement logic to develop this query similar to lecture 3.
 Paste your output in the space below here; your code should be included in your .sql file. */

SELECT COUNT(fp.drug_ndc) AS total_Prescription, 
COUNT(DISTINCT fp.member_id) AS total_member,
SUM(fp.copay) AS total_copay,
SUM(fp.insurancepaid) AS total_insurance_pay , 
CASE 
WHEN DM.member_age > 65 THEN 'Members age above 65'
WHEN DM.member_age < 65 THEN 'Members age below 65'
END AS age_category
FROM fact_payment fp  LEFT JOIN dim_member dm
ON fp.member_id = dm.member_id
GROUP BY age_category;


/*Write a SQL query that identifies the amount paid by the insurance for the
 most recent prescription fill date. Use the format that we learned with SQL Window functions. 
 Your output should be a table with member_id, member_first_name, member_last_name, drug_name, 
 fill_date (most recent), and most recent insurance paid. Paste your output in the space below here; 
 your code should be included in your .sql file.*/
 
SELECT fp.member_id,dm.member_first_name,dm.member_last_name,d.drug_name,fp.fill_date,fp.insurancepaid,
ROW_NUMBER() OVER(partition by fp.fill_date ) AS flag
FROM fact_payment fp LEFT JOIN dim_member dm 
ON fp.member_id = dm.member_id 
LEFT JOIN dim_drug d 
ON fp.drug_ndc = d.drug_ndc;






