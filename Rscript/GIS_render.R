# 导入必须的图形库模块
imports "grDevices.SVG" from "R.graphics.dll";
imports "COVID.19.map" from "COVID-19.dll";

# 导入外部脚本文件用来读取特定格式的csv文件
imports "data_reader.R";

setwd(!script$dir);

# load_raw函数来自于所导入的data_reader.R脚本文件
# 文件 "../data/COVID-19_delta.csv" 为全国每日新增数据
# 文件 "../data/DXYArea_simple.csv" 为全国累计结果数据
let raw = load_raw(file.csv = "../data/DXYArea_simple.csv");

let COVID_19.map_render.china as function(
    day, 
    levels = 30, 
    source = ["confirmed", "cured", "dead"], 
    color.schema = "Reds:c6", 
    log.scale = TRUE) {

    # create a blank svg map of china
    let svg = map.china();
    let data.test <- NULL;

    if (is.character(source)) {
        data.test <- lapply(raw[[day]], region -> region[[source[1]]])
    } else {
        data.test <- source(day);
    }

    # view data summary
    str(data.test);

    let colors = colors(color.schema, levels, character = TRUE);
    # 因为不同省份的数据差异较大
    # 所以在这里做log转换
    let values as double = sapply(names(data.test), name -> data.test[[name]]);
    
    if (log.scale) {
        values = log(values +1);
    } else {
        # do nothing
    }
    
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