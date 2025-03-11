# Pharmacy-Claims-Data-Warehouse-Star-Schema-Design-SQL-Analytics

## **Project Overview**  
This project focuses on **optimizing pharmaceutical claims data** by transforming it into a **star schema** for reporting and analysis. The raw data is **normalized into Third Normal Form (3NF)** and then classified into **fact and dimension tables**. The schema is implemented in **MySQL**, ensuring **referential integrity** using **primary and foreign keys**. Finally, **SQL queries** are written to analyze prescription statistics and member demographics.  

## **Objective**  
- Design a **star schema** to improve **query performance and data analysis**.  
- Implement **data integrity constraints** using **primary and foreign keys**.  
- Write **SQL queries** to extract meaningful insights from the claims data.  

---

## **Star Schema Design**  

### **Fact Table**  
#### **`fact_payment`**  
- **Grain**: Each row represents a **prescription transaction** for a specific drug on a given fill date.  
- **Fact Variables**:  
  - `copay` (Additive)  
  - `insurance_paid` (Additive)  
- **Primary Key**: `fact_id` (Surrogate Key)  
- **Foreign Keys**:  
  - `member_id_fk` → References `dim_member(member_id)`  
  - `drug_ndc_fk` → References `dim_drug(drug_ndc)`  

### **Dimension Tables**  
#### **`dim_member`** (Member Details)  
- **Primary Key**: `member_id` (Natural Key)  
- **Attributes**: Name, Age, Gender  

#### **`dim_drug`** (Drug Details)  
- **Primary Key**: `drug_ndc` (Natural Key)  
- **Foreign Keys**:  
  - `drug_form_fk` → References `dim_form_drug(drug_form_code)`  
  - `drug_brand_fk` → References `dim_brand_drug(drug_brand_generic_code)`  

#### **`dim_form_drug`** (Drug Form)  
- **Primary Key**: `drug_form_id` (Natural Key)  

#### **`dim_brand_drug`** (Drug Brand)  
- **Primary Key**: `drug_brand_generic_code` (Natural Key)  

---

## **Database Implementation**  

### **Primary & Foreign Keys**  
- **Primary Keys (PKs)**  
  - `dim_member(member_id)`, `dim_drug(drug_ndc)`, `fact_payment(fact_id)`, `dim_form_drug(drug_form_id)`, `dim_brand_drug(drug_brand_generic_code)`  

- **Foreign Keys (FKs) & Constraints**  
  - **`fact_payment.member_id_fk` → `dim_member.member_id`** (`CASCADE` on delete/update)  
  - **`fact_payment.drug_ndc_fk` → `dim_drug.drug_ndc`** (`CASCADE` on delete/update)  
  - **`dim_drug.drug_form_fk` → `dim_form_drug.drug_form_id`** (`CASCADE`)  
  - **`dim_drug.drug_brand_fk` → `dim_brand_drug.drug_brand_generic_code`** (`CASCADE`)  

**Reason for using `CASCADE`:** Ensures **referential integrity**, preventing orphan records when deleting/updating related entries.  

---

## **SQL Queries & Analysis**  

### **1️ Number of Prescriptions for Ambien**
```sql
SELECT COUNT(*) AS total_prescriptions
FROM fact_payment fp
JOIN dim_drug dd ON fp.drug_ndc_fk = dd.drug_ndc
WHERE dd.drug_name = 'Ambien';
```
 **Result:** `5 prescriptions filled for Ambien.`  

### **2️ Unique Members Over 65 Years of Age**
```sql
SELECT COUNT(DISTINCT member_id) AS unique_seniors
FROM dim_member
WHERE age > 65;
```
 **Result:** `1 unique member is over 65.`  

### **3️ Prescriptions Filled by the Member Over 65**
```sql
SELECT COUNT(*) AS total_prescriptions
FROM fact_payment
WHERE member_id_fk IN (
    SELECT member_id FROM dim_member WHERE age > 65
);
```
 **Result:** `6 prescriptions filled by this member.`  

### **4️ Most Recent Prescription for Member ID `10003`**
```sql
SELECT dd.drug_name, fp.fill_date
FROM fact_payment fp
JOIN dim_drug dd ON fp.drug_ndc_fk = dd.drug_ndc
WHERE fp.member_id_fk = 10003
ORDER BY fp.fill_date DESC
LIMIT 1;
```
 **Result:** `Most recent prescription: Ambien (Filled on May 16, 2018).`  

### **5️ Insurance Payment for the Most Recent Prescription**
```sql
SELECT insurance_paid
FROM fact_payment
WHERE member_id_fk = 10003
ORDER BY fill_date DESC
LIMIT 1;
```
 **Result:** `$322 paid by the insurer.`  

---

## **Entity-Relationship Diagram (ERD)**  
 The ERD illustrates **relationships between fact and dimension tables**. The schema is structured as follows:  
- **1 Fact Table** (`fact_payment`)  
- **4 Dimension Tables** (`dim_member`, `dim_drug`, `dim_form_drug`, `dim_brand_drug`)  

 *The ERD diagram is available in the project files (`ERD.png`).*  

---

## **Project Tools & Technologies**  
- **Database:** MySQL  
- **Query Language:** SQL  
- **Schema Design:** Star Schema  
- **Data Integrity:** Primary & Foreign Keys with `CASCADE` constraints  

---

## **Conclusion & Insights**  
- **Data transformation into a star schema** enhanced **query efficiency**.  
- **Additive facts (`copay`, `insurance_paid`)** enabled **aggregated financial analysis**.  
- **Foreign key constraints (`CASCADE`)** maintained **referential integrity**.  
- **SQL queries extracted meaningful insights**, such as **prescription trends and member demographics**.  

### **Future Enhancements**  
**Optimize indexing** for faster query execution.  
**Introduce additional dimensions** (e.g., pharmacy locations).  
**Enhance reporting capabilities** with stored procedures and views.  

---

## **How to Run the Project Locally**  

### **1️ Clone the Repository**  
```bash
git clone https://github.com/your-username/pharmacy-claims-analysis.git
cd pharmacy-claims-analysis
```

### **2️ Set Up MySQL Database**  
1. Open MySQL Workbench or command line.  
2. Run the **schema SQL script**:  
   ```sql
   SOURCE schema.sql;
   ```
3. Load the **sample data**:  
   ```sql
   SOURCE data.sql;
   ```

### **3️ Run SQL Queries**  
- Open **`queries.sql`** in MySQL Workbench.  
- Execute queries to extract insights.  

---

## **References**  
- [[Granularity in Data Analysis](https://www.talon.one/glossary/granularity)](https://www.talon.one/glossary/granularity)  
- [[Star Schema Design in SQL Server](https://www.mssqltips.com/sqlservertip/5690/create-a-star-schema-data-model-in-sql-server-using-the-microsoft-toolset/)  ](https://www.mssqltips.com/sqlservertip/5690/create-a-star-schema-data-model-in-sql-server-using-the-microsoft-toolset/)
