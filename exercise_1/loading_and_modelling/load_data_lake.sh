#Victoria Baker
#The following code loads the csv files from an amazon S3 share into 
#new directories, strips the header row from eac, and then moves them into
#new directories in hdfs

#ex1files is the directory for the original csv files
#if directory already exists, remove it
rm -rf /data/ex1files
mkdir /data/ex1files
#ex1final is the directory for the csv files that have had their header rows stripped
rm -rf /data/ex1final
mkdir /data/ex1final

#change to first directory
cd /data/ex1files

#load original csv file, remove header row, and move to final directory
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
wget https://s3.amazonaws.com/exercise1vb/Readmissions+and+Deaths+-+National.csv
tail -n +2 /data/ex1files/Readmissions+and+Deaths+-+National.csv > /data/ex1final/readmissionsNat.csv
wget https://s3.amazonaws.com/exercise1vb/Timely+and+Effective+Care+-+National.csv
tail -n +2 /data/ex1files/Timely+and+Effective+Care+-+National.csv > /data/ex1final/effective_careNat.csv

#since we are using root user in this script, it needs access to the 
#folder that we are loading the files into in hdfs
cd /
hdfs dfs -chmod a+rwx /user/root

#make directories in hdfs for the files
hdfs dfs -mkdir /user/root/hospital_compare
hdfs dfs -mkdir /user/root/hospital_compare/effective_care
hdfs dfs -mkdir /user/root/hospital_compare/hospital
hdfs dfs -mkdir /user/root/hospital_compare/measures
hdfs dfs -mkdir /user/root/hospital_compare/readmissions
hdfs dfs -mkdir /user/root/hospital_compare/responses
hdfs dfs -mkdir /user/root/hospital_compare/readmissionsNat
hdfs dfs -mkdir /user/root/hospital_compare/effective_careNat

#move csv files to new directory in hdfs
hdfs dfs -put /data/ex1final/effective_care.csv /user/root/hospital_compare/effective_care
hdfs dfs -put /data/ex1final/hospital.csv /user/root/hospital_compare/hospital
hdfs dfs -put /data/ex1final/measures.csv /user/root/hospital_compare/measures
hdfs dfs -put /data/ex1final/readmissions.csv /user/root/hospital_compare/readmissions
hdfs dfs -put /data/ex1final/responses.csv /user/root/hospital_compare/responses
hdfs dfs -put /data/ex1final/readmissionsNat.csv /user/root/hospital_compare/readmissionsNat
hdfs dfs -put /data/ex1final/effective_careNat.csv /user/root/hospital_compare/effective_careNat
