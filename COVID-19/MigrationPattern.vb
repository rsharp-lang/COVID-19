Imports Microsoft.VisualBasic.Data.visualize.Network.Graph

Public Class MigrationPattern

    Sub New(flowGraph As NetworkGraph)
        Dim targetGroup As Dictionary(Of String, Edge()) = flowGraph _
            .graphEdges _
            .GroupBy(Function(u) u.V.label) _
            .ToDictionary(Function(u) u.Key,
                          Function(g)
                              Return g.ToArray
                          End Function)

    End Sub
End Class
