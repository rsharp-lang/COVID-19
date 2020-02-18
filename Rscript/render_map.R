imports "GIS_render.R";

# 渲染的颜色可以在这里进行设置
# 在这里使用颜色集名称作为颜色来源
# 颜色集名称可以参考文档：
# https://github.com/xieguigang/sciBASIC/blob/master/gr/Microsoft.VisualBasic.Imaging/Drawing2D/Colors/DesignerTerms.vb#L53
# 颜色集颜色列表的展示可以查看文件夹
# https://github.com/xieguigang/sciBASIC/tree/master/gr/Colors/colorbrewer
let color_set as string = "RdPu:c6";

# color_set = "YlOrBr:c6";

# 也可以使用自定义颜色集，颜色数量可以为任意多个颜色字符串
# 支持html颜色代码
# 例如：白 绿 蓝
# color_set = ["white", "#2EFE64", "blue"];

# 修改下面的日期，数据源进行地图的彩色渲染
["2020-2-18"]
:> COVID_19.map_render.china(
      levels = 30, 
      source = "confirmed", 
      color.schema = color_set
   ) 
:> save.graphics(file = "./viz/2020-2-18.confirmed.svg")
;

# 自定义数据可视化: 治愈人数 / 确诊人数
let custom = function(day) {
    lapply(raw[[day]], region -> region$cured / region$confirmed)
};

["2020-2-18"]
:> COVID_19.map_render.china(
      levels = 30, 
      source = custom, 
      color.schema = ["red", "yellow", "green"],
      log.scale = FALSE
   ) 
:> save.graphics(file = "./viz/2020-2-18.cured_vs_confirmed.svg")
;

