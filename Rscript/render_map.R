imports "grDevices.SVG" from "R.graphics.dll";
imports "COVID.19.map" from "COVID-19.dll";

imports "data_reader.R";

setwd(!script$dir);

# create a blank svg map of china
let svg = map.china();
let raw = load_raw(file.csv = "../data/DXYArea_simple.csv");

let data.test = raw[["2020-2-4"]];


# str(data.test);

data.test <- lapply(data.test, region -> region$confirmed);

# view data summary
str(data.test);

print(colors("Reds:c6", 60));

let range = [min(unlist(data.test)), max(unlist(data.test))];
let color.index = 1:60;
let value as double;

print("Value range in target day:");
print(range);

for(name in names(data.test)) {

}

# test css styling
svg :> styles(".Guangxi", list("fill" = "red"));

svg :> save.graphics(file = "./viz/china.svg");

