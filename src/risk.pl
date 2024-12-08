% Positive Boosts
:- dynamic(ceasefire/1).
:- dynamic(superSoldier/1).
:- dynamic(auxiliary/1).

% Negative Boosts
:- dynamic(rebellion/1).
:- dynamic(diseaseOutbreak/1).
:- dynamic(supplyChainIssue/1).

% Card Names
cfo('CEASEFIRE ORDER').
sso('SUPER SOLDIER SERUM').
aux('AUXILIARY TROOPS').
reb('REBELLION').
dsob('DISEASE OUTBREAK').
sci('SUPPLY CHAIN ISSUE').

% Card Messages
cfoM('\nHingga giliran berikutnya, wilayah pemain tidak dapat diserang oleh lawan.').
ssoM('\nHingga giliran berikutnya, semua hasil lemparan dadu pemain saat penyerangan dan pertahanan akan bernilai 6.').
auxM('\nPada giliran berikutnya, tentara tambahan yang didapatkan pemain akan bernilai 2 kali lipat.').
rebM('\nSalah satu wilayah acak pemain akan berpindah kekuasaan menjadi milik lawan.').
dsobM('\nHingga giliran berikutnya, semua hasil lemparan dadu pemain saat penyerangan dan pertahanan akan bernilai 1.').
sciM('\nPada giliran berikutnya, pemain tidak mendapatkan tentara tambahan.').

risk :-
    isPlaying,
    \+ riskAvailable,
    slowWrite('\nAnda sudah memainkan RISK pada giliran ini!', 0.02),
    sleep(0.3),
    slowWrite('\nSilahkan memainkan RISK di giliran berikutnya.', 0.02),
    sleep(0.5), !.
risk :-
    % Strings
    cfo(CFO),
    sso(SSO),
    aux(AUX),
    reb(REB),
    dsob(DSOB),
    sci(SCI),

    cfoM(CFO_M),
    ssoM(SSO_M),
    auxM(AUX_M),
    rebM(REB_M),
    dsobM(DSOB_M),
    sciM(SCI_M),

    % Program
    isPlaying,
    riskAvailable,
    random(1, 7, Risk),
    (
        (Risk =:= 1) -> runRisk(ceasefire, CFO, CFO_M)
        ; (Risk =:= 2) -> runRisk(superSoldier, SSO, SSO_M)
        ; (Risk =:= 3) -> runRisk(auxiliary, AUX, AUX_M)
        ; (Risk =:= 4) -> runRisk(rebellion, REB, REB_M)
        ; (Risk =:= 5) -> runRisk(diseaseOutbreak, DSOB, DSOB_M)
        ; (Risk =:= 6) -> runRisk(supplyChainIssue, SCI, SCI_M)
    ),
    retractall(riskAvailable), !.

% Risk Cheat
riskC :-
    isPlaying,
    \+ riskAvailable,
    slowWrite('\nAnda sudah memainkan RISK pada giliran ini!', 0.02),
    sleep(0.3),
    slowWrite('\nSilahkan memainkan RISK di giliran berikutnya.', 0.02),
    sleep(0.5), !.
riskC :-
    % Strings
    cfo(CFO),
    sso(SSO),
    aux(AUX),
    reb(REB),
    dsob(DSOB),
    sci(SCI),

    cfoM(CFO_M),
    ssoM(SSO_M),
    auxM(AUX_M),
    rebM(REB_M),
    dsobM(DSOB_M),
    sciM(SCI_M),

    % Program
    isPlaying,
    riskAvailable,

    slowWrite('\nSilahkan pilih kartu RISK yang ingin didapatkan: ', 0.02), sleep(0.3), nl,
    slowWrite('\n1. CEASEFIRE ORDER', 0.02), sleep(0.15),
    slowWrite('\n2. SUPER SOLDIER SERUM', 0.02), sleep(0.15),
    slowWrite('\n3. AUXILIARY TROOPS', 0.02), sleep(0.15),
    slowWrite('\n4. REBELLION', 0.02), sleep(0.15),
    slowWrite('\n5. DISEASE OUTBREAK', 0.02), sleep(0.15),
    slowWrite('\n6. SUPPLY CHAIN ISSUE', 0.02), sleep(0.15), nl,

    repeat,
    slowWrite('\nPilih: ', 0.02),
    read(Risk),
    (
        (Risk =< 0 ; Risk > 6)
        -> (
            slowWrite('\nPilihan tidak valid!', 0.02), sleep(0.2),
            slowWrite('\nSilahkan masukkan ulang pilihan.', 0.02), sleep(0.2),
            fail    
        )
        ; true
    ),

    (
        (Risk =:= 1) -> runRisk(ceasefire, CFO, CFO_M)
        ; (Risk =:= 2) -> runRisk(superSoldier, SSO, SSO_M)
        ; (Risk =:= 3) -> runRisk(auxiliary, AUX, AUX_M)
        ; (Risk =:= 4) -> runRisk(rebellion, REB, REB_M)
        ; (Risk =:= 5) -> runRisk(diseaseOutbreak, DSOB, DSOB_M)
        ; (Risk =:= 6) -> runRisk(supplyChainIssue, SCI, SCI_M)
    ),
    retractall(riskAvailable), !.

runRisk(Card, CardName, Message) :-
    player(P),
    Term =.. [Card, P],
    assertz(Term),

    slowFormat('\nPlayer ~w mendapatkan risk card ~w', [P, CardName], 0.02),
    sleep(0.5),
    slowWrite(Message, 0.02),
    sleep(0.5),
    ((rebellion(P)) -> rebel ; true).

rebel :-
    % Get random player
    player(P),
    playerList(L),

    % Loop while randomPlayer == currentPlayer
    repeat,
    randomList(L, RandomPlayer),
    ((RandomPlayer == P) -> fail ; true),

    % Get random player territory
    getPlayerTerritory(P, TerrList),
    randomList(TerrList, RandomTerr),

    % Pass territory to random player
    call(RandomTerr, P, TroopCount),
    Term =.. [RandomTerr, P, TroopCount],
    retractall(Term),
    NewTerm =.. [RandomTerr, RandomPlayer, TroopCount],
    assertz(NewTerm),

    % Finishing
    slowFormat('\n...Wilayah ~w sekarang dikuasai oleh player ~w!', [RandomTerr, RandomPlayer], 0.02), sleep(0.3),
    retractall(rebellion(P)),
    
    % Print player territories
    playerList(L),
    slowWrite('\nWilayah yang dikuasai:', 0.02),
    sleep(0.3), nl,
    printPlayerTerritories(L), nl,

    % Print current player
    player(P),
    slowFormat('\nSekarang giliran pemain: ~w', [P], 0.02),
    sleep(0.3), nl, !.