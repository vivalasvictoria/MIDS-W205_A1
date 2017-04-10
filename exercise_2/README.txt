Exercise 2

Twitter Application:
To run the Twitter application, navigate to the extweetcount folder of this repository and run the following command to start the topology:

sparse run

It will continue to run until it is manually exited using CTRL-C. All of the words processed in the stream will be in the tweetwordcount table in the tcount database. 

Final Results:
To run the finalresults.py file, navigate to the exercise_2 directory of this repository and call the following command along with whatever parameters (either a single string or no argument) you wish to search:

python finalresults.py hello

or

python finalresults.py


Histogram:
To run the histogram.py file, navigate to the exercise_2 directory of this repository and call the following command along with whatever parameters (a single string with two numbers separated by a comma) you wish to search:

python histogram.py 2,3

or

python histogram.py 9,10

Histogram Bar Chart:
To run the histogram_chart.py file, navigate to the exercise_2 directory of this repository and call the following command:

python histogram_chart.py
