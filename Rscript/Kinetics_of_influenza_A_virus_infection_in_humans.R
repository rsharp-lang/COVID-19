require(base.math);

# 区域传染病动力学模型

setwd(!script$dir);

# config kinetics parameters
let p     <- 3e-2;
let cc    <- 2;
let beta  <- 8.8e-6;
let delta <- 2.6;

# config of the initial status
let y0 = list(V=1.4e-2, T=4e8, I=0);
# 区域传染病动力学模型

# T 表示当前区域内的健康人的数量，假设健康人的数量受下面的因素影响
# 1. 减少：一部分健康人口从当前区域迁出
#         一部分健康人口被感染至潜伏期
# 2. 增加：一部分健康人口迁入当前的区域
#         一部分患病人痊愈
#         一部分潜伏期病人自行痊愈
#
# 在病毒对健康人口的感染方面，假设潜伏期和患病的患者都会对健康人造成传染
# 则健康人被传染至潜伏期实际上因该是由两部分的因素组成的

# S 表示当前区域内的潜伏期患病人数，假设潜伏期的病人数量受下面的因素影响
# 1. 减少：一部分潜伏期病人从当前区域迁出
#         一部分病人转换为患病人
#         一部分病人自行痊愈
# 2. 增加: 一部分潜伏期病人迁入当前区域
#          一部分健康人被传染至潜伏期  
#
# 假设在这一步病毒的传染的效率是和人口密度相关的：人口密度越大，则传染效率越高
# 即模型假设在相同人数的情况下，1万平方公里的区域面积的人口密度高于20万平方公里的区域面积的人口密度 
# 则在相同人数的情况下，病毒在一万平方公里的区域的传播效率要高于20万平方公里的区域
# 即假设A省和B省在人口总数一致的情况下，A省的面积小，人口密度大，则A省内的病毒传播效率要高于B省

# I 表示当前区域内的患病人数，假设患病人数的数量受下面的因素影响
# 1. 减少：一部分患病人从当前区域迁出
#         一部分患病人康复
#         一部分患病人死亡
# 2. 增加：一部分潜伏期病人成为患病病人
#         一部分患病人迁入当前区域

# D 表示当前区域内因传染病死亡的病人数量，其只受一个因素影响
# 1. 增加：一部分患病人死亡

let Kinetics_of_influenza_A_virus_infection_in_humans = [
	T ->  Tin        # 迁入当前区域的健康人数量
	     + Icure * I # 患病人治愈
		 + Scure * S # 潜伏期自愈
		 - beta * T * I  # 被患病病人感染至潜伏期
		 - lambda * T * S # 被潜伏期病人感染至潜伏期
		 - Tout,     # 健康人口迁出当前区域         
	
	S -> Sin            # 迁入当前区域的潜伏期病人
	     + beta * T * I # 健康人被潜伏期患者感染为潜伏期病人
		 + lambda * T * S # 健康人被患者感染为潜伏期病人
		 - Sout   # 潜伏期病人从当前区域迁出
		 - gamma * S # 潜伏期转换为患病人
		 - Scure * S, # 潜伏期自愈

	I -> gamma * S # 潜伏期病人转换为患病人
	     + Iin   # 迁入当前区域的患病人
		 - Iout # 从当前区域迁出的患病人
		 - Icure * I # 被治愈的病人
		 - delta * I, # 死亡的病人  
    
	D -> delta * I, # 死亡的病人，delta可以近似看作为病死率    
];

# do run kinetics system simulation
Kinetics_of_influenza_A_virus_infection_in_humans
:> deSolve(y0, a = 0, b = 7)
:> as.data.frame 
:> write.csv(file = "./Kinetics_of_influenza_A_virus_infection_in_humans.csv")
;
