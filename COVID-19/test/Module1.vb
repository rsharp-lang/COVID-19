Imports COVID_19

Module Module1

    Dim modelFile$ = "E:\COVID-19\Rscript\kinetics\Kinetics_of_SARS_CoV_2_virus_infection_in_humans.R"

    Sub Main()
        Dim simulator As New Kinetics_of_SARS_CoV_2_virus_infection_in_humans(modelFile.ReadAllText)
        Dim handle = simulator.CreateInstance(New InitialStatus)

        Pause()
    End Sub
End Module
