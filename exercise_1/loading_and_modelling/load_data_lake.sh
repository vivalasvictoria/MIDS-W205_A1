cd /data
mkdir /data/ex1files
mkdir /data/ex1final
cd /data/ex1files
wget https://s3.amazonaws.com/exercise1vb/Hospital+General+Information.csv
tail -n +2 /data/ex1files/Hospital+General+Information.csv > /data/ex1final/hospital.csv
wget https://s3.amazonaws.com/exercise1vb/Timely+and+Effective+Care+-+Hospital.csv
tail -n +2 /data/ex1files/Timely+and+Effective+Care+-+Hospital.csv > /data/ex1final/effective_care.csv
wget https://s3.amazonaws.com/exercise1vb/Readmissions+and+Deaths+-+Hospital.csv
tail -n +2 /data/ex1files/Readmissions+and+Deaths+-+Hospital.csv > /data/ex1final/readmissions.csv
wget https://s3.amazonaws.com/exercise1vb/Measure+Dates.csv
tail -n +2 /data/ex1files/Measure+Dates.csv > /data/ex1final/measures.csv
wget https://s3.amazonaws.com/exercise1vb/hvbp_hcahps_05_28_2015.csv
tail -n +2 /data/ex1files/hvbp_hcahps_05_28_2015.csv > /data/ex1final/responses.csv
cd /
su - w205
hdfs dfs -mkdir /user/w205/hospital_compare
hdfs dfs -put /data/ex1final/effective_care.csv /user/w205/hospital_compare
hdfs dfs -put /data/ex1final/hospital.csv /user/w205/hospital_compare
hdfs dfs -put /data/ex1final/measures.csv /user/w205/hospital_compare
hdfs dfs -put /data/ex1final/readmissions.csv /user/w205/hospital_compare
hdfs dfs -put /data/ex1final/responses.csv /user/w205/hospital_compare
