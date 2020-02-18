imports "grDevices.SVG" from "R.graphics.dll";
imports "COVID.19.map" from "COVID-19.dll";

imports "data_reader.R";

setwd(!script$dir);

# create a blank svg map of china
let svg = map.china();
let raw = load_raw(file.csv = "../data/DXYArea_simple.csv");

let data.test = raw[["2020-2-4"]];
let levels = 30;

# str(data.test);

data.test <- lapply(data.test, region -> region$confirmed);

# view data summary
str(data.test);

let colors = colors("Reds:c6", levels, character = TRUE);
let values = log( sapply(names(data.test), name -> data.test[[name]])+1);
let range = [min(values), max(values)];

print("Value range in target day:");
print(range);

# do scale mapping to get color level index
# percent = (x - min1) / (max1 - min1)
# value = percent * (max2 - min2) + min2

let color.index = round( (levels -1) * ((values - range[1]) / (range[2] - range[1]))) :> as.integer + 1;
let i = 1;

print("Now we translate the stat values to color index");
print(color.index);

# do css styling
for(name in names(data.test)) {
    svg :> styles(`.${name}`, list("fill" = colors[color.index[i]]));
    i <- i + 1;
}

svg :> save.graphics(file = "./viz/china.svg");

