imports "Kinetics_of_SARS_CoV_2_virus_infection_in_humans.R";

# 行政区域传染病动力学模型
# Demo R#脚本示例
setwd(!script$dir);

# 运行传染病动力学模型
Kinetics_of_SARS_CoV_2_virus_infection_in_humans
:> deSolve(y0, a = 0, b = 31)
:> as.data.frame(x.lab = "time") 
:> write.csv(
    file = "./Kinetics_of_SARS-CoV-2_virus_infection_in_humans.csv", 
    row_names = FALSE
);