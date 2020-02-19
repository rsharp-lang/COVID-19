Imports COVID_19
Imports SMRUCC.Rsharp.Runtime

Module Module1

    Dim modelFile$ = "E:\COVID-19\Rscript\kinetics\Kinetics_of_SARS_CoV_2_virus_infection_in_humans.R"
    Dim config$ = "C:\Users\Administrator\AppData\Local\GCModeller\R#\R#.configs.xml"

    Sub Main()
        Dim simulator As New Kinetics_of_SARS_CoV_2_virus_infection_in_humans(modelFile.ReadAllText, config)
        Dim handle1 = simulator.CreateInstance(New InitialStatus, Sub(env As Environment)

                                                                  End Sub)
        Dim handle2 = simulator.CreateInstance(New InitialStatus With {.S = 100, .T = 20000}, Sub(env As Environment)

                                                                                              End Sub)

        Pause()
    End Sub
End Module
