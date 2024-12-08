:- dynamic(reinforcementCount/1).
:- dynamic(hasReinforcement/1).
:- dynamic(r1/2). :- dynamic(r2/2).

reinforcementCount(0).

rollReinforcement :-
    reinforcementCount(Count),
    (        
        (Count < 2)
        -> (
            % Get random player
            playerList(L),
            playerCount(N),
            Ni is N + 1,

            repeat,
            random(1, Ni, Ri),
            getElement(L, Ri, RandomPlayer),
            (hasReinforcement(RandomPlayer) -> fail ; true),

            % Roll reinforcement for player
            random(1, 2, RandomNumber),
            slowFormat('\nReinforcement roll for player ~w: ~d', [RandomPlayer, RandomNumber], 0.02),
            sleep(0.3),
            (
                (RandomNumber =:= 1)    
                -> (
                    slowFormat('\nPemain ~w berhasil mendapatkan wilayah reinforcement!', [RandomPlayer], 0.02),
                    sleep(0.3),
                    (
                        (r1(_, _))
                        -> ambilReinforcement(r2, RandomPlayer)
                        ; ambilReinforcement(r1, RandomPlayer)
                    ),
                    updateReinforcementCount(Count)
                )
                ; true
            )
        )
        ; true
    ), !.

updateReinforcementCount(Count) :-
    retract(reinforcementCount(Count)),
    NewCount is Count + 1,
    assertz(reinforcementCount(NewCount)), !.

ambilReinforcement(R, Player) :-
    Term =.. [R, Player, 0],
    assertz(Term),

    % Add territory to wilayahDiambil
    wilayahDiambil(WilayahDiambil),
    appendList(WilayahDiambil, [R], NewWilayahDiambil),
    retractall(wilayahDiambil(_)),
    assertz(wilayahDiambil(NewWilayahDiambil)),

    % Print output
    slowFormat('\nPemain ~w mendapatkan wilayah ~w.', [Player, R], 0.02), sleep(0.3), !.