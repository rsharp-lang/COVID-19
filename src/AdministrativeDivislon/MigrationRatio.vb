
Imports Microsoft.VisualBasic.Serialization.JSON

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