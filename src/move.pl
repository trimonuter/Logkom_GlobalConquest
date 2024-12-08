move(WilayahA, WilayahB, Totaltroops) :-
    player(CurrentPlayer),
    call(WilayahA, OwnerWilayahA, TroopsA),
    (        
        (OwnerWilayahA \= CurrentPlayer) -> (
            slowFormat('\n~w tidak memiliki wilayah ~w', [CurrentPlayer, WilayahA], 0.02),
            slowWrite('\npemindahan dibatalkan', 0.02)
        ) ; (Totaltroops > TroopsA) -> (
            slowFormat('\n~w memindahkan ~d tentara dari ~w ke ~w', [CurrentPlayer, Totaltroops, WilayahA, WilayahB], 0.02),
            slowWrite('\nTentara tidak mencukupi', 0.02),
            slowWrite('\npemindahan dibatalkan', 0.02)
        ) ; (
            placeTentara(WilayahA, -Totaltroops),
            placeTentara(WilayahB, Totaltroops),
            slowFormat('\n~w memindahkan ~d tentara dari ~w ke ~w', [CurrentPlayer, Totaltroops, WilayahA, WilayahB], 0.02),
            call(WilayahA, OwnerWilayahA, NewTroopsA),
            call(WilayahB, OwnerWilayahB, NewTroopsB),
            slowFormat('\nJumlah tentara di ~w: ~d', [WilayahA, NewTroopsA], 0.02),
            slowFormat('\nJumlah tentara di ~w: ~d', [WilayahB, NewTroopsB], 0.02)
        )
    ).