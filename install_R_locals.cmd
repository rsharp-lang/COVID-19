@echo off

REM you should run this script at first!

CD App

R# install.packages('COVID-19.dll');
R# install.packages('R.base.dll');
R# install.packages('R.graphics.dll');
R# install.packages('R.math.dll');
R# install.packages('R.plot.dll');

CD ..

pause