-- Idempotent synthetic map and dashboard practice rows; never real measurements.
USE water_quality_analyzer;

INSERT INTO water_samples
(city,state,water_source,collection_date,latitude,longitude,ph,turbidity,tds,dissolved_oxygen,temperature,hardness,free_chlorine,coliform_detected,risk_score,risk_level,is_demo,include_on_map,data_source)
SELECT seed.city,seed.state,seed.water_source,seed.collection_date,seed.latitude,seed.longitude,seed.ph,seed.turbidity,seed.tds,seed.dissolved_oxygen,seed.temperature,seed.hardness,seed.free_chlorine,seed.coliform_detected,seed.risk_score,seed.risk_level,TRUE,FALSE,'Synthetic demonstration dataset'
FROM (
    SELECT 'WQ Demo Site 001' AS city, 'Bihar' AS state, 'Well' AS water_source, '2026-09-22' AS collection_date, 25.552935 AS latitude, 85.093335 AS longitude, 7.91 AS ph, 6.84 AS turbidity, 1123 AS tds, 4.39 AS dissolved_oxygen, 28.85 AS temperature, 197 AS hardness, 1.312 AS free_chlorine, FALSE AS coliform_detected, 70 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 002' AS city, 'Meghalaya' AS state, 'River' AS water_source, '2026-08-10' AS collection_date, 25.563831 AS latitude, 91.764682 AS longitude, 6.86 AS ph, 3.43 AS turbidity, 118 AS tds, 7.24 AS dissolved_oxygen, 29.69 AS temperature, 498 AS hardness, 0.645 AS free_chlorine, TRUE AS coliform_detected, 0 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 003' AS city, 'Bihar' AS state, 'Tap Water' AS water_source, '2026-07-25' AS collection_date, 25.734089 AS latitude, 85.068978 AS longitude, 8.12 AS ph, 1.53 AS turbidity, 667 AS tds, 7.36 AS dissolved_oxygen, 21.81 AS temperature, 332 AS hardness, 1.262 AS free_chlorine, TRUE AS coliform_detected, 0 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 004' AS city, 'Gujarat' AS state, 'Tap Water' AS water_source, '2026-08-18' AS collection_date, 23.076513 AS latitude, 72.675561 AS longitude, 7.29 AS ph, 7.77 AS turbidity, 1176 AS tds, 4.59 AS dissolved_oxygen, 33.94 AS temperature, 387 AS hardness, 1.063 AS free_chlorine, FALSE AS coliform_detected, 37 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 005' AS city, 'Uttar Pradesh' AS state, 'Tap Water' AS water_source, '2026-07-28' AS collection_date, 25.240639 AS latitude, 82.900243 AS longitude, 7.30 AS ph, 4.81 AS turbidity, 920 AS tds, 7.74 AS dissolved_oxygen, 31.87 AS temperature, 375 AS hardness, 0.583 AS free_chlorine, FALSE AS coliform_detected, 72 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 006' AS city, 'Madhya Pradesh' AS state, 'Tap Water' AS water_source, '2026-10-05' AS collection_date, 23.284823 AS latitude, 77.413161 AS longitude, 7.10 AS ph, 5.53 AS turbidity, 1197 AS tds, 8.51 AS dissolved_oxygen, 21.15 AS temperature, 418 AS hardness, 1.470 AS free_chlorine, FALSE AS coliform_detected, 82 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 007' AS city, 'Jharkhand' AS state, 'Tap Water' AS water_source, '2026-09-30' AS collection_date, 23.304725 AS latitude, 85.295495 AS longitude, 6.51 AS ph, 4.50 AS turbidity, 436 AS tds, 9.69 AS dissolved_oxygen, 24.27 AS temperature, 205 AS hardness, 1.146 AS free_chlorine, FALSE AS coliform_detected, 83 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 008' AS city, 'Chhattisgarh' AS state, 'Well' AS water_source, '2026-08-17' AS collection_date, 21.167398 AS latitude, 81.514003 AS longitude, 7.69 AS ph, 3.44 AS turbidity, 199 AS tds, 9.71 AS dissolved_oxygen, 33.89 AS temperature, 214 AS hardness, 0.289 AS free_chlorine, FALSE AS coliform_detected, 0 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 009' AS city, 'Tamil Nadu' AS state, 'Well' AS water_source, '2026-08-17' AS collection_date, 11.057867 AS latitude, 77.087492 AS longitude, 6.67 AS ph, 3.22 AS turbidity, 420 AS tds, 6.01 AS dissolved_oxygen, 26.69 AS temperature, 310 AS hardness, 0.442 AS free_chlorine, FALSE AS coliform_detected, 78 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 010' AS city, 'Odisha' AS state, 'River' AS water_source, '2026-09-02' AS collection_date, 20.229222 AS latitude, 85.872041 AS longitude, 6.70 AS ph, 2.55 AS turbidity, 1067 AS tds, 8.68 AS dissolved_oxygen, 31.23 AS temperature, 345 AS hardness, 1.456 AS free_chlorine, FALSE AS coliform_detected, 45 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 011' AS city, 'Goa' AS state, 'Well' AS water_source, '2026-09-07' AS collection_date, 15.353961 AS latitude, 73.699429 AS longitude, 7.95 AS ph, 3.04 AS turbidity, 323 AS tds, 8.34 AS dissolved_oxygen, 25.37 AS temperature, 284 AS hardness, 0.948 AS free_chlorine, FALSE AS coliform_detected, 43 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 012' AS city, 'Assam' AS state, 'Tap Water' AS water_source, '2026-10-06' AS collection_date, 26.022781 AS latitude, 91.620803 AS longitude, 6.86 AS ph, 3.86 AS turbidity, 775 AS tds, 5.13 AS dissolved_oxygen, 22.39 AS temperature, 498 AS hardness, 0.189 AS free_chlorine, FALSE AS coliform_detected, 68 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 013' AS city, 'Bihar' AS state, 'Spring' AS water_source, '2026-08-11' AS collection_date, 25.600536 AS latitude, 85.255996 AS longitude, 7.82 AS ph, 6.32 AS turbidity, 1093 AS tds, 7.97 AS dissolved_oxygen, 21.24 AS temperature, 480 AS hardness, 0.543 AS free_chlorine, FALSE AS coliform_detected, 25 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 014' AS city, 'Delhi' AS state, 'Spring' AS water_source, '2026-09-25' AS collection_date, 28.587199 AS latitude, 77.204021 AS longitude, 7.72 AS ph, 6.76 AS turbidity, 1070 AS tds, 3.90 AS dissolved_oxygen, 20.99 AS temperature, 315 AS hardness, 0.917 AS free_chlorine, FALSE AS coliform_detected, 63 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 015' AS city, 'Chhattisgarh' AS state, 'Well' AS water_source, '2026-10-02' AS collection_date, 21.353487 AS latitude, 81.546970 AS longitude, 6.99 AS ph, 8.27 AS turbidity, 693 AS tds, 6.12 AS dissolved_oxygen, 18.36 AS temperature, 351 AS hardness, 1.066 AS free_chlorine, TRUE AS coliform_detected, 7 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 016' AS city, 'Tamil Nadu' AS state, 'Well' AS water_source, '2026-08-31' AS collection_date, 13.171354 AS latitude, 80.277150 AS longitude, 7.66 AS ph, 0.56 AS turbidity, 762 AS tds, 8.70 AS dissolved_oxygen, 35.60 AS temperature, 105 AS hardness, 0.423 AS free_chlorine, FALSE AS coliform_detected, 11 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 017' AS city, 'Uttar Pradesh' AS state, 'Spring' AS water_source, '2026-09-24' AS collection_date, 26.800914 AS latitude, 81.000672 AS longitude, 7.93 AS ph, 6.54 AS turbidity, 807 AS tds, 8.68 AS dissolved_oxygen, 27.72 AS temperature, 205 AS hardness, 0.491 AS free_chlorine, TRUE AS coliform_detected, 72 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 018' AS city, 'Himachal Pradesh' AS state, 'Borewell' AS water_source, '2026-08-25' AS collection_date, 30.997216 AS latitude, 77.273105 AS longitude, 7.13 AS ph, 7.46 AS turbidity, 287 AS tds, 5.03 AS dissolved_oxygen, 28.76 AS temperature, 93 AS hardness, 0.108 AS free_chlorine, FALSE AS coliform_detected, 44 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 019' AS city, 'Bihar' AS state, 'Borewell' AS water_source, '2026-09-03' AS collection_date, 25.512089 AS latitude, 85.062203 AS longitude, 7.79 AS ph, 7.18 AS turbidity, 1098 AS tds, 8.90 AS dissolved_oxygen, 29.85 AS temperature, 158 AS hardness, 0.567 AS free_chlorine, FALSE AS coliform_detected, 34 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 020' AS city, 'Uttar Pradesh' AS state, 'Tap Water' AS water_source, '2026-08-31' AS collection_date, 26.744131 AS latitude, 81.017064 AS longitude, 7.17 AS ph, 5.41 AS turbidity, 1055 AS tds, 5.06 AS dissolved_oxygen, 33.34 AS temperature, 150 AS hardness, 0.667 AS free_chlorine, FALSE AS coliform_detected, 31 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 021' AS city, 'Karnataka' AS state, 'Well' AS water_source, '2026-09-05' AS collection_date, 12.957382 AS latitude, 77.465896 AS longitude, 6.63 AS ph, 8.48 AS turbidity, 512 AS tds, 3.41 AS dissolved_oxygen, 24.27 AS temperature, 53 AS hardness, 0.665 AS free_chlorine, FALSE AS coliform_detected, 12 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 022' AS city, 'Tamil Nadu' AS state, 'Spring' AS water_source, '2026-09-12' AS collection_date, 11.111663 AS latitude, 76.871923 AS longitude, 6.97 AS ph, 1.19 AS turbidity, 1068 AS tds, 5.33 AS dissolved_oxygen, 25.25 AS temperature, 243 AS hardness, 0.342 AS free_chlorine, TRUE AS coliform_detected, 91 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 023' AS city, 'Telangana' AS state, 'Borewell' AS water_source, '2026-08-23' AS collection_date, 17.290063 AS latitude, 78.484906 AS longitude, 6.65 AS ph, 1.90 AS turbidity, 111 AS tds, 5.59 AS dissolved_oxygen, 28.09 AS temperature, 220 AS hardness, 1.416 AS free_chlorine, TRUE AS coliform_detected, 79 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 024' AS city, 'Mizoram' AS state, 'Well' AS water_source, '2026-08-06' AS collection_date, 23.659339 AS latitude, 92.832670 AS longitude, 7.36 AS ph, 6.06 AS turbidity, 705 AS tds, 3.63 AS dissolved_oxygen, 20.35 AS temperature, 171 AS hardness, 0.287 AS free_chlorine, FALSE AS coliform_detected, 42 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 025' AS city, 'Jammu and Kashmir' AS state, 'Tap Water' AS water_source, '2026-07-28' AS collection_date, 32.647706 AS latitude, 74.820054 AS longitude, 7.20 AS ph, 7.53 AS turbidity, 1095 AS tds, 7.24 AS dissolved_oxygen, 34.90 AS temperature, 335 AS hardness, 0.126 AS free_chlorine, FALSE AS coliform_detected, 22 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 026' AS city, 'Punjab' AS state, 'Spring' AS water_source, '2026-09-03' AS collection_date, 31.738100 AS latitude, 75.010264 AS longitude, 7.65 AS ph, 4.42 AS turbidity, 884 AS tds, 6.27 AS dissolved_oxygen, 21.82 AS temperature, 400 AS hardness, 1.464 AS free_chlorine, TRUE AS coliform_detected, 61 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 027' AS city, 'Odisha' AS state, 'Well' AS water_source, '2026-09-26' AS collection_date, 20.423732 AS latitude, 85.959160 AS longitude, 7.65 AS ph, 3.55 AS turbidity, 746 AS tds, 9.89 AS dissolved_oxygen, 21.36 AS temperature, 492 AS hardness, 0.818 AS free_chlorine, FALSE AS coliform_detected, 77 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 028' AS city, 'Bihar' AS state, 'Spring' AS water_source, '2026-09-11' AS collection_date, 25.567505 AS latitude, 85.070278 AS longitude, 7.15 AS ph, 7.81 AS turbidity, 355 AS tds, 7.79 AS dissolved_oxygen, 24.53 AS temperature, 86 AS hardness, 0.352 AS free_chlorine, TRUE AS coliform_detected, 34 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 029' AS city, 'Uttarakhand' AS state, 'Tap Water' AS water_source, '2026-08-24' AS collection_date, 30.434996 AS latitude, 78.115893 AS longitude, 6.87 AS ph, 2.87 AS turbidity, 300 AS tds, 3.42 AS dissolved_oxygen, 21.37 AS temperature, 199 AS hardness, 0.625 AS free_chlorine, FALSE AS coliform_detected, 40 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 030' AS city, 'Nagaland' AS state, 'Borewell' AS water_source, '2026-08-16' AS collection_date, 25.586496 AS latitude, 94.086903 AS longitude, 8.08 AS ph, 0.66 AS turbidity, 195 AS tds, 3.62 AS dissolved_oxygen, 35.85 AS temperature, 176 AS hardness, 0.151 AS free_chlorine, FALSE AS coliform_detected, 84 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 031' AS city, 'Goa' AS state, 'Well' AS water_source, '2026-10-09' AS collection_date, 15.354463 AS latitude, 73.795546 AS longitude, 7.08 AS ph, 4.51 AS turbidity, 534 AS tds, 9.67 AS dissolved_oxygen, 22.49 AS temperature, 89 AS hardness, 0.140 AS free_chlorine, TRUE AS coliform_detected, 63 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 032' AS city, 'Tripura' AS state, 'Tap Water' AS water_source, '2026-08-11' AS collection_date, 23.828353 AS latitude, 91.318060 AS longitude, 8.15 AS ph, 2.07 AS turbidity, 790 AS tds, 7.32 AS dissolved_oxygen, 22.41 AS temperature, 256 AS hardness, 0.487 AS free_chlorine, TRUE AS coliform_detected, 25 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 033' AS city, 'Arunachal Pradesh' AS state, 'Well' AS water_source, '2026-09-10' AS collection_date, 27.086278 AS latitude, 93.686679 AS longitude, 6.71 AS ph, 5.01 AS turbidity, 718 AS tds, 9.30 AS dissolved_oxygen, 19.33 AS temperature, 456 AS hardness, 0.198 AS free_chlorine, FALSE AS coliform_detected, 77 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 034' AS city, 'Chandigarh' AS state, 'Well' AS water_source, '2026-10-01' AS collection_date, 30.747773 AS latitude, 76.658329 AS longitude, 7.72 AS ph, 6.18 AS turbidity, 1040 AS tds, 3.61 AS dissolved_oxygen, 21.22 AS temperature, 410 AS hardness, 1.073 AS free_chlorine, TRUE AS coliform_detected, 85 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 035' AS city, 'Tamil Nadu' AS state, 'Well' AS water_source, '2026-09-02' AS collection_date, 13.177979 AS latitude, 80.342449 AS longitude, 7.66 AS ph, 1.21 AS turbidity, 375 AS tds, 6.04 AS dissolved_oxygen, 23.56 AS temperature, 305 AS hardness, 0.433 AS free_chlorine, TRUE AS coliform_detected, 22 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 036' AS city, 'Meghalaya' AS state, 'Tap Water' AS water_source, '2026-10-03' AS collection_date, 25.483288 AS latitude, 91.980730 AS longitude, 6.96 AS ph, 5.27 AS turbidity, 1013 AS tds, 7.91 AS dissolved_oxygen, 27.69 AS temperature, 119 AS hardness, 1.076 AS free_chlorine, TRUE AS coliform_detected, 83 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 037' AS city, 'Assam' AS state, 'Borewell' AS water_source, '2026-09-17' AS collection_date, 26.040054 AS latitude, 91.686645 AS longitude, 7.29 AS ph, 5.86 AS turbidity, 245 AS tds, 8.06 AS dissolved_oxygen, 32.49 AS temperature, 249 AS hardness, 0.360 AS free_chlorine, TRUE AS coliform_detected, 56 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 038' AS city, 'Nagaland' AS state, 'River' AS water_source, '2026-08-15' AS collection_date, 25.812345 AS latitude, 94.168173 AS longitude, 6.94 AS ph, 6.19 AS turbidity, 744 AS tds, 6.43 AS dissolved_oxygen, 33.95 AS temperature, 305 AS hardness, 0.386 AS free_chlorine, FALSE AS coliform_detected, 68 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 039' AS city, 'Tamil Nadu' AS state, 'Borewell' AS water_source, '2026-07-16' AS collection_date, 11.085079 AS latitude, 77.017965 AS longitude, 6.53 AS ph, 3.42 AS turbidity, 252 AS tds, 9.17 AS dissolved_oxygen, 34.60 AS temperature, 107 AS hardness, 1.046 AS free_chlorine, FALSE AS coliform_detected, 76 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 040' AS city, 'Punjab' AS state, 'River' AS water_source, '2026-07-26' AS collection_date, 31.536090 AS latitude, 74.811717 AS longitude, 7.90 AS ph, 8.30 AS turbidity, 238 AS tds, 6.96 AS dissolved_oxygen, 18.96 AS temperature, 332 AS hardness, 0.305 AS free_chlorine, FALSE AS coliform_detected, 35 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 041' AS city, 'Karnataka' AS state, 'Tap Water' AS water_source, '2026-07-23' AS collection_date, 12.978070 AS latitude, 77.635449 AS longitude, 6.84 AS ph, 7.29 AS turbidity, 210 AS tds, 5.05 AS dissolved_oxygen, 27.03 AS temperature, 166 AS hardness, 1.392 AS free_chlorine, FALSE AS coliform_detected, 86 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 042' AS city, 'Sikkim' AS state, 'Spring' AS water_source, '2026-10-11' AS collection_date, 27.346356 AS latitude, 88.494736 AS longitude, 7.53 AS ph, 1.47 AS turbidity, 544 AS tds, 5.77 AS dissolved_oxygen, 20.92 AS temperature, 314 AS hardness, 0.076 AS free_chlorine, TRUE AS coliform_detected, 96 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 043' AS city, 'Tripura' AS state, 'Well' AS water_source, '2026-09-29' AS collection_date, 23.788650 AS latitude, 91.220701 AS longitude, 7.98 AS ph, 6.09 AS turbidity, 524 AS tds, 4.71 AS dissolved_oxygen, 24.57 AS temperature, 336 AS hardness, 1.334 AS free_chlorine, FALSE AS coliform_detected, 88 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 044' AS city, 'Manipur' AS state, 'Spring' AS water_source, '2026-07-20' AS collection_date, 24.941705 AS latitude, 93.973950 AS longitude, 7.03 AS ph, 4.38 AS turbidity, 496 AS tds, 6.49 AS dissolved_oxygen, 30.43 AS temperature, 340 AS hardness, 1.049 AS free_chlorine, TRUE AS coliform_detected, 59 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 045' AS city, 'Uttarakhand' AS state, 'Well' AS water_source, '2026-07-26' AS collection_date, 30.230483 AS latitude, 78.057323 AS longitude, 7.30 AS ph, 4.13 AS turbidity, 373 AS tds, 5.88 AS dissolved_oxygen, 25.99 AS temperature, 90 AS hardness, 0.721 AS free_chlorine, TRUE AS coliform_detected, 66 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 046' AS city, 'Uttar Pradesh' AS state, 'Spring' AS water_source, '2026-09-09' AS collection_date, 25.247426 AS latitude, 83.084917 AS longitude, 6.50 AS ph, 5.57 AS turbidity, 534 AS tds, 4.64 AS dissolved_oxygen, 23.77 AS temperature, 448 AS hardness, 0.638 AS free_chlorine, FALSE AS coliform_detected, 44 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 047' AS city, 'Odisha' AS state, 'Tap Water' AS water_source, '2026-09-28' AS collection_date, 20.415183 AS latitude, 85.701478 AS longitude, 6.59 AS ph, 3.60 AS turbidity, 1077 AS tds, 9.99 AS dissolved_oxygen, 34.33 AS temperature, 385 AS hardness, 0.958 AS free_chlorine, TRUE AS coliform_detected, 13 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 048' AS city, 'Assam' AS state, 'Borewell' AS water_source, '2026-10-03' AS collection_date, 26.214034 AS latitude, 91.686032 AS longitude, 6.81 AS ph, 7.56 AS turbidity, 1068 AS tds, 7.33 AS dissolved_oxygen, 27.97 AS temperature, 352 AS hardness, 0.607 AS free_chlorine, TRUE AS coliform_detected, 50 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 049' AS city, 'Tamil Nadu' AS state, 'Well' AS water_source, '2026-09-03' AS collection_date, 13.049825 AS latitude, 80.253527 AS longitude, 7.66 AS ph, 1.76 AS turbidity, 588 AS tds, 7.11 AS dissolved_oxygen, 33.91 AS temperature, 339 AS hardness, 0.390 AS free_chlorine, FALSE AS coliform_detected, 16 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 050' AS city, 'Maharashtra' AS state, 'River' AS water_source, '2026-07-23' AS collection_date, 18.577485 AS latitude, 73.879743 AS longitude, 7.03 AS ph, 8.48 AS turbidity, 727 AS tds, 5.33 AS dissolved_oxygen, 23.89 AS temperature, 306 AS hardness, 0.611 AS free_chlorine, FALSE AS coliform_detected, 35 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 051' AS city, 'Tripura' AS state, 'Borewell' AS water_source, '2026-08-06' AS collection_date, 23.846392 AS latitude, 91.256536 AS longitude, 6.95 AS ph, 6.57 AS turbidity, 550 AS tds, 9.78 AS dissolved_oxygen, 29.82 AS temperature, 427 AS hardness, 0.284 AS free_chlorine, FALSE AS coliform_detected, 75 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 052' AS city, 'Nagaland' AS state, 'Borewell' AS water_source, '2026-08-01' AS collection_date, 25.751026 AS latitude, 94.081020 AS longitude, 7.11 AS ph, 5.57 AS turbidity, 129 AS tds, 5.40 AS dissolved_oxygen, 20.07 AS temperature, 83 AS hardness, 0.770 AS free_chlorine, TRUE AS coliform_detected, 80 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 053' AS city, 'Madhya Pradesh' AS state, 'Tap Water' AS water_source, '2026-10-04' AS collection_date, 23.369269 AS latitude, 77.375106 AS longitude, 6.80 AS ph, 4.13 AS turbidity, 336 AS tds, 6.73 AS dissolved_oxygen, 25.52 AS temperature, 251 AS hardness, 1.131 AS free_chlorine, TRUE AS coliform_detected, 51 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 054' AS city, 'Jammu and Kashmir' AS state, 'Spring' AS water_source, '2026-09-28' AS collection_date, 32.748720 AS latitude, 74.856294 AS longitude, 7.31 AS ph, 2.80 AS turbidity, 539 AS tds, 8.61 AS dissolved_oxygen, 22.51 AS temperature, 358 AS hardness, 1.444 AS free_chlorine, FALSE AS coliform_detected, 59 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 055' AS city, 'Nagaland' AS state, 'Spring' AS water_source, '2026-10-07' AS collection_date, 25.552226 AS latitude, 94.139535 AS longitude, 7.02 AS ph, 5.18 AS turbidity, 1129 AS tds, 9.91 AS dissolved_oxygen, 35.33 AS temperature, 177 AS hardness, 0.871 AS free_chlorine, FALSE AS coliform_detected, 65 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 056' AS city, 'Maharashtra' AS state, 'Borewell' AS water_source, '2026-09-02' AS collection_date, 19.171264 AS latitude, 72.818899 AS longitude, 8.17 AS ph, 7.27 AS turbidity, 320 AS tds, 4.21 AS dissolved_oxygen, 26.10 AS temperature, 116 AS hardness, 0.748 AS free_chlorine, FALSE AS coliform_detected, 23 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 057' AS city, 'Tripura' AS state, 'River' AS water_source, '2026-09-27' AS collection_date, 23.882394 AS latitude, 91.267937 AS longitude, 7.20 AS ph, 4.32 AS turbidity, 530 AS tds, 6.28 AS dissolved_oxygen, 34.58 AS temperature, 56 AS hardness, 1.022 AS free_chlorine, TRUE AS coliform_detected, 70 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 058' AS city, 'Uttar Pradesh' AS state, 'Spring' AS water_source, '2026-07-22' AS collection_date, 25.377613 AS latitude, 83.088433 AS longitude, 6.67 AS ph, 8.40 AS turbidity, 1089 AS tds, 8.04 AS dissolved_oxygen, 32.00 AS temperature, 450 AS hardness, 1.219 AS free_chlorine, FALSE AS coliform_detected, 71 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 059' AS city, 'Delhi' AS state, 'Tap Water' AS water_source, '2026-08-15' AS collection_date, 28.701985 AS latitude, 77.109958 AS longitude, 7.85 AS ph, 6.93 AS turbidity, 206 AS tds, 5.39 AS dissolved_oxygen, 24.92 AS temperature, 54 AS hardness, 0.053 AS free_chlorine, FALSE AS coliform_detected, 89 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 060' AS city, 'Maharashtra' AS state, 'Borewell' AS water_source, '2026-09-12' AS collection_date, 19.018361 AS latitude, 72.925567 AS longitude, 6.97 AS ph, 0.60 AS turbidity, 628 AS tds, 8.62 AS dissolved_oxygen, 27.57 AS temperature, 477 AS hardness, 1.428 AS free_chlorine, TRUE AS coliform_detected, 75 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 061' AS city, 'Assam' AS state, 'River' AS water_source, '2026-08-13' AS collection_date, 26.092851 AS latitude, 91.637288 AS longitude, 7.82 AS ph, 1.59 AS turbidity, 987 AS tds, 4.60 AS dissolved_oxygen, 18.86 AS temperature, 188 AS hardness, 0.242 AS free_chlorine, FALSE AS coliform_detected, 90 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 062' AS city, 'Goa' AS state, 'River' AS water_source, '2026-08-17' AS collection_date, 15.468079 AS latitude, 73.729934 AS longitude, 6.52 AS ph, 7.61 AS turbidity, 419 AS tds, 7.54 AS dissolved_oxygen, 32.18 AS temperature, 480 AS hardness, 1.201 AS free_chlorine, FALSE AS coliform_detected, 73 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 063' AS city, 'Telangana' AS state, 'Well' AS water_source, '2026-09-07' AS collection_date, 17.324337 AS latitude, 78.388219 AS longitude, 7.34 AS ph, 4.97 AS turbidity, 813 AS tds, 3.40 AS dissolved_oxygen, 21.90 AS temperature, 218 AS hardness, 0.614 AS free_chlorine, FALSE AS coliform_detected, 31 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 064' AS city, 'Chandigarh' AS state, 'Well' AS water_source, '2026-10-03' AS collection_date, 30.655648 AS latitude, 76.742508 AS longitude, 7.19 AS ph, 4.95 AS turbidity, 993 AS tds, 6.63 AS dissolved_oxygen, 28.56 AS temperature, 476 AS hardness, 1.481 AS free_chlorine, FALSE AS coliform_detected, 50 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 065' AS city, 'Tripura' AS state, 'River' AS water_source, '2026-07-16' AS collection_date, 23.743629 AS latitude, 91.311364 AS longitude, 8.06 AS ph, 4.92 AS turbidity, 163 AS tds, 4.40 AS dissolved_oxygen, 23.23 AS temperature, 293 AS hardness, 1.424 AS free_chlorine, FALSE AS coliform_detected, 5 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 066' AS city, 'Nagaland' AS state, 'Spring' AS water_source, '2026-09-04' AS collection_date, 25.562710 AS latitude, 94.200411 AS longitude, 8.16 AS ph, 6.88 AS turbidity, 331 AS tds, 6.10 AS dissolved_oxygen, 35.88 AS temperature, 80 AS hardness, 1.252 AS free_chlorine, FALSE AS coliform_detected, 73 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 067' AS city, 'Delhi' AS state, 'Well' AS water_source, '2026-08-12' AS collection_date, 28.600635 AS latitude, 77.233858 AS longitude, 6.83 AS ph, 4.86 AS turbidity, 120 AS tds, 9.81 AS dissolved_oxygen, 28.55 AS temperature, 215 AS hardness, 1.064 AS free_chlorine, FALSE AS coliform_detected, 58 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 068' AS city, 'Karnataka' AS state, 'Spring' AS water_source, '2026-08-04' AS collection_date, 13.110664 AS latitude, 77.553270 AS longitude, 7.24 AS ph, 2.12 AS turbidity, 932 AS tds, 9.56 AS dissolved_oxygen, 27.34 AS temperature, 262 AS hardness, 0.313 AS free_chlorine, FALSE AS coliform_detected, 52 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 069' AS city, 'Manipur' AS state, 'Spring' AS water_source, '2026-08-06' AS collection_date, 24.838121 AS latitude, 93.822370 AS longitude, 7.60 AS ph, 7.05 AS turbidity, 467 AS tds, 3.39 AS dissolved_oxygen, 28.86 AS temperature, 169 AS hardness, 1.090 AS free_chlorine, TRUE AS coliform_detected, 76 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 070' AS city, 'Uttar Pradesh' AS state, 'Spring' AS water_source, '2026-08-14' AS collection_date, 25.236617 AS latitude, 82.850343 AS longitude, 7.17 AS ph, 0.95 AS turbidity, 650 AS tds, 5.73 AS dissolved_oxygen, 29.49 AS temperature, 468 AS hardness, 0.568 AS free_chlorine, FALSE AS coliform_detected, 30 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 071' AS city, 'Himachal Pradesh' AS state, 'Tap Water' AS water_source, '2026-08-31' AS collection_date, 30.971728 AS latitude, 77.034852 AS longitude, 6.70 AS ph, 5.92 AS turbidity, 1103 AS tds, 7.46 AS dissolved_oxygen, 19.83 AS temperature, 102 AS hardness, 0.998 AS free_chlorine, TRUE AS coliform_detected, 47 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 072' AS city, 'Jharkhand' AS state, 'Tap Water' AS water_source, '2026-09-11' AS collection_date, 23.237448 AS latitude, 85.388147 AS longitude, 7.06 AS ph, 1.73 AS turbidity, 975 AS tds, 3.21 AS dissolved_oxygen, 24.97 AS temperature, 496 AS hardness, 0.360 AS free_chlorine, FALSE AS coliform_detected, 41 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 073' AS city, 'Goa' AS state, 'Well' AS water_source, '2026-07-30' AS collection_date, 15.495889 AS latitude, 73.827154 AS longitude, 7.18 AS ph, 1.05 AS turbidity, 436 AS tds, 5.16 AS dissolved_oxygen, 28.56 AS temperature, 404 AS hardness, 0.695 AS free_chlorine, FALSE AS coliform_detected, 54 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 074' AS city, 'Odisha' AS state, 'Borewell' AS water_source, '2026-10-11' AS collection_date, 20.296566 AS latitude, 85.921907 AS longitude, 6.70 AS ph, 7.54 AS turbidity, 690 AS tds, 7.51 AS dissolved_oxygen, 22.80 AS temperature, 367 AS hardness, 0.778 AS free_chlorine, FALSE AS coliform_detected, 77 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 075' AS city, 'Madhya Pradesh' AS state, 'River' AS water_source, '2026-08-27' AS collection_date, 23.243681 AS latitude, 77.489413 AS longitude, 8.12 AS ph, 0.97 AS turbidity, 1181 AS tds, 3.19 AS dissolved_oxygen, 19.34 AS temperature, 365 AS hardness, 0.556 AS free_chlorine, FALSE AS coliform_detected, 52 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 076' AS city, 'Uttar Pradesh' AS state, 'Tap Water' AS water_source, '2026-07-21' AS collection_date, 26.815129 AS latitude, 80.835254 AS longitude, 6.62 AS ph, 1.12 AS turbidity, 332 AS tds, 6.37 AS dissolved_oxygen, 35.18 AS temperature, 142 AS hardness, 1.221 AS free_chlorine, FALSE AS coliform_detected, 64 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 077' AS city, 'Karnataka' AS state, 'Well' AS water_source, '2026-09-20' AS collection_date, 12.965529 AS latitude, 77.723966 AS longitude, 6.96 AS ph, 7.33 AS turbidity, 182 AS tds, 7.76 AS dissolved_oxygen, 22.26 AS temperature, 454 AS hardness, 1.251 AS free_chlorine, TRUE AS coliform_detected, 35 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 078' AS city, 'Manipur' AS state, 'Well' AS water_source, '2026-09-19' AS collection_date, 24.842520 AS latitude, 93.916200 AS longitude, 7.01 AS ph, 4.50 AS turbidity, 258 AS tds, 9.94 AS dissolved_oxygen, 27.76 AS temperature, 386 AS hardness, 0.874 AS free_chlorine, FALSE AS coliform_detected, 25 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 079' AS city, 'Uttarakhand' AS state, 'River' AS water_source, '2026-08-14' AS collection_date, 30.378389 AS latitude, 78.159392 AS longitude, 7.18 AS ph, 2.67 AS turbidity, 723 AS tds, 3.40 AS dissolved_oxygen, 23.29 AS temperature, 176 AS hardness, 1.477 AS free_chlorine, FALSE AS coliform_detected, 96 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 080' AS city, 'Jharkhand' AS state, 'Well' AS water_source, '2026-08-29' AS collection_date, 23.306917 AS latitude, 85.236005 AS longitude, 7.78 AS ph, 7.81 AS turbidity, 670 AS tds, 5.44 AS dissolved_oxygen, 23.25 AS temperature, 464 AS hardness, 0.647 AS free_chlorine, FALSE AS coliform_detected, 84 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 081' AS city, 'Jharkhand' AS state, 'Borewell' AS water_source, '2026-09-19' AS collection_date, 23.440037 AS latitude, 85.261312 AS longitude, 7.56 AS ph, 7.24 AS turbidity, 308 AS tds, 4.90 AS dissolved_oxygen, 22.59 AS temperature, 455 AS hardness, 1.054 AS free_chlorine, FALSE AS coliform_detected, 41 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 082' AS city, 'Punjab' AS state, 'Tap Water' AS water_source, '2026-09-06' AS collection_date, 31.730883 AS latitude, 74.936072 AS longitude, 7.03 AS ph, 1.50 AS turbidity, 163 AS tds, 9.37 AS dissolved_oxygen, 20.56 AS temperature, 122 AS hardness, 0.489 AS free_chlorine, FALSE AS coliform_detected, 53 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 083' AS city, 'Maharashtra' AS state, 'River' AS water_source, '2026-10-02' AS collection_date, 18.407990 AS latitude, 73.909484 AS longitude, 6.98 AS ph, 8.28 AS turbidity, 620 AS tds, 9.45 AS dissolved_oxygen, 24.71 AS temperature, 296 AS hardness, 0.740 AS free_chlorine, TRUE AS coliform_detected, 99 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 084' AS city, 'Maharashtra' AS state, 'River' AS water_source, '2026-10-04' AS collection_date, 18.431094 AS latitude, 73.938492 AS longitude, 7.86 AS ph, 4.42 AS turbidity, 607 AS tds, 3.25 AS dissolved_oxygen, 26.12 AS temperature, 402 AS hardness, 0.858 AS free_chlorine, FALSE AS coliform_detected, 78 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 085' AS city, 'Gujarat' AS state, 'Tap Water' AS water_source, '2026-09-05' AS collection_date, 23.137176 AS latitude, 72.514002 AS longitude, 6.84 AS ph, 7.05 AS turbidity, 888 AS tds, 6.92 AS dissolved_oxygen, 34.59 AS temperature, 485 AS hardness, 0.998 AS free_chlorine, FALSE AS coliform_detected, 44 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 086' AS city, 'Mizoram' AS state, 'Spring' AS water_source, '2026-08-22' AS collection_date, 23.748038 AS latitude, 92.828555 AS longitude, 7.75 AS ph, 6.17 AS turbidity, 1150 AS tds, 9.68 AS dissolved_oxygen, 30.72 AS temperature, 121 AS hardness, 1.022 AS free_chlorine, FALSE AS coliform_detected, 71 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 087' AS city, 'Odisha' AS state, 'Tap Water' AS water_source, '2026-07-26' AS collection_date, 20.293588 AS latitude, 85.732931 AS longitude, 6.91 AS ph, 7.00 AS turbidity, 1028 AS tds, 4.66 AS dissolved_oxygen, 29.70 AS temperature, 264 AS hardness, 0.805 AS free_chlorine, FALSE AS coliform_detected, 32 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 088' AS city, 'Uttar Pradesh' AS state, 'Spring' AS water_source, '2026-08-01' AS collection_date, 25.347403 AS latitude, 82.937866 AS longitude, 6.90 AS ph, 8.04 AS turbidity, 734 AS tds, 7.05 AS dissolved_oxygen, 21.51 AS temperature, 399 AS hardness, 0.719 AS free_chlorine, TRUE AS coliform_detected, 21 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 089' AS city, 'Sikkim' AS state, 'Borewell' AS water_source, '2026-08-03' AS collection_date, 27.355141 AS latitude, 88.676807 AS longitude, 8.02 AS ph, 0.55 AS turbidity, 525 AS tds, 4.39 AS dissolved_oxygen, 27.55 AS temperature, 409 AS hardness, 0.991 AS free_chlorine, FALSE AS coliform_detected, 3 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 090' AS city, 'Karnataka' AS state, 'Well' AS water_source, '2026-09-10' AS collection_date, 12.980986 AS latitude, 77.696384 AS longitude, 7.17 AS ph, 4.83 AS turbidity, 148 AS tds, 6.16 AS dissolved_oxygen, 33.34 AS temperature, 161 AS hardness, 0.102 AS free_chlorine, TRUE AS coliform_detected, 75 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 091' AS city, 'Meghalaya' AS state, 'Spring' AS water_source, '2026-09-29' AS collection_date, 25.653259 AS latitude, 91.805121 AS longitude, 8.20 AS ph, 5.73 AS turbidity, 185 AS tds, 3.03 AS dissolved_oxygen, 29.80 AS temperature, 226 AS hardness, 0.450 AS free_chlorine, FALSE AS coliform_detected, 7 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 092' AS city, 'Arunachal Pradesh' AS state, 'River' AS water_source, '2026-10-12' AS collection_date, 27.081240 AS latitude, 93.724608 AS longitude, 8.19 AS ph, 8.21 AS turbidity, 448 AS tds, 4.75 AS dissolved_oxygen, 32.29 AS temperature, 309 AS hardness, 0.748 AS free_chlorine, FALSE AS coliform_detected, 49 AS risk_score, 'Moderate' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 093' AS city, 'Manipur' AS state, 'Well' AS water_source, '2026-09-29' AS collection_date, 24.696921 AS latitude, 93.843912 AS longitude, 8.16 AS ph, 6.09 AS turbidity, 968 AS tds, 7.45 AS dissolved_oxygen, 25.02 AS temperature, 318 AS hardness, 0.956 AS free_chlorine, FALSE AS coliform_detected, 53 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 094' AS city, 'Odisha' AS state, 'River' AS water_source, '2026-08-05' AS collection_date, 20.364490 AS latitude, 85.960834 AS longitude, 7.30 AS ph, 5.60 AS turbidity, 343 AS tds, 6.52 AS dissolved_oxygen, 22.47 AS temperature, 145 AS hardness, 0.399 AS free_chlorine, FALSE AS coliform_detected, 72 AS risk_score, 'High' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 095' AS city, 'Kerala' AS state, 'Well' AS water_source, '2026-07-22' AS collection_date, 8.615276 AS latitude, 76.845798 AS longitude, 6.73 AS ph, 1.37 AS turbidity, 984 AS tds, 5.64 AS dissolved_oxygen, 20.60 AS temperature, 208 AS hardness, 0.690 AS free_chlorine, FALSE AS coliform_detected, 96 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 096' AS city, 'Assam' AS state, 'Spring' AS water_source, '2026-09-02' AS collection_date, 26.134843 AS latitude, 91.645615 AS longitude, 7.07 AS ph, 7.32 AS turbidity, 905 AS tds, 6.26 AS dissolved_oxygen, 33.89 AS temperature, 359 AS hardness, 1.475 AS free_chlorine, TRUE AS coliform_detected, 8 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 097' AS city, 'Jammu and Kashmir' AS state, 'Borewell' AS water_source, '2026-09-12' AS collection_date, 32.861072 AS latitude, 74.965768 AS longitude, 8.16 AS ph, 2.10 AS turbidity, 805 AS tds, 6.73 AS dissolved_oxygen, 24.80 AS temperature, 209 AS hardness, 0.432 AS free_chlorine, FALSE AS coliform_detected, 6 AS risk_score, 'Safe' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 098' AS city, 'Rajasthan' AS state, 'Tap Water' AS water_source, '2026-08-12' AS collection_date, 26.947613 AS latitude, 75.857541 AS longitude, 7.65 AS ph, 8.11 AS turbidity, 965 AS tds, 5.12 AS dissolved_oxygen, 31.60 AS temperature, 462 AS hardness, 1.274 AS free_chlorine, FALSE AS coliform_detected, 93 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 099' AS city, 'Assam' AS state, 'Spring' AS water_source, '2026-09-02' AS collection_date, 26.145615 AS latitude, 91.854758 AS longitude, 7.36 AS ph, 3.66 AS turbidity, 1130 AS tds, 4.74 AS dissolved_oxygen, 30.30 AS temperature, 430 AS hardness, 0.304 AS free_chlorine, FALSE AS coliform_detected, 80 AS risk_score, 'Critical' AS risk_level
    UNION ALL
    SELECT 'WQ Demo Site 100' AS city, 'Bihar' AS state, 'Tap Water' AS water_source, '2026-08-06' AS collection_date, 25.455186 AS latitude, 85.023772 AS longitude, 6.95 AS ph, 3.53 AS turbidity, 895 AS tds, 3.10 AS dissolved_oxygen, 24.83 AS temperature, 230 AS hardness, 1.141 AS free_chlorine, TRUE AS coliform_detected, 80 AS risk_score, 'Critical' AS risk_level
) AS seed
WHERE NOT EXISTS (
    SELECT 1 FROM water_samples existing
    WHERE existing.is_demo = TRUE AND existing.city = seed.city AND existing.state = seed.state
);
