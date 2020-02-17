# Data formatter of the test data
# https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv

require(dataframe);

setwd(!script$dir);

let raw = read.csv("../data/DXYArea.csv", encoding = "utf8");

raw[, "updateTime"] <- as.Date(raw[, "updateTime"]);

print("Peeks of the raw data table:");
print("All of the data fields:");
print(colnames(raw));
print("Number of data records:");
print(nrow(raw));

let province = raw :> as.list(byrow = TRUE) :> groupBy(prov -> prov$provinceEnglishName);

print("raw data contains of province data:");
str(lapply(province, prov -> length(prov$group), names = prov -> prov$key));

let updateTime = sapply(raw[, "updateTime"], as.object);
let year  = sapply(updateTime, d -> d$Year);
let month = sapply(updateTime, d -> d$Month);
let day   = sapply(updateTime, d -> d$Day);

let dateKey as function(d) {
    `${d$Year}-${d$Month}-${d$Day}`;
}

let dates = sprintf("%s-%s-%s", year, month, day) 
:> unique 
:> orderBy(key -> as.Date(key));

print("We have date values:");
print(dates);