% ========================================================
% Bagian III: List

% 1. List Statistic
% Min
min([H | T], Min) :- 
    minR(T, H, Min), !.

minR([], X, X) :- !.
minR([H | T], CurrMin, Min) :- 
    H >= CurrMin, minR(T, CurrMin, Min).
minR([H | T], CurrMin, Min) :- 
    H < CurrMin, minR(T, H, Min).

% Max
max([H | T], Max) :- 
    maxR(T, H, Max), !.

maxR([], X, X) :- !.
maxR([H | T], CurrMax, Max) :- 
    H >= CurrMax, maxR(T, H, Max).
maxR([H | T], CurrMax, Max) :- 
    H < CurrMax, maxR(T, CurrMax, Max).

% Range
range(L, Range) :-
    max(L, Max), min(L, Min), Range is Max - Min.

% Count
count([], 0) :- !.
count([_ | T], Count) :-
    count(T, CountT),
    Count is 1 + CountT.

% Sum
sum([], 0) :- !.
sum([H | T], Sum) :-
    sum(T, SumT),
    Sum is H + SumT.

% 2. List Manipulation
% a. Get Index
getIndex([H | _], H, 1) :- !.
getIndex([_ | T], X, Index) :-
    getIndex(T, X, IndexR),
    Index is 1 + IndexR.

% b. Get Element
getElement([H | _], 1, Element) :- Element = H, !.
getElement([_ | T], I, Element) :-
    I > 0, !,
    NewI is I - 1, getElement(T, NewI, Element).

% c. Swap
appendList([], X, X) :- !.
appendList([A|B], C, [A|D]) :- appendList(B, C, D).

swap(List, I1, I2, Res) :-
    I1 > 0, I2 > 0,
    getElement(List, I1, X1), getElement(List, I2, X2),
    swapR(List, 1, I1, I2, X1, X2, [], Res), !.

swapR([], _, _, _, _, _, CurrRes, CurrRes) :- !.
swapR([_ | T], Index, I1, I2, X1, X2, CurrRes, Res) :-
    Index = I1,
    NewIndex is Index + 1,
    appendList(CurrRes, [X2], NewRes),
    swapR(T, NewIndex, I1, I2, X1, X2, NewRes, Res).
swapR([_ | T], Index, I1, I2, X1, X2, CurrRes, Res) :-
    Index = I2,
    NewIndex is Index + 1,
    appendList(CurrRes, [X1], NewRes),
    swapR(T, NewIndex, I1, I2, X1, X2, NewRes, Res).
swapR([H | T], Index, I1, I2, X1, X2, CurrRes, Res) :-
    Index \= I1, Index \= I2,
    NewIndex is Index + 1,
    appendList(CurrRes, [H], NewRes),
    swapR(T, NewIndex, I1, I2, X1, X2, NewRes, Res).

% d. Slice
indexInRange(Index, I1, I2) :- Index >= I1, Index < I2.

slice(List, I1, I2, Res) :-
    sliceR(List, 1, I1, I2, [], Res).

sliceR([], _, _, _, CurrRes, CurrRes) :- !.
sliceR([H | T], Index, I1, I2, CurrRes, Res) :-
    NewIndex is Index + 1,
    (indexInRange(Index, I1, I2) -> Append = [H] ; Append = []),
    appendList(CurrRes, Append, NewRes),
    sliceR(T, NewIndex, I1, I2, NewRes, Res).

% e. Sort
% Sorting Method: Selection Sort
sortList([], []) :- !.
sortList(List, Res) :-
    min(List, Min),                         % Get min of list
    getIndex(List, Min, IMin),              % get index(min)
    swap(List, 1, IMin, [Min | Tail]),      % swap(index1, index(min))
    sortList(Tail, ResR),                   % sort(Tail)
    Res = Min | ResR.                       % Result = [Min | sort(Tail)]

% ==============================================
% Additional Functions
% 1. shift(List, NewStart, Res) - Circular shift
shift(List, NewStart, Res) :-
    slice(List, 1, NewStart, L1),
    count(List, N),
    Nb is N + 1,
    slice(List, NewStart, Nb, L2),
    appendList(L2, L1, Res).

% 2. remove(List, X, ResList) - Removes X from list
remove(List, X, ResList) :-
    getIndex(List, X, I),
    slice(List, 1, I, L1),
    I2 is I + 1,
    count(List, C),
    C2 is C + 1,
    slice(List, I2, C2, L2),
    appendList(L1, L2, ResList).

% 3. subset(List, Sublist) - Checks if Sublist is a sublist of List
subset(_, []) :- !.
subset(List, [SLHead | SLTail]) :-
    getIndex(List, SLHead, _),
    subset(List, SLTail).

% 4. writeList(List) - Writes contents of list
writeList(List) :- writeListR(List, 1).

writeListR([], _) :- !.
writeListR([Head | Tail], N) :-
    slowFormat('\n~d. ~w', [N, Head], 0.02),
    sleep(0.35),
    NewN is N + 1,
    writeListR(Tail, NewN).

% randomList(List, Res) - Get random element of list
randomList(List, Res) :-
    count(List, N),
    Ni is N + 1,
    random(1, Ni, R),
    getElement(List, R, Res).

% intersectList - Get intersect of two lists
isMember(X, [X | _]) :- !.
isMember(X, [_ | Tail]) :-
    isMember(X, Tail).

intersectList(ListA, ListB, Res):-
    intersectListR(ListA, ListB, [], Res).

intersectListR([], _, Res, Res) :- !.
intersectListR([A | TailA], ListB, CurrRes, Res) :-
    (
        isMember(A, ListB)
        -> Append = [A]
        ; Append = []
    ),
    appendList(CurrRes, Append, NewCurrRes),
    intersectListR(TailA, ListB, NewCurrRes, Res).