:- dynamic(playerCount/1).
:- dynamic(playerList/1).
:- dynamic(tentara/2).
:- dynamic(currentPlayer/1).

:- dynamic(wilayah/3).
:- dynamic(wilayahList/1).
:- dynamic(wilayahDiambil/1).

:- dynamic(na1/2). :- dynamic(na2/2). :- dynamic(na3/2). :- dynamic(na4/2). :- dynamic(na5/2).
:- dynamic(sa1/2). :- dynamic(sa2/2).
:- dynamic(e1/2). :- dynamic(e2/2). :- dynamic(e3/2). :- dynamic(e4/2). :- dynamic(e5/2).
:- dynamic(af1/2). :- dynamic(af2/2). :- dynamic(af3/2).
:- dynamic(a1/2). :- dynamic(a2/2). :- dynamic(a3/2). :- dynamic(a4/2). :- dynamic(a5/2). :- dynamic(a6/2). :- dynamic(a7/2).
:- dynamic(au1/2). :- dynamic(au2/2). 

% Global Variables
jumlahTentara([-1, 24, 16, 12]).
wilayahList([
    na1, na2, na3, na4, na5,
    sa1, sa2,
    e1, e2, e3, e4, e5,
    af1, af2, af3,
    a1, a2, a3, a4, a5, a6, a7,
    au1, au2    
]).
% wilayahList([
%     na1, na2, na3,% na4, na5,
%     sa1, sa2,
%     % e1, e2, e3, e4, e5,
%     % af1, af2, af3,
%     a1%, a2, a3, a4, a5, a6, a7,
%     % au1, au2    
% ]).
tetanggaList([
    % Tetangga: North America
    [na2, na3, a3], [na1, na4, na5], [na1, sa1, na4, a3], [na2, na3, na5], [na2, na4, e1],
    
    % Tetangga: South America
    [na3, sa2], [sa1, au2, af1],

    % Tetangga: Eropa
    [na5, e2, e3], [e1, e4, a1], [e1, e4, af1], [e2, e3, e5], [e4, af2, a4],

    % Tetangga: Afrika
    [sa2, e3, af2, af3], [af1, af3, e4, e5], [af1, af2],

    % Tetangga: Asia
    [e2, a4], [a4, a5, a6], [a5, na1, na3], [e5, a1, a2, a5, a6], [a2, a3, a4, a6], [a2, a4, a5, au1], [a6],

    % Tetangga: Australia
    [a6, au2], [au1, sa2]
]).
wilayahDiambil([]).

northAmerica([na1, na2, na3, na4, na5]).
southAmerica([sa1, sa2]).
europe([e1, e2, e3, e4, e5]).
africa([af1, af2, af3]).
asia([a1]).%, a2, a3, a4, a5, a6, a7]).
australia([au1, au2]).

na1(x, 0). na2(x, 0). na3(x, 0). na4(x, 0). na5(x, 0).
sa1(x, 0). sa2(x, 0).
e1(x, 0). e2(x, 0). e3(x, 0). e4(x, 0). e5(x, 0).
af1(x, 0). af2(x, 0). af3(x, 0).
a1(x, 0). a2(x, 0). a3(x, 0). a4(x, 0). a5(x, 0). a6(x, 0). a7(x, 0).
au1(x, 0). au2(x, 0). 

% Program
startGame :-
    % 1. Get player count
    getPlayerCount(N),
    slowFormat('Jumlah pemain: ~d\n\n', [N], 0.02),
    sleep(0.3),

    % 2. Get player list and get player order
    getPlayerList(N, PlayerList), nl,
    rollPlayerOrder(PlayerList, [], Order), nl, nl,
    max(Order, Max),
    getIndex(Order, Max, I),
    shift(PlayerList, I, [HeadNPL | TailNPL]), % NPL = NewPlayerList
    slowFormat('Urutan pemain: ~w ', [HeadNPL], 0.01),
    writePlayerOrder(TailNPL), nl,
    sleep(0.3),
    assertz(playerList([HeadNPL | TailNPL])),
    slowFormat('~w dapat mulai terlebih dahulu.\n', [HeadNPL], 0.01),
    % assertz(reinforcementCount(0)),
    % rollReinforcement([HeadNPL | TailNPL]),
    sleep(0.5),
    
    % 3. Initialize player troops
    jumlahTentara(JumlahTentara),
    getElement(JumlahTentara, N, NTroops),
    playerList(PList),
    initPlayerTroops(PList, NTroops),
    slowFormat('Setiap pemain mendapatkan ~d tentara.\n', [NTroops], 0.01),
    sleep(0.3),
    assertz(currentPlayer(1)),
    displayMap,
    slowFormat('\nGiliran ~w untuk memilih wilayahnya.\n', [HeadNPL], 0.01),
    sleep(0.4).

% Input player count
getPlayerCount(N) :-
    slowWrite('Masukkan jumlah pemain: ', 0.01), read(X),
    (X >= 2, X =< 4) 
        -> N = X, assertz(playerCount(N)); 
        (
            slowWrite('Mohon masukkan angka antara 2-4!\n', 0.01),
            getPlayerCount(N)
        ).

% Input player names
getPlayerList(N, Res) :-
    getPlayerListR(1, N, Res).

getPlayerListR(N, N, Res) :-
    slowFormat('Masukkan nama pemain ~d: ', [N], 0.02), 
    read(Nama),
    Res = [Nama], !.
getPlayerListR(I, N, Res) :-
    slowFormat('Masukkan nama pemain ~d: ', [I], 0.02), 
    read(Nama),
    Ir is I + 1,
    getPlayerListR(Ir, N, ResR),
    Res = [Nama | ResR].

% Roll for player order
rollPlayerOrder([], ListInt, ListInt) :- !.
rollPlayerOrder([Head | Tail], ListInt, ResListInt) :-
    roll(2, X),
    slowFormat('\n~w melempar dadu dan mendapatkan ~d', [Head, X], 0.02),
    sleep(0.3),
    appendList(ListInt, [X], NewListInt),
    rollPlayerOrder(Tail, NewListInt, ResListInt).

% Write new player order after rolling
writePlayerOrder([]) :- !.
writePlayerOrder([Head | Tail]) :-
    slowFormat('- ~w ', [Head], 0.01),
    writePlayerOrder(Tail).

% Initialize player troops to database
% PL = PlayerList
initPlayerTroops([], _) :- !.
initPlayerTroops([PLHead | PLTail], N) :-
    assertz(tentara(PLHead, N)),
    initPlayerTroops(PLTail, N).

% Each player take turns to choose territory
takeLocation(_) :-
    wilayahDiambil(W),
    count(W, N),
    N =:= 24,
    slowWrite('\nSemua wilayah sudah diambil!Silahkan lakukan pembagian sisa tentara.\n', 0.02), sleep(0,3),
    slowWrite('\nSilahkan lakukan pembagian sisa tentara.\n', 0.02), sleep(0.3), !.
takeLocation(Territory) :-
    wilayahList(WilayahList),
    wilayahDiambil(WilayahDiambil),
    getIndex(WilayahDiambil, Territory, _)
    -> (
        slowWrite('Wilayah sudah dikuasai!\nSilahkan masukkan kode wilayah lainnya: ', 0.02),
        read(NT), takeLocation(NT)    
    )
    ; 
    wilayahList(WilayahList),
    wilayahDiambil(WilayahDiambil),
    getIndex(WilayahList, Territory, _)
    -> (
        % Assert fact to database
        player(Player),
        Term =.. [Territory, _, _],
        retractall(Term),
        NewTerm =.. [Territory, Player, 1],
        assertz(NewTerm),
        slowFormat('~w mengambil wilayah ~w', [Player, Territory], 0.02),
        sleep(0.5),

        % Decrement player troop count
        tentara(Player, TroopCount),
        NewTroopCount is TroopCount - 1,
        retractall(tentara(Player, _)),
        assertz(tentara(Player, NewTroopCount)),

        % Add territory to wilayahDiambil
        appendList(WilayahDiambil, [Territory], NewWilayahDiambil),
        retractall(wilayahDiambil(_)),
        assertz(wilayahDiambil(NewWilayahDiambil)),

        count(NewWilayahDiambil, N),
        (N < 24) -> (            
            % Move to next player
            nextPlayer,
            player(NewPlayer),
            displayMap,
            slowFormat('\nGiliran ~w untuk memilih wilayahnya.\n', [NewPlayer], 0.02),
            sleep(0.5), !
        )
        ; (
            % Finish choosing territories
            nextPlayer,
            player(NewPlayer),
            displayMap,
            slowWrite('\nSeluruh wilayah telah diambil pemain.\n', 0.02),
            sleep(0.3),
            slowWrite('Memulai pembagian sisa tentara.', 0.02),
            sleep(0.3),
            slowFormat('\nGiliran ~w untuk meletakkan tentaranya.\n', [NewPlayer], 0.02),
            sleep(0.5), !
        )
    )
    ; (
        slowWrite('Wilayah tidak ditemukan!\n', 0.02), sleep(0.3),
        slowWrite('Silahkan masukkan ulang kode wilayah: ', 0.02),
        read(NewTerritory),
        takeLocation(NewTerritory)
    ).

% Distribute rest of troops
placeTroops(Terr, _) :-
    player(P),
    call(Terr, TerrOwner, _),
    TerrOwner \= P,
    slowWrite('Wilayah ini sudah dikuasai pemain lain!\n', 0.02),
    sleep(0.3),
    slowWrite('Silahkan menambah tentara di wilayah sendiri.\n', 0.02),
    sleep(0.3),
    slowFormat('\nGiliran ~w untuk memilih wilayahnya.\n', [P], 0.02), 
    sleep(0.5), !.

placeTroops(Terr, N) :-
    player(P),
    tentara(P, NTroops),
    (NTroops >= N)
    -> (
        placeTentara(Terr, N),
        tentara(P, NewNTroops),
        % format('~w meletakkan ~d tentara di wilayah ~w.\nTerdapat ~d tentara yang tersisa.\n', [P, N, Terr, NewNTroops]),
        slowFormat('\n~w meletakkan ~d tentara di wilayah ~w.', [P, N, Terr], 0.02),
        sleep(0.3),
        displayMap,
        slowFormat('\nTerdapat ~d tentara yang tersisa.\n', [NewNTroops], 0.02),
        sleep(0.5),
        (NewNTroops =:= 0)
        -> (
            slowFormat('\nSeluruh tentara ~w sudah diletakkan.\n', [P], 0.02),
            sleep(0.3),

            \+ checkFinish
            -> (            
                nextPlayer,
                player(NewPlayer),
                sleep(0.2),
                slowFormat('\nGiliran ~w untuk meletakkan tentaranya.\n', [NewPlayer], 0.02),
                sleep(0.5)
            )
            ; (
                slowWrite('\nSeluruh pemain telah meletakkan sisa tentara.', 0.02),
                sleep(0.5),
                slowWrite('\nPermainan dimulai!\n', 0.02),
                sleep(0.5),
                endTurnCont
            )
        )
    )
    ; slowWrite('Tentara yang anda miliki tidak cukup!\n', 0.02),
    sleep(0.5).

% Randomly distribute rest of troops
placeAutomatic :-
    player(Player),
    getPlayerTerritory(Player, TerrList),
    count(TerrList, TerrCount),
    tentara(Player, NTroops),
    (NTroops > 0) 
    -> (
        % Choose random territory
        TerrBound is TerrCount + 1,
        random(1, TerrBound, I),
        getElement(TerrList, I, TerrChoice),
        call(TerrChoice, Player, TerrTroops),

        % Randomize troop count placed
        NTroopsBound is NTroops + 1,
        (            
            (NTroops >= 5)
            -> (random(1, 6, NTroopsPlaced))
            ; (random(1, NTroopsBound, NTroopsPlaced)) 
        ),
        NewNTroops is (NTroops - NTroopsPlaced),
        NewTerrTroops is (TerrTroops + NTroopsPlaced),

        % Modify database
        Term =.. [TerrChoice, Player, _],
        retractall(Term),
        NewTerm =.. [TerrChoice, Player, NewTerrTroops],
        assertz(NewTerm),

        retractall(tentara(Player, _)),
        assertz(tentara(Player, NewNTroops)),

        % Repeat process
        slowFormat('\n~w meletakkan ~d tentara di wilayah ~w', [Player, NTroopsPlaced, TerrChoice], 0.02),
        sleep(0.3),
        placeAutomatic
    )
    ; (
        \+ checkFinish
        -> (            
            nextPlayer,
            player(NewPlayer),
            sleep(0.2),
            displayMap,
            slowFormat('\nGiliran ~w untuk meletakkan tentaranya.\n', [NewPlayer], 0.02),
            sleep(0.5)
        )
        ; (
            slowWrite('\nSeluruh pemain telah meletakkan sisa tentara.', 0.02),
            sleep(0.5),
            slowWrite('\nPermainan dimulai!\n', 0.02),
            sleep(0.5),
            endTurnCont
        )
    ).

% Check finished troop distribution
checkFinish :-
    currentPlayer(I),
    playerCount(N),
    (I =:= N).