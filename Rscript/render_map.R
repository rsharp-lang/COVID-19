imports "COVID.19.map" from "COVID-19.dll";
imports "grDevices.SVG" from "R.graphics.dll";

setwd(!script$dir);

# create a blank svg map of china
let svg = map.china();

# test css styling
svg :> styles(".Guangxi", list("fill" = "red"));

svg :> save.graphics(file = "./viz/china.svg");
