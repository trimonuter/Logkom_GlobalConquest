% Boolean States
:- dynamic(isPlaying/0).
:- dynamic(riskAvailable/0).
:- dynamic(attackAvailable/0).

% Rules
endTurn :-
    isPlaying,
    player(P),
    slowFormat('\nPlayer ~w mengakhiri giliran.', [P], 0.02),
    sleep(0.5),
    endTurnCont.

endTurnCont :-
    % Switch to next player
    nextPlayer,
    currentPlayer(I),
    (
        (I =:= 1)
        -> (
            slowWrite('\n\nSatu ronde sudah berakhir.', 0.02), sleep(0.3),
            slowWrite('\nRonde berikutnya dimulai.', 0.02), sleep(0.3),
            rollReinforcement, nl
        )
        ; true    
    ),
    player(P),
    slowFormat('\nSekarang giliran player ~w!', [P], 0.02),
    sleep(0.5),

    % Update boolean variables
    assertz(riskAvailable),
    assertz(attackAvailable),

    % Remove RISK effects
    retractall(ceasefire(P)),
    retractall(superSoldier(P)),
    retractall(diseaseOutbreak(P)),

    % Handler for RISK: SUPPLY CHAIN ISSUE
    (
        (supplyChainIssue(P))
        -> (
            slowWrite('\nSUPPLY CHAIN ISSUE!', 0.02), sleep(0.3),
            slowWrite('\nPemain tidak mendapatkan tentara tambahan pada giliran ini.', 0.02), sleep(0.3),
            
            displayMap,
            retractall(supplyChainIssue(P)),
            abort
        )
        ; true
    ),

    % Calculate additional troops
    getPlayerTerritory(P, TerrList),
    count(TerrList, TerrCount),
    NewTroops is (TerrCount // 2),
    slowFormat('\nTambahan tentara wilayah: Pemain mendapatkan ~d tentara tambahan.', [NewTroops], 0.02),
    sleep(0.5),

    % Calculate domination bonus troops
    checkDominatedTerritory(BonusTroops),
    slowFormat('\nBenua dikuasai: Pemain mendapatkan ~d tentara bonus.', [BonusTroops], 0.02),
    sleep(0.5),

    % Write total new troops
    TotalAdd is NewTroops + BonusTroops,
    slowFormat('\nPlayer ~w mendapatkan ~d tentara tambahan.', [P, TotalAdd], 0.02),
    sleep(0.5),
    (
        % Handler for RISK: AUXILIARY TROOPS
        (auxiliary(P))
        -> (
            slowWrite('\nAUXILIARY!', 0.02), sleep(0.3),
            slowWrite('\nTentara tambahan pemain pada giliran ini dilipatgandakan.', 0.02), sleep(0.3),
            NewTotalAdd is TotalAdd * 2,
            slowFormat('\nPlayer ~w mendapatkan ~d tentara tambahan.', [P, NewTotalAdd], 0.02),
            addTentara(NewTotalAdd),
            retractall(auxiliary(P))
        )
        ; addTentara(TotalAdd)
    ),

    displayMap,

    % Add isPlaying to database
    retractall(isPlaying),
    assertz(isPlaying).
    
% Calculate bonus troops for dominated territory
checkDominatedTerritory(Bonus) :-
    northAmerica(NA),
    southAmerica(SA),
    europe(E),
    africa(AF),
    asia(AS),
    australia(AU),

    checkDominatedTerritory([NA, SA, E, AF, AS, AU], [3, 2, 3, 2, 5, 1], 0, Bonus).

checkDominatedTerritory([], [], Count, Count) :- !.
checkDominatedTerritory([Head | Tail], [BonusHead | BonusTail], Count, Bonus) :-
    player(P),
    getPlayerTerritory(P, L),

    (
        (subset(L, Head)) -> (
            NewCount is Count + BonusHead
        )
        ; (
            NewCount is Count    
        )
    ),
    checkDominatedTerritory(Tail, BonusTail, NewCount, Bonus).