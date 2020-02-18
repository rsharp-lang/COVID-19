
Imports Microsoft.VisualBasic.CommandLine.Reflection
Imports Microsoft.VisualBasic.Data.GIS
Imports Microsoft.VisualBasic.Data.GIS.GeoMap
Imports Microsoft.VisualBasic.Imaging.SVG
Imports Microsoft.VisualBasic.Scripting.MetaData

<Package("COVID.19.map")>
Module ChinaMap

    <ExportAPI("map.china")>
    Public Function CreateMap() As SVGDataLayers
        Return GeoMapRender.Render(CN.GeoChina()).SVG
    End Function
End Module
