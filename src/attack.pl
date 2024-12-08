attack :-
    isPlaying,
    \+ attackAvailable,
    slowWrite('\nAnda sudah menyerang pada giliran ini!', 0.02),
    sleep(0.3),
    slowWrite('\nSilahkan melakukan serangan di giliran berikutnya.', 0.02),
    sleep(0.5), !.

attack :-
    % Initialization
    isPlaying,
    attackAvailable,
    player(P),
    slowFormat('\nSekarang giliran player ~w menyerang.', [P], 0.02),
    sleep(0.3),
    displayMap,

    % Choose starting territory
    repeat,
    slowWrite('\nPilihlah daerah yang ingin anda kirim untuk bertempur: ', 0.01),
    read(Terr),
    wilayahList(L),
    (
        \+ getIndex(L, Terr, _)
        -> (
            slowWrite('\nDaerah yang dipilih tidak valid!', 0.02),
            sleep(0.3),
            slowWrite('\nSilahkan input kembali daerah yang ingin dipilih.\n', 0.02),
            sleep(0.3),
            fail
        )    
        ; (\+ call(Terr, P, _))
        -> (
            slowWrite('\nDaerah ini bukan milik anda!', 0.02),
            sleep(0.3),
            slowWrite('\nSilahkan input kembali daerah yang ingin dipilih.\n', 0.02),
            sleep(0.3),
            fail
        )
        ; true
    ),

    % Choose number of troops to send
    slowFormat('\nPlayer ~w ingin memulai penyerangan dari daerah ~w', [P, Terr], 0.02),
    sleep(0.3),
    call(Terr, P, NTroops),
    slowFormat('\nDalam daerah ~w, anda memiliki sebanyak ~d tentara.', [Terr, NTroops], 0.02),
    sleep(0.3),

    % Loop for incorrect troop number handling
    repeat,
    slowWrite('\n\nMasukkan banyak tentara yang akan bertempur: ', 0.02),
    read(N),
    (

        (N > NTroops)
        -> (
            slowFormat('\nJumlah tentara yang anda miliki di wilayah ~w tidak mencukupi!', [Terr], 0.02),
            sleep(0.3),
            slowWrite('\nSilahkan memasukkan ulang jumlah tentara yang ingin dikirim.', 0.02),
            sleep(0.2),
            fail
        )
        ; (N =:= NTroops)
        -> (
            slowFormat('\nAnda harus menyisakan paling sedikit 1 orang tentara untuk menjaga wilayah ~w!', [Terr], 0.02),
            sleep(0.3),
            slowWrite('\nSilahkan memasukkan ulang jumlah tentara yang ingin dikirim.', 0.02),
            sleep(0.2),
            fail
        )
        ; true    
    ),
    slowFormat('Player ~w mengirim sebanyak ~d tentara untuk bertempur.', [P, N], 0.02),
    sleep(0.3),

    % Choose territory to attack
    displayMap,
    slowWrite('\nDaerah tetangga yang dapat diserang:', 0.02),
    sleep(0.3), nl,

    getIndex(L, Terr, ITerr),
    tetanggaList(TL),
    getElement(TL, ITerr, Neighbors),
    wilayahList(L),

    (
        (genghis(P)) 
            -> (removeNonEnemyNeighbor(L, [], NewNeighbors))
            ; (removeNonEnemyNeighbor(Neighbors, [], NewNeighbors))
    ),
    writeListAttack(NewNeighbors, N),
    sleep(0.3),
    
    count(NewNeighbors, Count),
    (
        (Count =:= 0)
        -> (
            slowWrite('\nTidak terdapat wilayah musuh yang dapat diserang.', 0.02), sleep(0.3),
            slowWrite('\nSilahkan pilih wilayah lainnya untuk dikirim bertempur.', 0.02), sleep(0.3),    
            abort
        )
        ; true
    ),

    repeat,
    slowWrite('\n\nPilih wilayah yang ingin diserang (angka): ', 0.02),
    read(T),
    (
        (\+ number(T))
        -> (
            slowWrite('\nInput harus dalam bentuk angka!', 0.02), sleep(0.3),
            slowWrite('\nSilahkan masukkan ulang wilayah yang ingin diserang.', 0.02),
            sleep(0.3),
            fail 
        )
        ; (T < 1 ; T > Count)
        -> (
            slowWrite('\nPilihan wilayah anda tidak tersedia!', 0.02), sleep(0.3),
            slowWrite('\nSilahkan masukkan ulang wilayah yang ingin diserang.', 0.02),
            sleep(0.3),
            fail
        )
        ; true
    ),
    slowWrite('\nWilayah yang ingin diserang berhasil dipilih.', 0.02), sleep(0.3),
    slowWrite('\nPerang dimulai!', 0.02), sleep(0.3),

    % Initiate battle
    getElement(NewNeighbors, T, AttackedTerr),
    call(AttackedTerr, AttackedPlayer, N_Attacked),

    slowFormat('\nPlayer ~w', [P], 0.02), sleep(0.3),
    rollDiceAttack(N, RollRes_Attacking, P),

    slowFormat('\nPlayer ~w', [AttackedPlayer], 0.02), sleep(0.3),
    rollDiceAttack(N_Attacked, RollRes_Attacked, AttackedPlayer),

    % Process result of battle
    (
        (RollRes_Attacking > RollRes_Attacked)
        -> (
            slowFormat('\n\nPlayer ~w menang! Wilayah ~w sekarang dikuasai oleh player ~w.', [P, AttackedTerr, P], 0.02), sleep(0.3),

            repeat,
            slowWrite('\nMasukkan banyak tentara yang ingin dikirim ke wilayah tersebut: ', 0.02),
            read(N_Send),
            (
                (\+ number(N_Send) ; N_Send =< 0)    
                -> (
                    slowWrite('\nJumlah tentara yang anda masukkan tidak valid!', 0.02), sleep(0.3),
                    fail   
                )
                ; (N_Send > N)
                -> (
                    slowWrite('\nJumlah tentara yang dikirim tidak boleh lebih dari jumlah tentara yang berperang!', 0.02), sleep(0.3),
                    fail    
                ) ; true
            ),

            NegN_Send is N_Send * -1,
            placeTentara(Terr, NegN_Send),

            NegN_Attack is N_Attacked * -1,
            placeTentara(AttackedTerr, NegN_Attack),
            placeTentara(AttackedTerr, N_Send),

            call(Terr, _, NewN_A),
            call(AttackedTerr, _, NewN_B),

            slowFormat('\nTentara di wilayah ~w: ~d', [Terr, NewN_A], 0.02), sleep(0.3),
            slowFormat('\nTentara di wilayah ~w: ~d', [AttackedTerr, NewN_B], 0.02), sleep(0.3),

            % WORLD LEADER: Genghis Khan
            asia(Asia),
            (isDominating(Asia) -> assertz(genghis1(P)) ; retractall(genghis1(P))),
            (checkLose(AttackedPlayer) -> assertz(genghis2(P)) ; true),
            (
                (genghis1(P), genghis2(P), \+ genghis(_))
                -> (
                    slowFormat('\nPemain ~w berhasil menamatkan semua secret mission salah satu WORLD LEADER!', [P], 0.02), sleep(0.3),
                    slowWrite('\nPemain mendapatkan WORLD LEADER: GENGHIS KHAN.', 0.02), sleep(0.3),
                    assertz(genghis(P))
                )    
                ; true
            )
        )
        ; (
            slowFormat('\n\nPlayer ~w menang! Sayang sekali penyerangan anda gagal :(', [AttackedPlayer], 0.02), sleep(0.3),

            NegN is N * -1,
            placeTentara(Terr, NegN),

            call(Terr, _, N_A),
            call(AttackedTerr, _, N_B),

            slowFormat('\nTentara di wilayah ~w: ~d', [Terr, N_A], 0.02), sleep(0.3),
            slowFormat('\nTentara di wilayah ~w: ~d', [AttackedTerr, N_B], 0.02), sleep(0.3)
        )
    ),
    displayMap,

    % Delete ability to attack again
    retractall(attackAvailable), !.

% Get neighbors of a territory
getNeighbors(Terr, Res) :-
    wilayahList(L),
    getIndex(L, Terr, I),
    
    tetanggaList(TL),
    getElement(TL, I, Res).

% Remove neighbors that is owned by the current player from neighbor list
removeNonEnemyNeighbor([], CurrRes, CurrRes) :- !.
removeNonEnemyNeighbor([Head | Tail], CurrRes, Res) :-
    player(P),
    call(Head, TerrOwner, _),
    (
        (TerrOwner == P) -> Append = [] 
        ; ceasefire(TerrOwner) -> Append = [] % Handling for Risk: CEASEFIRE ORDER
        ; Append = [Head]  
    ),
    appendList(CurrRes, Append, NewCurrRes),
    removeNonEnemyNeighbor(Tail, NewCurrRes, Res).

% Function for rolling dices for attacking
rollDiceAttack(N, Res, Player) :-
    rollDiceAttackR(1, N, 0, Res, Player),
    slowFormat('\nTotal: ~d\n', [Res], 0.02),
    sleep(0.3).

rollDiceAttackR(I, N, CurrSum, Res, _) :-
    I > N,
    Res = CurrSum, !.
rollDiceAttackR(I, N, CurrSum, Res, Player) :-
    (
        (superSoldier(Player)) -> RollRes is 6          % Handler for RISK: SUPER SOLDIER SERUM
        ; (diseaseOutbreak(Player)) -> RollRes is 1     % Handler for RISK: DISEASE OUTBREAK
        ; roll(1, RollRes)
    ),
    
    slowFormat('\nDadu ~d: ~d', [I, RollRes], 0.02),
    sleep(0.3),

    NewI is I + 1,
    NewCurrSum is CurrSum + RollRes,
    rollDiceAttackR(NewI, N, NewCurrSum, Res, Player).

% Write territory list for attacking (with win probabilities)
writeListAttack(List, NTroops) :- writeListAttackR(List, 1, NTroops).

writeListAttackR([], _, _) :- !.
writeListAttackR([Head | Tail], N, NTroops) :-
    call(Head, _, TroopsAttacked),
    winProbability(NTroops, TroopsAttacked, Chance),
    getPercent(Chance, ChancePercent),
    
    slowFormat('\n~d. ~w (~d percent win chance)', [N, Head, ChancePercent], 0.02),
    sleep(0.35),
    NewN is N + 1,
    writeListAttackR(Tail, NewN, NTroops).