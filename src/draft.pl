draft(Wilayah, Totaltroops) :-
    player(CurrentPlayer),
    call(Wilayah, OwnerWilayah, Troops),
    tentara(OwnerWilayah, TroopsTambahan),

    (
        (OwnerWilayah \= CurrentPlayer) -> (
            slowFormat('\nPlayer ~w tidak memiliki wilayah ~w', [CurrentPlayer, Wilayah], 0.02)
        ) ; (TroopsTambahan < Totaltroops) -> (
            slowFormat('\nPlayer ~w meletakkan ~d tentara tambahan di ~w', [CurrentPlayer, Totaltroops, Wilayah], 0.02),
            slowWrite('\nPasukan tidak mencukupi', 0.02),
            slowFormat('\nJumlah Pasukan Tambahan Player ~w: ~d', [CurrentPlayer, TroopsTambahan], 0.02),
            slowWrite('\ndraft dibatalkan', 0.02), sleep(0.2)
        ) ; (
            placeTentara(Wilayah, Totaltroops),
            NewTotalTroops is Totaltroops + Troops,
            slowFormat('\nPlayer ~w meletakkan ~d tentara tambahan di ~w', [CurrentPlayer, Totaltroops, Wilayah], 0.02),
            slowFormat('\nTentara total di ~w: ~d', [Wilayah, NewTotalTroops], 0.02),
            tentara(OwnerWilayah, TentaraTambahan),
            slowFormat('\nJumlah Pasukan Tambahan Player ~w: ~d', [CurrentPlayer, TentaraTambahan], 0.02)
        )
    ).