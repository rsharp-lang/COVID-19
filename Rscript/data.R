# Data formatter of the test data
# https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv

require(dataframe);

setwd(!script$dir);

let raw = read.csv("../data/DXYArea.csv", encoding = "utf8");

print("Peeks of the raw data table:");
print(colnames(raw));

let prov = raw :> as.list(byrow = TRUE);

str(prov);