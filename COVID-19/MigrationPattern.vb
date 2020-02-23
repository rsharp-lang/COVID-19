Imports Microsoft.VisualBasic.ComponentModel.DataSourceModel
Imports Microsoft.VisualBasic.Data.visualize.Network.Graph

''' <summary>
''' The population migration pattern.
''' </summary>
Public Class MigrationPattern

    Sub New(flowGraph As NetworkGraph)
        Dim targetGroup As Dictionary(Of String, Edge()) = flowGraph _
            .graphEdges _
            .GroupBy(Function(u) u.V.label) _
            .ToDictionary(Function(u) u.Key,
                          Function(g)
                              Return g.ToArray
                          End Function)
        Dim sourceGroup As Dictionary(Of String, Dictionary(Of String, Double)) = flowGraph _
            .graphEdges _
            .GroupBy(Function(v) v.U.label) _
            .ToDictionary(Function(u) u.Key,
                          Function(g)
                              Return sourceWeight(g)
                          End Function)
    End Sub

    Private Shared Function sourceWeight(g As IEnumerable(Of Edge)) As Dictionary(Of String, Double)
        Dim flowSize As NamedValue(Of Double)() = g _
            .Select(Function(u)
                        Return New NamedValue(Of Double) With {
                            .Name = u.V.label,
                            .Value = u.data.weight
                        }
                    End Function) _
            .ToArray
        Dim total As Double = Aggregate target In flowSize Into Sum(target.Value)
        Dim weights As Dictionary(Of String, Double) = flowSize _
            .ToDictionary(Function(t) t.Name,
                          Function(t)
                              Return t.Value / total
                          End Function)
        Return weights
    End Function
End Class
