Imports SMRUCC.Rsharp.Interpreter
Imports SMRUCC.Rsharp.Runtime

Public Class Kinetics_of_SARS_CoV_2_virus_infection_in_humans

    Dim modelScript$

    Sub New(modelScript As String)
        Me.modelScript = modelScript
    End Sub

    Public Function CreateInstance(y0 As InitialStatus)
        Dim engine As New RInterpreter

        Call engine.Evaluate(modelScript)
        Call engine.Add("y0", engine.Evaluate($"list(
            T = {y0.T},  # 当前行政区域的总人口
            C = {y0.C},  # 初期没有人拥有抗体
            S = {y0.S},  # 最初只有一个潜伏期病人
            I = {y0.I},  # 最初没有患者
            D = {y0.D}
        )"))
        Call engine.Add("tick", Sub(env As Environment)

                                End Sub)

        Dim iterator = engine.Evaluate("deSolve(y0, a = 0, b = 31, tick = tick);")

        Return iterator
    End Function
End Class

Public Class InitialStatus

    Public Property T As Integer
    Public Property C As Integer
    Public Property S As Integer = 1
    Public Property I As Integer
    Public Property D As Integer

End Class