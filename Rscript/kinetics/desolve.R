imports "Kinetics_of_SARS_CoV_2_virus_infection_in_humans.R";

# 行政区域传染病动力学模型
# Demo R#脚本示例
setwd(!script$dir);

let population.size = 1e4;
# 系统初始值
let y0 = list(
    T = population.size,  # 当前行政区域的总人口
    C = 0,                # 初期没有人拥有抗体
    S = 1,                # 最初只有一个潜伏期病人
    I = 0,                # 最初没有患者
    D = 0                 # 最初没有死亡病人
);

# 运行传染病动力学模型
Kinetics_of_SARS_CoV_2_virus_infection_in_humans
:> deSolve(y0, a = 0, b = 31)
:> as.data.frame(x.lab = "time") 
:> write.csv(
    file = "./Kinetics_of_SARS-CoV-2_virus_infection_in_humans.csv", 
    row_names = FALSE
);