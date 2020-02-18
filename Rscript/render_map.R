# 导入必须的图形库模块
imports "grDevices.SVG" from "R.graphics.dll";
imports "COVID.19.map" from "COVID-19.dll";

# 导入外部脚本文件用来读取特定格式的csv文件
imports "data_reader.R";

setwd(!script$dir);

# load_raw函数来自于所导入的data_reader.R脚本文件
let raw = load_raw(file.csv = "../data/DXYArea_simple.csv");

let COVID_19.map_render.china as function(day, levels = 30, type = ["confirmed", "cured", "dead"], color.schema = "Reds:c6") {
    let data.test <- lapply(raw[[day]], region -> region[[type]]);
    # create a blank svg map of china
    let svg = map.china();

    # view data summary
    str(data.test);

    let colors = colors(color.schema, levels, character = TRUE);
    # 因为不同省份的数据差异较大
    # 所以在这里做log转换
    let values = log( sapply(names(data.test), name -> data.test[[name]])+1);
    let range = [min(values), max(values)];

    print("Value range in target day:");
    print(range);

    # do scale mapping to get color level index
    # percent = (x - min1) / (max1 - min1)
    # value = percent * (max2 - min2) + min2

    let color.index = round( (levels -1) * ((values - range[1]) / (range[2] - range[1]))) :> as.integer + 1;
    let i = 1;

    print("Now we translate the stat values to color index");
    print(color.index);

    # do css styling
    # 为每一个省市通过css添加颜色渲染
    for(name in names(data.test)) {
        svg :> styles(`.${name}`, list("fill" = colors[color.index[i]]));
        i <- i + 1;
    }

    svg;
}

# 渲染的颜色可以在这里进行设置
# 在这里使用颜色集名称作为颜色来源
let color_set as string = "RdPu:c6";

# 也可以使用自定义颜色集
color_set = ["white", "blue", "red"];

# 修改下面的日期，类型进行地图的彩色渲染
["2020-2-18"]
:> COVID_19.map_render.china(
      levels = 30, 
      type = "confirmed", 
      color.schema = color_set
   ) 
:> save.graphics(file = "./viz/2020-2-18.confirmed.svg")
;


