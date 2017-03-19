
-- load data in with the name and data type of each column specifically defined

wavetronix_5min = LOAD 'data_CE650C/wavetronix_sample/CSV/20161231.csv' USING PigStorage(',') AS (sensor:chararray, date:chararray, hour:int, minute5:int, speed:float, count:int, occup:float);

SensorList = LOAD 'Skylar_Exp0/SensorList.csv' USING PigStorage(',') AS (coded_direction:chararray,sensorIWZ:chararray,IWZ:chararray,Blank:chararray);

-- clean data

matchtable = FILTER SensorList by IWZ == '1t' and coded_direction=='1';

targetgroup = FOREACH matchtable GENERATE sensorIWZ, IWZ;

wavetronix = FOREACH wavetronix_5min GENERATE date, sensor, hour, minute5, speed, count, occup;


-- join data

firstjoin = JOIN wavetronix BY sensor, targetgroup BY sensorIWZ;


data = FOREACH firstjoin GENERATE wavetronix::date, wavetronix::hour, wavetronix::minute5, wavetronix::sensor, wavetronix::speed, wavetronix::count, wavetronix::occup;

-- output results

STORE data INTO 'Skylar_Exp0/Assignment';
