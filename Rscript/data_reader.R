require(dataframe);

let load_raw as function(file.csv) {
    let raw = read.csv.raw(file.csv, encoding = "utf8") :> rows;
    let names = raw[1] :> cells :> which(cell -> cell != "");
    let types = raw[2] :> cells;
    let data = list();

    print(names);
    print(unique(types));

    for(day in raw :> skip(2) :> projectAs(cells)) {
        let date = day[1];
        let regions = list();
        let dist;
        let i = 2; # [date], ....data
        
        for(name in names) {
            dist = list(name = name);

            for(n in 1:3) {
                dist[[types[i]]] <- day[i];
                i <- i + 1;
            }

            regions[[name]] <- dist;
        }

        data[[date]] <- regions;
    }

    # str(data);

    data;
} 