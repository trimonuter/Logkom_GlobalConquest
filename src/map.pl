% slowFormatMap
slowFormatMap(Text, List, Delay) :-
    atom_codes(Text, CodeList),
    slowFormatMapR(CodeList, List, 0, 0, Delay).

slowFormatMapR([], _, _, _, _) :- !.
slowFormatMapR([_ | Tail], [HList | TList], 1, DelBlank, Delay) :-
    slowWrite(HList, Delay),
    ((HList >= 10) -> (NewDelBlank is DelBlank + 1) ; (NewDelBlank is DelBlank)),
    slowFormatMapR(Tail, TList, 0, NewDelBlank, Delay), !.

slowFormatMapR([Head | Tail], List, 0, DelBlank, Delay) :-
    (Head \= 126)
    -> (
        (DelBlank > 0, ((Head =:= 32) ; (Head =:= 45)))
        -> (
            NewDelBlank is DelBlank - 1,
            slowFormatMapR(Tail, List, 0, NewDelBlank, Delay)
        )
        ; (            
            char_code(Char, Head),
            write(Char),
            flush_output,
            sleep(Delay),
            slowFormatMapR(Tail, List, 0, DelBlank, Delay)
        )
    )
    ; slowFormatMapR(Tail, List, 1, DelBlank, Delay), !.

% displayMap
% displayMap :-
%     na1(_, NA1), na2(_, NA2), na3(_, NA3), na4(_, NA4), na5(_, NA5),
%     sa1(_, SA1), sa2(_, SA2),
%     e1(_, E1), e2(_, E2), e3(_, E3), e4(_, E4), e5(_, E5),
%     af1(_, AF1), af2(_, AF2), af3(_, AF3),
%     a1(_, A1), a2(_, A2), a3(_, A3), a4(_, A4), a5(_, A5), a6(_, A6), a7(_, A7),
%     au1(_, AU1), au2(_, AU2),
%     MapDelay is 0.0001,

%     write('\n'),
%     slowFormatMap('\n#################################################################################################', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#         North America         #        Europe         #                 Asia                  #', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#                               #                       #                                       #', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#       [NA1(~d)]-[NA2(~d)]       #                       #                                       #', [NA1, NA2], MapDelay), sleep(0.05),
%     slowFormatMap('\n-----------|       |----[NA5(~d)]----[E1(~d)]-[E2(~d)]----------[A1(~d)] [A2(~d)] [A3(~d)]-------------', [NA5, E1, E2, A1, A2, A3], MapDelay), sleep(0.05),
%     slowFormatMap('\n#       [NA3(~d)]-[NA4(~d)]       #       |       |       #        |       |       |              #', [NA3, NA4], MapDelay), sleep(0.05),
%     slowFormatMap('\n#          |                    #    [E3(~d)]-[E4(~d)]    ####     |       |       |              #', [E3, E4], MapDelay), sleep(0.05),
%     slowFormatMap('\n###########|#####################       |       |-[E5(~d)]-----[A4(~d)]----+----[A5(~d)]           #', [E5, A4, A5], MapDelay), sleep(0.05),
%     slowFormatMap('\n#          |                    ########|#######|###########             |                      #', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#       [SA1(~d)]                #       |       |          #             |                      #', [SA1], MapDelay), sleep(0.05),
%     slowFormatMap('\n#          |                    #       |    [AF2(~d)]      #          [A6(~d)]---[A7(~d)]         #', [AF2, A6, A7], MapDelay), sleep(0.05),
%     slowFormatMap('\n#   |---[SA2(~d)]---------------------[AF1(~d)]---|          #             |                      #', [SA2, AF1], MapDelay), sleep(0.05),
%     slowFormatMap('\n#   |                           #               |          ##############|#######################', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#   |                           #            [AF3(~d)]      #             |                      #', [AF3], MapDelay), sleep(0.05),
%     slowFormatMap('\n----|                           #                          #          [AU1(~d)]---[AU2(~d)]--------', [AU1, AU2], MapDelay), sleep(0.05),
%     slowFormatMap('\n#                               #                          #                                    #', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#       South America           #         Africa           #          Australia                 #', [], MapDelay), sleep(0.05),
%     slowFormatMap('\n#################################################################################################', [], MapDelay), sleep(0.75), nl, !.

displayMap :-
    na1(_, NA1), na2(_, NA2), na3(_, NA3), na4(_, NA4), na5(_, NA5),
    sa1(_, SA1), sa2(_, SA2),
    e1(_, E1), e2(_, E2), e3(_, E3), e4(_, E4), e5(_, E5),
    af1(_, AF1), af2(_, AF2), af3(_, AF3),
    a1(_, A1), a2(_, A2), a3(_, A3), a4(_, A4), a5(_, A5), a6(_, A6), a7(_, A7),
    au1(_, AU1), au2(_, AU2),

    write('\n'),
    format('\n#################################################################################################', []),
    format('\n#         North America         #        Europe         #                 Asia                  #', []),
    format('\n#                               #                       #                                       #', []),
    format('\n#       [NA1(~d)]-[NA2(~d)]       #                       #                                       #', [NA1, NA2]),
    format('\n-----------|       |----[NA5(~d)]----[E1(~d)]-[E2(~d)]----------[A1(~d)] [A2(~d)] [A3(~d)]-------------', [NA5, E1, E2, A1, A2, A3]),
    format('\n#       [NA3(~d)]-[NA4(~d)]     #       |       |       #        |       |       |              #', [NA3, NA4]),
    format('\n#          |                    #    [E3(~d)]-[E4(~d)]    ####     |       |       |              #', [E3, E4]),
    format('\n###########|#####################       |       |-[E5(~d)]-----[A4(~d)]----+----[A5(~d)]           #', [E5, A4, A5]),
    format('\n#          |                    ########|#######|###########             |                      #', []),
    format('\n#       [SA1(~d)]               #       |       |          #             |                      #', [SA1]),
    format('\n#          |                    #       |    [AF2(~d)]      #          [A6(~d)]---[A7(~d)]         #', [AF2, A6, A7]),
    format('\n#   |---[SA2(~d)]---------------------[AF1(~d)]---|          #             |                      #', [SA2, AF1]),
    format('\n#   |                           #               |          ##############|#######################', []),
    format('\n#   |                           #            [AF3(~d)]      #             |                      #', [AF3]),
    format('\n----|                           #                          #          [AU1(~d)]---[AU2(~d)]--------', [AU1, AU2]),
    format('\n#                               #                          #                                    #', []),
    format('\n#       South America           #         Africa           #          Australia                 #', []),
    format('\n#################################################################################################', []), nl, !,

    % Print player territories
    playerList(L),
    slowWrite('\nWilayah yang dikuasai:', 0.02),
    sleep(0.3), nl,
    printPlayerTerritories(L), nl,

    % Print current player
    player(P),
    slowFormat('\nSekarang giliran pemain: ~w', [P], 0.02),
    sleep(0.3), nl, !.

:- dynamic(playerGugur/1).

printPlayerTerritories([]) :-
    playerGugur(P),
    playerList(L),
    slowWrite('\n', 0.02),

    % Update database
    slowFormat('\nPlayer ~w telah gugur dari permainan!', [P], 0.02), sleep(0.3),
    remove(L, P, NewL),
    retractall(playerList(_)),
    assertz(playerList(NewL)),

    playerCount(N),
    NewN is N - 1,
    retractall(playerCount(_)),
    assertz(playerCount(NewN)),

    % Print new player list
    slowWrite('\nPemain yang tersisa: ', 0.02),
    playerList(NewPlayerList),
    slowWriteList(NewPlayerList, 0.02), sleep(0.3),
    retractall(playerGugur(_)), !.

printPlayerTerritories([]) :- !.
printPlayerTerritories([PHead | PTail]) :-
    getPlayerTerritory(PHead, L),
    slowFormat('\n~w: ', [PHead], 0.02),
    slowWriteList(L, 0.02),
    sleep(0.3),
    count(L, TerrCount),
    (
        (TerrCount =:= 0, isPlaying) -> (assertz(playerGugur(PHead)))
        ; (TerrCount =:= 1, hasReinforcement(PHead), isPlaying) -> (assertz(playerGugur(PHead)))
        ; true
    ),
    printPlayerTerritories(PTail).