Imports System.Drawing
Imports COVID_19
Imports Microsoft.VisualBasic.Data.csv
Imports Microsoft.VisualBasic.Data.csv.IO
Imports Microsoft.VisualBasic.MachineLearning.CellularAutomaton

Module cellMachineTest

    Sub main()
        Dim local As New Simulator(Of People)(New Size(100, 100), Function() New People)

        For Each people In local.RandomCells.Take(10)
            people.data.SetStatus(Status.Enfective)
        Next

        Dim snapshots As New Dictionary(Of String, List(Of Integer))

        For Each statuKey In Enums(Of Status)()
            snapshots.Add(statuKey.ToString, New List(Of Integer))
        Next

        For i As Integer = 0 To 1000
            Call local.Run()
            Call local.TakeSnapshots(Function(p) p.type.ToString, snapshots)
        Next

        Dim data = snapshots.Values _
            .First _
            .Select(Function(null, i)
                        Return New DataSet With {
                            .ID = i,
                            .Properties = snapshots _
                                .ToDictionary(Function(d) d.Key,
                                              Function(d)
                                                  Return CDbl(d.Value(i))
                                              End Function)
                        }
                    End Function) _
            .ToArray

        Call data.SaveTo("X:/ddd.csv")

        Pause()
    End Sub
End Module
