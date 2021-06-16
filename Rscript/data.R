# Data formatter of the test data
# https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv

# 将原始文件处理为比较容易阅读的累计人数结果表格

require(dataframe);

cat("\n");

const raw      = getDXYAreaRawData();
const province = getChinaProvince(raw); 
const dates    = uniqueDates(raw);

cat("\n");

const result <- lapply(province, prov -> province.data(prov$group, prov$key), names = prov -> prov$key);

# write formatted csv table file
using file as open.csv(`${dirname(@script)}/../data/DXYArea_simple.csv`, encoding = "utf8") {
    let proviNames = names(result);
    let row        = dataframe::row("");
    let sub        = dataframe::row("date");
    let yesterday  = list();

    for(name in proviNames) {
        row :> append.cells(["", name, ""]);
        sub :> append.cells(["confirmed", "cured", "dead"]);

        yesterday[[name]] <- ["0", "0", "0"];
    }

    file :> append.row(row);
    file :> append.row(sub);

    for (day in dates) {
        day <- dateKey(day :> as.object);
        row <- dataframe::row(day);

        for(name in proviNames) {
            const proviData <- result[[name]];
            const dayData   <- proviData[[day]];

            if (is.empty(dayData)) {
                row :> append.cells(yesterday[[name]]);
            } else {
                yesterday[[name]] <- [
                    dayData$province_confirmedCount, 
                    dayData$province_curedCount, 
                    dayData$province_deadCount
                ];

                row :> append.cells(yesterday[[name]]);
            }
        }

        file :> append.row(row);
    }
}