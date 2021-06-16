# Data formatter of the test data
# https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv

# 将原始文件处理为比较容易阅读的累计人数结果表格

require(dataframe);

#' Get raw data
#' 
#' @description https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv
#' 
const getDXYAreaRawData as function() {
    const filepath as string = system.file("data/DXYArea.csv", package = "COVID19");
    const raw = read.csv(filepath, encoding = "utf8");

    raw[, "updateTime"] <- as.Date(raw[, "updateTime"]);

    print("Peeks of the raw data table:");
    print("All of the data fields:");
    print(colnames(raw));
    cat("\n");
    print("Number of data records:");
    print(nrow(raw));

    raw;
}

#' removes data outside China
#' 
const getChinaProvince as function(raw) {
    const province = raw 
    |> as.list(byrow = TRUE) 
    # removes data outside China
    |> which(r -> r$countryEnglishName == "China")
    |> groupBy(prov -> prov$provinceEnglishName)
    ;

    print("raw data contains of province data:");
    cat("\n");
    str(lapply(province, prov -> length(prov$group), names = prov -> prov$key));

    province;
}

#' get unique dates
#' 
const uniqueDates as function(raw) {
    let updateTime = sapply(raw[, "updateTime"], as.object);
    let year       = sapply(updateTime, d -> d$Year);
    let month      = sapply(updateTime, d -> d$Month);
    let day        = sapply(updateTime, d -> d$Day);
    let dates = sprintf("%s-%s-%s", year, month, day) 
    :> unique 
    :> as.Date
    :> orderBy(key -> key)
    ;

    print("We have date values:");
    print(dates);

    dates;
}

const day.data as function(group) {
    let confirmedCount = sapply(group, x -> x$province_confirmedCount);
    let curedCount     = sapply(group, x -> x$province_curedCount);
    let deadCount      = sapply(group, x -> x$province_deadCount);

    list(
        province_confirmedCount = max(confirmedCount),
        province_curedCount     = max(curedCount),
        province_deadCount      = max(deadCount)
    );
}

const province.data as function(prov.group, name) {
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
        i = i + 1; 
        dates[i];
    });

    # print(length(dates));
    # print(i);

    prov  = lapply(prov, d -> day.data(d$group), names = d -> d$key);
    prov;
}

const dateKey as function(d) {
    `${d$Year}-${d$Month}-${d$Day}`;
}