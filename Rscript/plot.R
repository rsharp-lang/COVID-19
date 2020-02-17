require(plot.charts);

setwd(!script$dir);

let result <- read.csv(file = "./Kinetics_of_influenza_A_virus_infection_in_humans.csv");
let time <- result[, 1] :> as.numeric;
let kinetics as double; 
let plot.kinetics_var as function(var) {
    kinetics <- result[, var] :> as.numeric;
    serial(time, kinetics, name = var, color = "red")
    :> plot
    :> save.graphics(file = `./${var}.csv`);
}

for(var in ["C", "T", "S", "I", "D"]) {
    var :> plot.kinetics_var;
}