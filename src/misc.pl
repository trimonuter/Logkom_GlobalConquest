% 1. roll(N) - roll N dices
roll(N, Res) :-
    Max is (N * 6) + 1,
    random(N, Max, Res).

% 2. player(X) - Get current player
player(X) :-
    currentPlayer(I),
    playerList(PL),
    getElement(PL, I, X).

% 3. nextPlayer - Move turn to next player
nextPlayer :-
    currentPlayer(I), playerCount(N),
    ((I < N) -> NewI is I + 1; NewI is 1),
    retractall(currentPlayer(_)),
    assertz(currentPlayer(NewI)).

% 4. getPlayerTerritory(Player, Res) - Get list of territories of a player
getPlayerTerritory(Player, Res) :-
    wilayahDiambil(W),
    getPlayerTerritoryR(Player, W, [], Res).

getPlayerTerritoryR(_, [], CurrRes, CurrRes) :- !.
getPlayerTerritoryR(Player, [Wilayah | Tail], CurrRes, Res) :-
    call(Wilayah, Player, _) -> (
        appendList(CurrRes, [Wilayah], NewCurrRes),
        getPlayerTerritoryR(Player, Tail, NewCurrRes, Res)
    ) ; getPlayerTerritoryR(Player, Tail, CurrRes, Res).

% 5. placeTentara(Terr, Count) - Place tentara to territory
placeTentara(Terr, N) :-
    % Delete fact from database
    player(Player),
    call(Terr, _, TroopCount), 
    Term =.. [Terr, _, TroopCount], 
    retractall(Term),

    % Create new fact
    NewTroopCount is TroopCount + N,
    NewTerm =.. [Terr, Player, NewTroopCount],
    assertz(NewTerm),

    % Subtract player troop count
    tentara(Player, TotalTroops),
    NewTotalTroops is TotalTroops - N,
    retractall(tentara(Player, _)),
    assertz(tentara(Player, NewTotalTroops)).

% 6. addTentara(N) - 
addTentara(N) :-
    player(P),
    tentara(P, TroopCount),
    retractall(tentara(P, _)),
    NewTroopCount is TroopCount + N,
    assertz(tentara(P, NewTroopCount)).

% 7. slowWrite(Text)
slowWrite(Text, Delay) :-
    % atom(Text)
    % -> (
    %     atom_codes(Text, CodeList),
    %     slowWriteR(CodeList, Delay)
    % )
    % ; (
    %     number_codes(Text, CodeList),    
    %     slowWriteR(CodeList, Delay)
    % ).

    write(Text).

slowWriteR([], _) :- !.
slowWriteR([Head | Tail], Delay) :-
    char_code(Char, Head),
    write(Char),
    flush_output,
    sleep(Delay),
    slowWriteR(Tail, Delay).

% 8. slowFormat(Text, List, Delay)
slowFormat(Text, List, Delay) :-
    % atom_codes(Text, CodeList),
    % slowFormatR(CodeList, List, 0, Delay).
    
    format(Text, List).

slowFormatR([], _, _, _) :- !.
slowFormatR([_ | Tail], [HList | TList], 1, Delay) :-
    slowWrite(HList, Delay),
    slowFormatR(Tail, TList, 0, Delay), !.

slowFormatR([Head | Tail], List, 0, Delay) :-
    (Head \= 126)
    -> (
        char_code(Char, Head),
        write(Char),
        flush_output,
        sleep(Delay),
        slowFormatR(Tail, List, 0, Delay)
    )
    ; slowFormatR(Tail, List, 1, Delay), !.

% 9. slowWriteList(List, Delay)
slowWriteList([], Delay) :-
    slowWrite('[', Delay),
    slowWriteListR([], Delay), !.

slowWriteList([Head | Tail], Delay) :-
    slowWrite('[', Delay),
    slowWrite(Head, Delay),
    slowWriteListR(Tail, Delay).

slowWriteListR([], Delay) :-
    slowWrite(']', Delay).
slowWriteListR([Head | Tail], Delay) :-
    slowWrite(', ', Delay),
    slowWrite(Head, Delay),
    flush_output,
    sleep(Delay),
    slowWriteListR(Tail, Delay).

% 10. min(A, B, Res) - Get min of A and B
min(A, B, Res) :-
    (A =< B)
    -> (Res = A)
    ; (Res = B).

% 11. getPercent(Num, Res) - Get percentage value of float
getPercent(Num, Res) :-
    NewNum is Num * 100,
    Res is round(NewNum).

% :- dynamic(pol/1).
% tes(Pre, Val) :-
%     Term =.. [Pre, Val],
%     assertz(Term). 