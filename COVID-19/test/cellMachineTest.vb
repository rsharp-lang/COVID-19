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

        Dim snapshots As Dictionary(Of String, List(Of Integer)) = CreateCountSnapshotBuckets(Of Status)()

        For i As Integer = 0 To 1000
            Call local.Run()
            Call local.TakeSnapshots(Function(p) p.type.ToString, snapshots)
        Next

        Dim data = snapshots.CreateSnapshotMatrix(Of DataSet)

        Call data.SaveTo("X:/ddd.csv")

        Pause()
    End Sub
End Module
