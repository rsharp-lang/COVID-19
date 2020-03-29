Imports Microsoft.VisualBasic.ComponentModel.DataSourceModel
Imports Microsoft.VisualBasic.Data.visualize.Network.Graph
Imports Microsoft.VisualBasic.Serialization.JSON

''' <summary>
''' The population migration pattern.
''' </summary>
Public Class MigrationPattern

    ReadOnly targetGroup As Dictionary(Of String, Dictionary(Of String, Double))
    ReadOnly sourceGroup As Dictionary(Of String, Dictionary(Of String, Double))

    Sub New(flowGraph As NetworkGraph)
        targetGroup = flowGraph _
            .graphEdges _
            .GroupBy(Function(u) u.V.label) _
            .ToDictionary(Function(u) u.Key,
                          Function(g)
                              ' 计算出网络之中到达同一个节点的流量的权重
                              ' 这些权重加起来应该是1
                              ' 整体流量应该是Tin
                              Return calcWeights(g, Function(e) e.U)
                          End Function)
        sourceGroup = flowGraph _
            .graphEdges _
            .GroupBy(Function(v) v.U.label) _
            .ToDictionary(Function(u) u.Key,
                          Function(g)
                              ' 计算出网络之中从同一个节点出发的流量的权重
                              ' 这些权重加起来应该是1
                              ' 整体流量应该是Tout
                              Return calcWeights(g, Function(u) u.V)
                          End Function)

    End Sub

    Private Shared Function calcWeights(g As IEnumerable(Of Edge), getPoint As Func(Of Edge, Node)) As Dictionary(Of String, Double)
        Dim flowSize As NamedValue(Of Double)() = g _
            .Select(Function(u)
                        Return New NamedValue(Of Double) With {
                            .Name = getPoint(u).label,
                            .Value = u.weight
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

    Public Function getKineticsParameters(regionId$, isInput As Boolean) As Dictionary(Of String, Double)
        If isInput Then
            Return targetGroup(regionId)
        Else
            Return sourceGroup(regionId)
        End If
    End Function

End Class

Public Class MigrationRatio

    Public Property cured As Double
    Public Property healthy As Double
    Public Property suspected As Double
    Public Property infected As Double

    Public ReadOnly Property sum As Double
        Get
            Return cured + healthy + suspected + infected
        End Get
    End Property

    Sub New(Optional cured As Double = 0.2,
            Optional healthy As Double = 0.375,
            Optional suspected As Double = 0.375,
            Optional infected As Double = 0.05)

        Me.cured = cured
        Me.healthy = healthy
        Me.suspected = suspected
        Me.infected = infected
    End Sub

    Public Function Shunting(total As Double) As Dictionary(Of String, Double)
        Return New Dictionary(Of String, Double) From {
            {NameOf(cured), cured * total},
            {NameOf(healthy), healthy * total},
            {NameOf(suspected), suspected * total},
            {NameOf(infected), infected * total}
        }
    End Function

    Public Overrides Function ToString() As String
        Return Me.GetJson
    End Function

End Class