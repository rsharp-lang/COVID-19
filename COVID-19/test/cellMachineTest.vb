Imports System.Drawing
Imports COVID_19
Imports Microsoft.VisualBasic.MachineLearning.CellularAutomaton

Module cellMachineTest

    Sub main()
        Dim local As New Simulator(Of People)(New Size(100, 100), Function() New People)

        For Each people In local.RandomCells.Take(10)
            people.data.SetStatus(Status.Enfective)
        Next

        For i As Integer = 0 To 1000
            Call local.Run()
        Next

        Pause()
    End Sub
End Module
