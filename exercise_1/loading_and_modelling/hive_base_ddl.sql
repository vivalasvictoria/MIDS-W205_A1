DROP TABLE IF EXISTS effective_care;
DROP TABLE IF EXISTS hospital;
DROP TABLE IF EXISTS measures;
DROP TABLE IF EXISTS readmissions;
DROP TABLE IF EXISTS responses;

CREATE EXTERNAL TABLE IF NOT EXISTS effective_care                                                                        
     (providerId string,                                                                                                                
     hospitalName string,                                                                                                            
     address string,                                                                                                                 
     city string,                                                                                                                    
     state string,                                                                                                                   
     zipcode int,                                                                                                                    
     countyName string,                                                                                                              
     phoneNumber string,                                                                                                             
     condition string,                                                                                                               
     measureId string,                                                                                                               
     measureName string,                                                                                                             
     score string,
     sample string,
     footnote string,
     measureStartDate date,
     measureEndDate date)                                                                                                            
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/effective_care';


CREATE EXTERNAL TABLE IF NOT EXISTS hospital
     (providerId string,
     hospitalName string,                                                                                                            
     address string,
     city string,
     state string,
     zipcode int,                                                                                                                    
     countyName string,
     phoneNumber string,                                                                                                             
     hospitalType string,
     hospitalOwnership string,
     emergencyServices string)
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/hospital';      
	
CREATE EXTERNAL TABLE IF NOT EXISTS measures                                                                               
     (measureNames string,                                                                                                           
     measureId string,
     measureStartQuarter string,
     measureStartDate date,
     measureEndQuarter string,
     measureEndDate date)
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/measures';

CREATE EXTERNAL TABLE IF NOT EXISTS readmissions                                                                          
     (providerId string,
     hospitalName string,
     address string,
     city string,
     state string,
     zipcode int,
     countyName string,
     phoneNumber string,                                                                                                             
     measureName string,
     measureId string,
     comparedToNational string,
     denominator string,
     score string,
     lowerEstimate string,
     higherEstimate string,
     footnote string,
     measureStartDate date,
     measureEndDate date)
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/readmissions';

CREATE EXTERNAL TABLE IF NOT EXISTS responses
     (providerNumber string,
     hospitalName string,
     address string,                                                                                                                 
     city string,
     state string,
     zipcode int,
     countyName string,
     commNursesAchievement string,                                                                                                   
     commNursesImprovement string,
     commNursesDimension string,
     commDoctorsAchievement string,                                                                                                  
     commDoctorsImprovement string,                                                                                                  
     commDoctorsDimension string,
     ResponsivenessStaffAchievement string,
     responsivenessStaffImprovement string,                                                                                          
     responsivenessStaffDimension string,
     painAchievement string,                                                                                                         
     painImprovement string,
     painDimension string,
     commMedicinesAchievement string,
     commMedicinesImprovement string,
     commMedicinesDimension string,
     quietnessAchievement string,
     quietnessImprovement string,
     quietnessDimension string,
     dischargeAchievement string,
     dischargeImprovement string,
     dischargeDimension string,
     overallRatingAchievement string,
     overallRatingImprovement string,                                                                                                
     overallRatingDimension string,                                                                                                  
     hcahpsBaseScore string,
     hcahpsConsistencyScore string)                                                                                                  
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/responses';
	 
	 CREATE EXTERNAL TABLE IF NOT EXISTS readmissionsNat                                                                        
     (measureName string,                                                                                                                
     measureId int,                                                                                                            
     nationalRate float,                                                                                                                 
     worseNum int,                                                                                                                    
     sameNum int,                                                                                                                   
     betterNum int,                                                                                                                    
     fewNum int,                                                                                                              
     footnote string,                                                                                                             
     measureStartDate date,                                                                                                               
     measureEndDate date)                                                                                                            
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/readmissionsNat';
	 
	 CREATE EXTERNAL TABLE IF NOT EXISTS effective_careNat                                                                        
     (category string,
	 condition string,
	 footnote string,
     measureId string,                                                                                                               
     measureName string,                                                                                                             
     nationalScore int,
     measureStartDate date,
     measureEndDate date)                                                                                                            
     ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'                                                                   
     WITH SERDEPROPERTIES(
     "separatorChar"=",",
     "quoteChar"="'",
     "escapeChar"="\\")
     STORED AS TEXTFILE                                                                                                              
     LOCATION '/user/w205/hospital_compare/effective_careNat';
	    