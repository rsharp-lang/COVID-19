imports "COVID.19.map" from "COVID-19.dll";

# create a blank svg map of china
let svg = map.china();

svg :> save.graphics(file = "./china.svg");

