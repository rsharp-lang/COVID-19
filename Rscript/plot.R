require(plot.charts);

setwd(!script$dir);

let result <- read.csv(file = "./Kinetics_of_SARS-CoV-2_virus_infection_in_humans.csv");
let time <- result[, 1] :> as.numeric;
let kinetics as double; 
let names <- list(
    C = "peoples of cured",
    T = "peoples of healthy",
    S = "peoples of suspected infections",
    I = "peoples of infected",
    D = "peoples of death"
);
let plot.kinetics_var as function(var) {
    kinetics <- result[, var] :> as.numeric;
    serial(time, kinetics, name = names[[var]], color = "red")
    :> plot
    :> save.graphics(file = `./viz/${var}.png`);
}

for(var in ["C", "T", "S", "I", "D"]) {
    var :> plot.kinetics_var;
}