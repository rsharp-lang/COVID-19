imports "GIS_render.R";

print(dates.all);

# 自定义数据可视化: 治愈人数 / 确诊人数
let custom = function(day) {
    lapply(raw[[day]], region -> region$cured / region$confirmed)
};

for(day in dates.all) {
    day
    :> COVID_19.map_render.china(
        levels = 30, 
        source = "confirmed", 
        color.schema = ["white", "yellow", "red"]
    ) 
    :> save.graphics(file = `./viz/days/${day}.confirmed.svg`)
    ;

    day
    :> COVID_19.map_render.china(
        levels = 30, 
        source = custom, 
        color.schema = ["red", "yellow", "green"],
        log.scale = FALSE
    ) 
    :> save.graphics(file = `./viz/days/${day}.cured_vs_confirmed.svg`)
    ;
}

