require(plot.charts);

setwd(!script$dir);

let result <- read.csv(file = "./Kinetics_of_SARS-CoV-2_virus_infection_in_humans.csv");
let time <- result[, 1] :> as.numeric;
let kinetics as double; 
let names <- list(
    C = ["skyblue", "peoples of cured"],
    T = ["green",   "peoples of healthy"],
    S = ["orange",  "peoples of suspected infections"],
    I = ["red",     "peoples of infected"],
    D = ["black",   "peoples of death"]
);
let plot.kinetics_var as function(var) {
    kinetics <- result[, var] :> as.numeric;
    serial(time, kinetics, name = (names[[var]])[2], color = (names[[var]])[1])
    :> plot(
        padding = [200, 100, 150, 200],
        x.lab = "time(day)",
        y.lab = "number of peoples"
    )
    :> save.graphics(file = `./viz/${var}.png`);
}

for(var in ["C", "T", "S", "I", "D"]) {
    var :> plot.kinetics_var;
}