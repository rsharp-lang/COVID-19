require(dataframe);

setwd(!script$dir);
cat("\n");

let raw = read.csv.raw("../data/DXYArea_simple.csv", encoding = "utf8");
let yesterday = dataframe::row("n/a");
let delta;
let d;
let date;
let len as integer;

raw <- rows(raw);

using table as open.csv("../data/COVID-19_delta.csv", encoding = "utf8") {
    table :> append.row(raw[1]);
    table :> append.row(raw[2]);

    for(col in raw[2] :> cells :> skip(1)) {
        yesterday :> append.cells(0);
    }

    for(day in raw :> skip(2)) {
        date      <- day;
        day       <- day :> cells;
        yesterday <- yesterday :> cells; 
        len       <- length(day);
        day       <- as.numeric(day[2:len]);
        yesterday <- as.numeric(yesterday[2:len]);

        # str(day);
        # str(yesterday);

        # the negative delta value should be removed
        d         <- sapply(day - yesterday, d -> (d > 0) ? d : 0);        
        yesterday <- date;
        delta     <- dataframe::row((date :> cells)[1]);
        
        delta :> append.cells(d);
        table :> append.row(delta);
    }
}

