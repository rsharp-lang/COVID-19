require(dataframe);

setwd(!script$dir);
cat("\n");

let raw = read.csv.raw("../data/DXYArea_simple.csv", encoding = "utf8");
let yesterday = dataframe::row("n/a");
let delta;
let d;
let date;

raw <- rows(raw);

using table as open.csv("../data/COVID-19_delta.csv", encoding = "utf8") {
    table :> append.row(raw[1]);
    table :> append.row(raw[2]);

    for(col in raw[2] :> cells :> skip(1)) {
        yesterday :> append.cells(0);
    }

    for(day in raw :> skip(2)) {
        day <- day :> cells;
        date <- day;
        yesterday <- yesterday :> cells;        
        day <- day[2:length(day)];
        yesterday <- yesterday[2:length(day)];
        d <- (as.numeric(day) - as.numeric(yesterday)) :> sapply(d -> (d > 0) ? d : 0);        
        delta <- dataframe::row((date :> cells)[1]);
        delta :> append.cells(d);
        yesterday <- date;
        table :> append.row(delta);
    }
}

