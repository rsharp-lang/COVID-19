imports "grDevices.SVG" from "R.graphics.dll";
imports "COVID.19.map" from "COVID-19.dll";

imports "data_reader.R";

setwd(!script$dir);

# create a blank svg map of china
let svg = map.china();
let raw = load_raw(file.csv = "../data/DXYArea_simple.csv");




# test css styling
svg :> styles(".Guangxi", list("fill" = "red"));

svg :> save.graphics(file = "./viz/china.svg");

