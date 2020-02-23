Imports COVID_19
Imports SMRUCC.Rsharp.Runtime

Module Module1

    Dim modelFile$ = "E:\COVID-19\Rscript\kinetics\Kinetics_of_SARS_CoV_2_virus_infection_in_humans.R"
    Dim config$ = "C:\Users\Administrator\AppData\Local\GCModeller\R#\R#.configs.xml"

    Sub Main()
        Dim simulator As New Kinetics_of_SARS_CoV_2_virus_infection_in_humans(modelFile.ReadAllText, config)
        Dim city1 = simulator.CreateInstance(New InitialStatus, Sub(env As Environment)

                                                                End Sub)
        Dim city2 = simulator.CreateInstance(New InitialStatus With {.S = 100, .T = 20000}, Sub(env As Environment)

                                                                                            End Sub)
        Dim city3 = simulator.CreateInstance(New InitialStatus With {.S = 1, .T = 500}, Sub(env As Environment)

                                                                                        End Sub)

        For i As Integer = 0 To 100
            Call city1.Tick()
            Call city2.Tick()
            Call city3.Tick()
        Next

        Pause()
    End Sub
End Module
