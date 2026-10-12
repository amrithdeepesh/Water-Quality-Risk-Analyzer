CREATE DATABASE IF NOT EXISTS water_quality_analyzer
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE water_quality_analyzer;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(80) NOT NULL,
    password_salt CHAR(32) NOT NULL,
    password_hash CHAR(64) NOT NULL,
    user_type VARCHAR(24) NOT NULL DEFAULT 'casual',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS water_samples (
    id BIGINT NOT NULL AUTO_INCREMENT,
    submitted_by VARCHAR(80) NULL,
    state VARCHAR(100) NOT NULL,
    city VARCHAR(120) NOT NULL,
    water_source VARCHAR(40) NOT NULL,
    collection_date DATE NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    ph DECIMAL(6,2) NULL,
    turbidity DECIMAL(9,2) NULL,
    tds DECIMAL(10,2) NULL,
    dissolved_oxygen DECIMAL(7,2) NULL,
    temperature DECIMAL(6,2) NULL,
    hardness DECIMAL(9,2) NULL,
    free_chlorine DECIMAL(7,3) NULL,
    coliform_detected BOOLEAN NULL,
    risk_score TINYINT UNSIGNED NOT NULL,
    risk_level VARCHAR(20) NOT NULL,
    is_demo BOOLEAN NOT NULL DEFAULT FALSE,
    include_on_map BOOLEAN NOT NULL DEFAULT FALSE,
    data_source VARCHAR(100) NOT NULL DEFAULT 'User submitted',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY ix_samples_state_date (state, collection_date),
    KEY ix_samples_risk_date (risk_level, collection_date),
    KEY ix_samples_demo (is_demo)
) ENGINE=InnoDB;

INSERT INTO water_samples
(city,state,water_source,collection_date,latitude,longitude,risk_score,risk_level,is_demo,data_source)
SELECT seed.city,seed.state,seed.water_source,seed.collection_date,seed.latitude,seed.longitude,
       seed.risk_score,seed.risk_level,TRUE,'Synthetic demonstration dataset'
FROM (
    SELECT 'Delhi','Delhi','Tap Water','2026-10-10',28.613900,77.209000,35,'Moderate' UNION ALL
    SELECT 'Mumbai','Maharashtra','Borewell','2026-10-09',19.076000,72.877700,62,'High' UNION ALL
    SELECT 'Pune','Maharashtra','Tap Water','2026-10-08',18.520400,73.856700,14,'Safe' UNION ALL
    SELECT 'Bengaluru','Karnataka','Borewell','2026-10-10',12.971600,77.594600,42,'Moderate' UNION ALL
    SELECT 'Chennai','Tamil Nadu','Tap Water','2026-10-07',13.082700,80.270700,18,'Safe' UNION ALL
    SELECT 'Coimbatore','Tamil Nadu','Well','2026-10-06',11.016800,76.955800,58,'High' UNION ALL
    SELECT 'Hyderabad','Telangana','Borewell','2026-10-10',17.385000,78.486700,83,'Critical' UNION ALL
    SELECT 'Visakhapatnam','Andhra Pradesh','Tap Water','2026-10-05',17.686800,83.218500,38,'Moderate' UNION ALL
    SELECT 'Kolkata','West Bengal','Tap Water','2026-10-09',22.572600,88.363900,66,'High' UNION ALL
    SELECT 'Bhubaneswar','Odisha','Well','2026-10-08',20.296100,85.824500,20,'Safe' UNION ALL
    SELECT 'Lucknow','Uttar Pradesh','Borewell','2026-10-07',26.846700,80.946200,60,'High' UNION ALL
    SELECT 'Varanasi','Uttar Pradesh','River','2026-10-04',25.317600,82.973900,91,'Critical' UNION ALL
    SELECT 'Jaipur','Rajasthan','Borewell','2026-10-09',26.912400,75.787300,47,'Moderate' UNION ALL
    SELECT 'Bhopal','Madhya Pradesh','Tap Water','2026-10-06',23.259900,77.412600,16,'Safe' UNION ALL
    SELECT 'Patna','Bihar','Well','2026-10-08',25.594100,85.137600,69,'High' UNION ALL
    SELECT 'Ranchi','Jharkhand','Borewell','2026-10-05',23.344100,85.309600,39,'Moderate' UNION ALL
    SELECT 'Raipur','Chhattisgarh','Tap Water','2026-10-09',21.251400,81.629600,12,'Safe' UNION ALL
    SELECT 'Guwahati','Assam','River','2026-10-10',26.144500,91.736200,71,'High' UNION ALL
    SELECT 'Agartala','Tripura','Well','2026-10-03',23.831500,91.286800,33,'Moderate' UNION ALL
    SELECT 'Shillong','Meghalaya','Spring','2026-10-07',25.578800,91.893300,9,'Safe' UNION ALL
    SELECT 'Imphal','Manipur','Spring','2026-10-08',24.817000,93.936800,31,'Moderate' UNION ALL
    SELECT 'Aizawl','Mizoram','Spring','2026-10-06',23.727100,92.717600,11,'Safe' UNION ALL
    SELECT 'Kohima','Nagaland','Spring','2026-10-04',25.674700,94.110000,36,'Moderate' UNION ALL
    SELECT 'Itanagar','Arunachal Pradesh','River','2026-10-05',27.084400,93.605300,10,'Safe' UNION ALL
    SELECT 'Dehradun','Uttarakhand','Spring','2026-10-10',30.316500,78.032200,14,'Safe' UNION ALL
    SELECT 'Shimla','Himachal Pradesh','Spring','2026-10-06',31.104800,77.173400,8,'Safe' UNION ALL
    SELECT 'Amritsar','Punjab','Borewell','2026-10-08',31.634000,74.872300,88,'Critical' UNION ALL
    SELECT 'Chandigarh','Chandigarh','Tap Water','2026-10-09',30.733300,76.779400,41,'Moderate' UNION ALL
    SELECT 'Panaji','Goa','Tap Water','2026-10-03',15.490900,73.827800,17,'Safe' UNION ALL
    SELECT 'Gandhinagar','Gujarat','Borewell','2026-10-07',23.215600,72.636900,63,'High' UNION ALL
    SELECT 'Thiruvananthapuram','Kerala','Well','2026-10-09',8.524100,76.936600,13,'Safe' UNION ALL
    SELECT 'Mysuru','Karnataka','Tap Water','2026-10-02',12.295800,76.639400,29,'Moderate' UNION ALL
    SELECT 'Jammu','Jammu and Kashmir','Spring','2026-10-05',32.726600,74.857000,34,'Moderate' UNION ALL
    SELECT 'Srinagar','Jammu and Kashmir','River','2026-10-01',34.083700,74.797300,59,'High' UNION ALL
    SELECT 'Port Blair','Andaman and Nicobar Islands','Well','2026-10-04',11.623400,92.726500,15,'Safe' UNION ALL
    SELECT 'Puducherry','Puducherry','Tap Water','2026-10-08',11.941600,79.808300,27,'Moderate' UNION ALL
    SELECT 'Silvassa','Dadra and Nagar Haveli and Daman and Diu','Well','2026-10-02',20.276600,73.008300,56,'High' UNION ALL
    SELECT 'Kavaratti','Lakshadweep','Well','2026-10-02',10.566700,72.641700,19,'Safe' UNION ALL
    SELECT 'Gurugram','Haryana','Borewell','2026-10-11',28.459500,77.026600,64,'High' UNION ALL
    SELECT 'Gangtok','Sikkim','Spring','2026-10-11',27.338900,88.606500,22,'Safe' UNION ALL
    SELECT 'Leh','Ladakh','Spring','2026-10-12',34.152600,77.577100,28,'Moderate'
) AS seed(city,state,water_source,collection_date,latitude,longitude,risk_score,risk_level)
WHERE NOT EXISTS (
    SELECT 1 FROM water_samples existing
    WHERE existing.is_demo = TRUE
      AND existing.city = seed.city AND existing.state = seed.state
);
