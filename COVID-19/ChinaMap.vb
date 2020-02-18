
Imports Microsoft.VisualBasic.CommandLine.Reflection
Imports Microsoft.VisualBasic.Data.GIS
Imports Microsoft.VisualBasic.Data.GIS.GeoMap
Imports Microsoft.VisualBasic.Imaging.Driver
Imports Microsoft.VisualBasic.Scripting.MetaData

<Package("COVID.19.map")>
Module ChinaMap

    <ExportAPI("map.china")>
    Public Function CreateMap() As SVGData
        Return GeoMapRender.Render(CN.GeoChina())
    End Function
End Module
