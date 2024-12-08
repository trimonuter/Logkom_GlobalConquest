% 1. Factorial
factorial(0, 1) :- !.
factorial(N, Res) :-
    Nr is N - 1,
    factorial(Nr, ResR),
    Res is N * ResR.

% 2. Permute(N, R)
permute(_, 0, 1) :- !.
permute(N, 1, N) :- !.
permute(N, R, Res) :-
    Nr is N - 1,
    Rr is R - 1,
    permute(Nr, Rr, ResR),
    Res is N * ResR.
% permute(N, R, Res) :-
%     Counter is N - R,
%     permuteR(N, Counter, Res), !.
%     % Res is round(ResR), !.

% permuteR(N, 0, Res) :-
%     factorial(N, Res), !.
% permuteR(N, R, Res) :-
%     Nr is N - 1,
%     Rr is R - 1,
%     permuteR(Nr, Rr, ResR),
%     Res is ((N / R) * ResR).

% 2. Choose (combination)
% choose(N, R, Res) :-
%     factorial(N, Nf),
%     factorial(R, Rf),
%     NR is N - R,
%     factorial(NR, NRf),
%     Res is round(Nf / (Rf * NRf)).
choose(N, R, Res) :-
    % % Find min of R and N - R
    % Nr is N - R,
    % min(R, Nr, Min),
    
    % % Calculate value
    permute(N, R, PermF),
    factorial(R, Rf),
    Res is round(PermF / Rf).

% 3. Exponent (A^X)
exp(_, 0, 1) :- !.
exp(A, X, Res) :-
    Xr is X - 1,
    exp(A, Xr, ResR),
    Res is A * ResR.

% 4. Sigma1 - Sigma function with 1 variable
sigma(Func, I, IEnd, Res) :-
    I =:= IEnd,
    call(Func, I, ResFunc),
    Res is ResFunc.

sigma(Func, I, IEnd, Res) :-
    call(Func, I, ResFunc),
    NewI is I + 1,
    sigma(Func, NewI, IEnd, ResR),
    Res is ResFunc + ResR, !.

% 5. Sigma3 - Sigma function with 3 variables
sigma3(Func, I, IEnd, N, S, Res) :-
    I =:= IEnd,
    call(Func, I, N, S, ResFunc),
    Res is ResFunc.

sigma3(Func, I, IEnd, N, S, Res) :-
    call(Func, I, N, S, ResFunc),
    NewI is I + 1,
    sigma3(Func, NewI, IEnd, N, S, ResR),
    Res is ResFunc + ResR, !.

% 6. pInner - Sigma function for p(N, S)
pInner(I, N, S, Res) :-
    exp(-1, I, ProdA),
    choose(N, I, ProdB),
    
    % ProdC
    I6 is I * 6,
    NProdC is S - I6 - 1,
    RProdC is N - 1,
    choose(NProdC, RProdC, ProdC),
    Res is ProdA * ProdB * ProdC.

% 7. p(N, S) - Probability of rolling N dices result in a sum exactly equal to S
p(N, S, Res) :-
    exp(6, N, Div),
    UpperBound is floor((S - N) / 6),
    sigma3(pInner, 0, UpperBound, N, S, SigmaRes),
    Res is (SigmaRes / Div), !.

% 8. lInner - Sigma function for l(N, S)
lInner(I, N, S, Res) :-
    exp(-1, I, ProdA),
    choose(N, I, ProdB),
    
    % ProdC
    I6 is I * 6,
    NProdC is S - I6 - 1,
    choose(NProdC, N, ProdC),
    Res is ProdA * ProdB * ProdC.

% 9. l(N, S) - probability of rolling N dices result in a sum less than S
l(N, S, Res) :-
    N >= S,
    Res = 0, !.

l(N, S, Res) :-
    exp(6, N, Div),
    UpperBound is floor((S - N - 1) / 6),
    sigma3(lInner, 0, UpperBound, N, S, SigmaRes),
    Res is (SigmaRes / Div), !.

% 10. wpInner - Sigma function for winProbability
wpInner(S, N, M, Res) :-
    p(N, S, ResN),
    l(M, S, ResM),
    Res is (ResN * ResM).

% 11. winProbability(N, M) - Probability of (sum of N dices) > (sum of M dices)
winProbability(N, M, Res) :-
    UpperBound is (6 * N),
    sigma3(wpInner, N, UpperBound, N, M, Res), !.