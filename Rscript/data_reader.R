require(dataframe);

let load_raw as function(file.csv) {
    let raw = read.csv.raw(file.csv, encoding = "utf8") :> rows;
    let names = raw[1] :> which(cell -> cell != "");
    let types = raw[2];
    let data = list();

    print(names);

    for(day in raw :> skip(2) :> projectAs(cells)) {
        let date = day[1];


    }

    data;
} 