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

let dateKey as function(d) {
    `${d$Year}-${d$Month}-${d$Day}`;
}

let dates = sprintf("%s-%s-%s", year, month, day) 
:> unique 
:> orderBy(key -> as.Date(key));

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

let province.data as function(prov) {
    # table row subsets
    prov = prov :> groupBy(d -> dateKey(d$updateTime));
    prov = lapply(prov, d -> day.data(d$group), names = d -> d$key);
    prov;
}

let result <- for(prov in province) %dopar% {
    province.data(prov$group);
}

names(result) <- as.character(sapply(province, prov -> prov$key));
str(result);