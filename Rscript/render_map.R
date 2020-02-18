imports "COVID.19.map" from "COVID-19.dll";
imports "grDevices.SVG" from "R.graphics.dll";

# create a blank svg map of china
let svg = map.china();

# test css styling
svg :> styles(".Guangxi", list("background-color" = "red"));

svg :> save.graphics(file = "./china.svg");

