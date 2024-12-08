% Facts for location codes
region(na1, 'NA2', 'Panama').
region(na2, 'NA1', 'Greenland').
region(na3, 'NA3', 'Grenada').
region(na4, 'NA4', 'Nikaragua').
region(na5, 'NA5', 'El Savador').
region(e1, 'E1', 'Prancis').
region(e2, 'E2', 'Italia').
region(e3, 'E3', 'Inggris').
region(e4, 'E4', 'Jerman').
region(e5, 'E5', 'Belanda').
region(a1, 'A1', 'Indonesia').
region(a2, 'A2', 'Malaysia').
region(a3, 'A3', 'Singapura').
region(a4, 'A4', 'Thailand').
region(a5, 'A5', 'Myanmar').
region(a6, 'A6', 'Saudi Arabia').
region(a7, 'A7', 'Jepang').
region(sa1, 'SA1', 'Brazil').
region(sa2, 'SA2', 'Argentina').
region(af1, 'AF1', 'Maroko').
region(af2, 'AF2', 'Nigeria').
region(af3, 'AF3', 'Kenya').
region(au1, 'AU1', 'Australia').
region(au2, 'AU2', 'Selandia Baru').

% Fungsi untuk memeriksa detail wilayah
checkLocationDetail(Location) :- 
    % Mendapatkan kode dan nama wilayah
    region(Location, Kode, Nama)
    -> (        
        % Memeriksa fakta-fakta wilayah
        call(Location, Owner, Troops),
        getNeighbors(Location, TetanggaList),
        getNeighborNames(TetanggaList, TetanggaListNames),
    
        % Menampilkan detail wilayah
        slowFormat('\nKode\t\t: ~w', [Kode], 0.02), sleep(0.3),
        slowFormat('\nNama\t\t: ~w', [Nama], 0.02), sleep(0.3),
        slowFormat('\nPemilik\t\t: ~w', [Owner], 0.02), sleep(0.3),
        slowFormat('\nTotal Tentara\t: ~w', [Troops], 0.02), sleep(0.3),
        slowFormat('\nTetangga\t: ~w', [TetanggaListNames], 0.02), sleep(0.3)
    )
    ; slowWrite('\nKode wilayah tidak ditemukan!', 0.02), sleep(0.3).

getNeighborNames(List, Res) :-
    getNeighborNamesR(List, [], Res), !.

getNeighborNamesR([], Res, Res) :- !.
getNeighborNamesR([Head | Tail], CurrRes, Res) :-
    region(Head, _, Nama),
    append(CurrRes, [Nama], NewCurrRes),
    getNeighborNamesR(Tail, NewCurrRes, Res).

% move(WilayahA, WilayahB, N) :-
%     player(CurrentPlayer), % ngambil current player
%     call(WilayahA, OwnerWilayahA, TroopsA)
%     % if (OwnerWilayahA != CurrentPlayer)
%     (OwnerWilayahA \= CurrentPlayer)
%     -> (
%         'Anda tidak memiliki wilayah ini'
%     )
%     % else if (TroopsA < N)
%     ; (TroopsA < N) 
%     -> (
%         'Tentara tidak mencukupi'    
%     )
%     % else 
%     ; (
%     )