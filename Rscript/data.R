# Data formatter of the test data
# https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv

require(dataframe);

setwd(!script$dir);
cat("\n");

let raw = read.csv("../data/DXYArea.csv", encoding = "utf8");

raw[, "updateTime"] <- as.Date(raw[, "updateTime"]);

print("Peeks of the raw data table:");
print("All of the data fields:");
print(colnames(raw));
cat("\n");
print("Number of data records:");
print(nrow(raw));

let province = raw 
:> as.list(byrow = TRUE) 
:> groupBy(prov -> prov$provinceEnglishName);

print("raw data contains of province data:");
cat("\n");
str(lapply(province, prov -> length(prov$group), names = prov -> prov$key));

let updateTime = sapply(raw[, "updateTime"], as.object);
let year       = sapply(updateTime, d -> d$Year);
let month      = sapply(updateTime, d -> d$Month);
let day        = sapply(updateTime, d -> d$Day);
let dates = sprintf("%s-%s-%s", year, month, day) 
:> unique 
:> as.Date
:> orderBy(key -> key);

print("We have date values:");
print(dates);

cat("\n");

let day.data as function(group) {
    let confirmedCount = sapply(group, x -> x$province_confirmedCount);
    let curedCount = sapply(group, x -> x$province_curedCount);
    let deadCount = sapply(group, x -> x$province_deadCount);

    list(
        province_confirmedCount = max(confirmedCount),
        province_curedCount = max(curedCount),
        province_deadCount = max(deadCount)
    );
}

let province.data as function(prov.group, name) {
    # table row subsets
    let updateTime = sapply(prov.group, d -> as.object(d$updateTime));
    let year       = sapply(updateTime, d -> d$Year);
    let month      = sapply(updateTime, d -> d$Month);
    let day        = sapply(updateTime, d -> d$Day);
    let i = 0;

    # get all of the dates of the data in current 
    # province region
    let dates = sprintf("%s-%s-%s", year, month, day);

    print(`Processing ${length(dates)} dates with ${length(prov.group)} records from '${name}'.`);

    let prov  = prov.group :> groupBy(function(d) {
        i = i + 1; dates[i];
    });

    # print(length(dates));
    # print(i);

    prov  = lapply(prov, d -> day.data(d$group), names = d -> d$key);
    prov;
}

let result <- lapply(province, prov -> province.data(prov$group, prov$key));
let dateKey as function(d) {
    `${d$Year}-${d$Month}-${d$Day}`;
}

names(result) <- sapply(province, prov -> prov$key);
# str(result);

# write formatted csv table file
using file as open.csv("../data/DXYArea_simple.csv", encoding = "utf8") {
    let proviNames = names(result);
    let row = dataframe::row("");
    let sub = dataframe::row("date");

    for(name in proviNames) {
        row :> append.cells(["", name, ""]);
        sub :> append.cells(["confirmed", "cured", "dead"]);
    }

    file :> append.row(row);
    file :> append.row(sub);

    let proviData;
    let dayData;

    for (day in dates) {
        day <- dateKey(day :> as.object);
        row <- dataframe::row(day);

        for(name in proviNames) {
            proviData <- result[[name]];
            dayData <- proviData[[day]];

            if (is.empty(dayData)) {
                row :> append.cells([0, 0, 0]);
            } else {
                row :> append.cells([
                    dayData$province_confirmedCount, 
                    dayData$province_curedCount, 
                    dayData$province_deadCount
                ]);
            }
        }

        file :> append.row(row);
    }
}