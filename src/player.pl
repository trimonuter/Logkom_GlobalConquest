playerCode([p1, p2, p3, p4]).
checkPlayerDetail(PlayerCode) :-
    % Nama
    playerCode(PC),
    playerList(PL),
    getIndex(PC, PlayerCode, I),
    getElement(PL, I, Nama),

    % Benua
    getDominatedContinents(Nama, DomCon),

    % Total Wilayah
    getPlayerTerritory(Nama, TerrList),
    count(TerrList, TotalWilayah),

    % Total Tentara Aktif
    getTotalTroops(Nama, TotalTroops),

    % Total Tentara Tambahan
    tentara(Nama, AddTroops),

    % Print output
    slowFormat('\nNama\t\t\t: ~w', [Nama], 0.02), sleep(0.3),
    slowFormat('\nBenua\t\t\t: ', [], 0.02), slowWriteList(DomCon, 0.02), sleep(0.3),
    slowFormat('\nTotal Wilayah\t\t: ~w', [TotalWilayah], 0.02), sleep(0.3),
    slowFormat('\nTotal Tentara Aktif\t: ~w', [TotalTroops], 0.02), sleep(0.3),
    slowFormat('\nTotal Tentara Tambahan\t: ~w', [AddTroops], 0.02), sleep(0.3).

checkPlayerTerritories(PlayerCode) :- 
    % Nama
    playerCode(PC),
    playerList(PL),
    getIndex(PC, PlayerCode, I),
    getElement(PL, I, Player),

    % Variables
    getPlayerTerritory(Player, TerrList),
    northAmerica(NA),
    southAmerica(SA),
    europe(EU),
    africa(AF),
    asia(AS),
    australia(AU),

    % Intersect
    intersectList(TerrList, NA, TerrNA), count(TerrNA, CountNA), count(NA, TotalNA),
    intersectList(TerrList, SA, TerrSA), count(TerrSA, CountSA), count(SA, TotalSA),
    intersectList(TerrList, EU, TerrEU), count(TerrEU, CountEU), count(EU, TotalEU),
    intersectList(TerrList, AF, TerrAF), count(TerrAF, CountAF), count(AF, TotalAF),
    intersectList(TerrList, AS, TerrAS), count(TerrAS, CountAS), count(AS, TotalAS),
    intersectList(TerrList, AU, TerrAU), count(TerrAU, CountAU), count(AU, TotalAU),

    % Print output
    slowFormat('\nNama\t\t: ~w', [Player], 0.02), sleep(0.3),
    printContinent(TerrNA, CountNA, TotalNA, 'Amerika Utara'),
    printContinent(TerrSA, CountSA, TotalSA, 'Amerika Selatan'),
    printContinent(TerrEU, CountEU, TotalEU, 'Eropa'),
    printContinent(TerrAF, CountAF, TotalAF, 'Afrika'),
    printContinent(TerrAS, CountAS, TotalAS, 'Asia'),
    printContinent(TerrAU, CountAU, TotalAU, 'Australia').

printContinent(TerrList, Count, Total, ContName) :-
    (Count > 0)
    -> (
        nl,
        slowFormat('\nBenua ~w (~d/~d)', [ContName, Count, Total], 0.02), sleep(0.3),
        printTerritories(TerrList),
        nl
    )
    ; true.

printTerritories([]) :- !.
printTerritories([Terr | TailTerr]) :-
    region(Terr, TerrCode, TerrName), nl,
    call(Terr, _, TroopCount),

    slowWrite(TerrCode, 0.02), sleep(0.3),
    slowFormat('\nNama\t\t\t: ~w', [TerrName], 0.02), sleep(0.3),
    slowFormat('\nJumlah Tentara\t\t: ~w', [TroopCount], 0.02), sleep(0.3),
    nl,

    printTerritories(TailTerr).

checkIncomingTroops(PlayerCode) :-
    % Nama
    playerCode(PC),
    playerList(PL),
    getIndex(PC, PlayerCode, I),
    getElement(PL, I, Player),

    % Total Wilayah
    getPlayerTerritory(Nama, TerrList),
    count(TerrList, TotalWilayah),
    
    % Tentara Tambahan
    count(TerrList, TerrCount),
    NewTroops is (TerrCount // 2),

    % Tentara Bonus
    northAmerica(NA),
    southAmerica(SA),
    europe(EU),
    africa(AF),
    asia(AS),
    australia(AU),

    (isDominating(NA, Player) -> BonusNA = 3 ; BonusNA = 0),
    (isDominating(SA, Player) -> BonusSA = 2 ; BonusSA = 0),
    (isDominating(EU, Player) -> BonusEU = 3 ; BonusEU = 0),
    (isDominating(AF, Player) -> BonusAF = 2 ; BonusAF = 0),
    (isDominating(AS, Player) -> BonusAS = 5 ; BonusAS = 0),
    (isDominating(AU, Player) -> BonusAU = 1 ; BonusAU = 0),
    TotalBonus is NewTroops + BonusNA + BonusSA + BonusEU + BonusAF + BonusAS + BonusAU,

    % Print output
    slowFormat('\n\nNama\t\t\t: ~w', [Player], 0.02), sleep(0.3),
    slowFormat('\nTotal Wilayah\t\t: ~w', [TotalWilayah], 0.02), sleep(0.3),
    slowFormat('\nTentara Tambahan\t: ~w', [NewTroops], 0.02), sleep(0.3),

    slowFormat('\nBonus - Amerika Utara\t: ~w',     [BonusNA], 0.02), sleep(0.3),
    slowFormat('\nBonus - Amerika Selatan\t: ~w',   [BonusSA], 0.02), sleep(0.3),
    slowFormat('\nBonus - Eropa\t\t: ~w',           [BonusEU], 0.02), sleep(0.3),
    slowFormat('\nBonus - Afrika\t\t: ~w',          [BonusAF], 0.02), sleep(0.3),
    slowFormat('\nBonus - Asia\t\t: ~w',            [BonusAS], 0.02), sleep(0.3),
    slowFormat('\nBonus - Australia\t: ~w',         [BonusAU], 0.02), sleep(0.3),
    slowFormat('\nTotal tentara tambahan\t: ~d',    [TotalBonus], 0.02), sleep(0.3).

% Additional functions
getDominatedContinents(Player, Res) :-
    northAmerica(NA),
    southAmerica(SA),
    europe(EU),
    africa(AF),
    asia(AS),
    australia(AU),

    getDomCon(Player, [NA, SA, EU, AF, AS, AU], ['North America', 'South America', 'Europe', 'Africa', 'Asia', 'Australia'], [], Res).

getDomCon(_, [], [], Res, Res) :- !.
getDomCon(Player, [CodeHead | CodeTail], [NameHead | NameTail], CurrRes, Res) :-
    (
        (isDominating(CodeHead, Player))
        -> append(CurrRes, [NameHead], NewCurrRes)
        ; append(CurrRes, [], NewCurrRes)    
    ),
    getDomCon(Player, CodeTail, NameTail, NewCurrRes, Res).

getTotalTroops(Player, Res) :-
    getPlayerTerritory(Player, TerrList),
    getTotalTroopsR(TerrList, 0, Res).

getTotalTroopsR([], Res, Res) :- !.
getTotalTroopsR([Head | Tail], Count, Res) :-
    call(Head, _, TroopCount),
    NewCount is Count + TroopCount,
    getTotalTroopsR(Tail, NewCount, Res).



% move(WilayahA, WilayahB, Totaltroops) :-
%     player(CurrentPlayer),
%     call(WilayahA, OwnerWilayahA, TroopsA),

%     (        
%         (OwnerWilayahA \= TroopsA) -> (
%             slowFormat('\n~w tidak memiliki wilayah ~w', [CurrentPlayer, WilayahA], 0.02),
%             slowWrite('\npemindahan dibatalkan', 0.02)
%         ) ; (Totaltroops > TroopsA) -> (
%             slowFormat('\n~w memindahkan ~d tentara dari ~w ke ~w', [CurrentPlayer, Totaltroops, WilayahA, WilayahB], 0.02),
%             slowWrite('\nTentara tidak mencukupi', 0.02),
%             slowWrite('\npemindahan dibatalkan', 0.02)
%         ) ; (
%             placeTentara(WilayahA, -Totaltroops),
%             placeTentara(WilayahB, Totaltroops),
%             call(WilayahA, OwnerWilayahA, TroopsA),
%             call(WilayahB, OwnerWilayahB, TroopsB),
%             slowFormat('\n~w memindahkan ~d tentara dari ~w ke ~w', [CurrentPlayer, Totaltroops, WilayahA, WilayahB], 0.02),
%             slowFormat('\nJumlah tentara di ~w: ~d', [WilayahA, TroopsA], 0.02),
%             slowFormat('\nJumlah tentara di ~w: ~d', [WilayahB, TroopsB], 0.02)
%         )
%     ).