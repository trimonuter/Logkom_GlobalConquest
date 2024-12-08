% Napoleon Bonaparte
:- dynamic(napoleon/1).

% Genghis Khan
:- dynamic(genghis/1).
:- dynamic(genghis1/1).
:- dynamic(genghis2/1).

% Kanye West
:- dynamic(kanye/1).

% Check if continent is a subset of player's territory list
isDominating(Continent) :-
    player(P),
    getPlayerTerritory(P, TerrList),
    subset(TerrList, Continent).

isDominating(Continent, Player) :-
    getPlayerTerritory(Player, TerrList),
    subset(TerrList, Continent).

% Check if a player has lost all of their territories and is out from the game
checkLose(Player) :-
    getPlayerTerritory(Player, TerrList),
    count(TerrList, N),
    N =:= 0.