Imports Microsoft.VisualBasic.Language
Imports Microsoft.VisualBasic.MachineLearning.CellularAutomaton
Imports randf = Microsoft.VisualBasic.Math.RandomExtensions

Public Enum Status
    ''' <summary>
    ''' 健康易感人群
    ''' </summary>
    Susceptible
    ''' <summary>
    ''' 潜伏期的
    ''' </summary>
    Enfective
    ''' <summary>
    ''' 受感染的
    ''' </summary>
    Infective
    ''' <summary>
    ''' 重症的
    ''' </summary>
    Advanced
    ''' <summary>
    ''' 死亡的
    ''' </summary>
    Dead
    ''' <summary>
    ''' 治愈的
    ''' </summary>
    Removed
End Enum

Public Class People : Implements Individual

    Dim status As Status = Status.Susceptible

    ''' <summary>
    ''' [0,1]之间的传染性
    ''' </summary>
    Dim infectivity As Double = 0.8
    Dim countTick As i32 = Scan0

    ''' <summary>
    ''' 从潜伏期到患病状态所需要的步数
    ''' </summary>
    Dim pathopoiesis As Integer = 10
    Dim ICU As Integer = 20
    Dim death As Integer = 40
    ''' <summary>
    ''' 自愈所需要的步数
    ''' </summary>
    Dim selfCure As Integer = 30
    ''' <summary>
    ''' 从痊愈具有抗体抗性到转换为易感人群所需要的步数
    ''' </summary>
    Dim lapse As Integer = 20

    Public ReadOnly Property type As Status
        Get
            Return status
        End Get
    End Property

    Public Sub Tick(adjacents As IEnumerable(Of Individual)) Implements Individual.Tick
        If status = Status.Susceptible Then
            If adjacents.Any(AddressOf infectionDynamics) Then
                status = Status.Enfective
                countTick = 0
            End If
        ElseIf status = Status.Enfective Then
            If ++countTick >= pathopoiesis Then
                ' 必须转变为致病状态
                status = Status.Infective
                countTick = Scan0
            Else
                ' 有一定几率转换为致病状态
                If randf.seeds.NextDouble < (countTick / pathopoiesis) Then
                    status = Status.Infective
                    countTick = Scan0
                ElseIf randf.seeds.NextDouble < ((pathopoiesis - countTick) / pathopoiesis) Then
                    ' 有一定几率转换为自愈状态
                    status = Status.Removed
                    countTick = Scan0
                End If
            End If
        ElseIf status = Status.Infective Then
            ' 可能变为重症，也可能变为自愈
            If ++countTick >= selfCure Then
                status = Status.Removed
                countTick = Scan0
            ElseIf randf.seeds.NextDouble < ((countTick / ICU) / 2) Then
                status = Status.Advanced
                countTick = Scan0
            End If
        ElseIf status = Status.Advanced Then
            ' 可能死亡，也可能自愈
            If ++countTick >= selfCure Then
                status = Status.Removed
                countTick = Scan0
            ElseIf randf.seeds.NextDouble < ((countTick / death) / 2) Then
                status = Status.Dead
                countTick = Scan0
            End If
        ElseIf status = Status.Removed Then
            If ++countTick >= lapse Then
                status = Status.Susceptible
            End If
        ElseIf status = Status.Dead Then
            ' 已死亡，无任何动作
        Else
            Throw New InvalidProgramException(status.ToString)
        End If
    End Sub

    Private Function infectionDynamics(people As People) As Boolean
        If people.status = Status.Enfective OrElse people.status = Status.Infective OrElse people.status = Status.Advanced Then
            ' 有一定概率感染健康人
            If randf.seeds.NextDouble <= infectivity Then
                Return True
            End If
        End If

        Return False
    End Function

    Public Sub SetStatus(status As Status)
        Me.status = status
    End Sub

    Public Overrides Function ToString() As String
        Return $"{status.ToString} ... {countTick}"
    End Function
End Class