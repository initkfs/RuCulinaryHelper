/**
@author initkfs
*/

жидкость(вода).

клубнеплод(картофель).

корнеплод(морковь).
корнеплод(петрушка).
корнеплод(редис).
корнеплод(свекла).
корнеплод(сельдерей).
корнеплод(хрен).

капустный('капуста белокочанная').

бобовый(горох).
бобовый(фасоль).

луковый('лук зеленый').
луковый('лук репчатый').
луковый(чеснок).

пряность(горчица).
пряность(укроп).
пряность('лук зеленый').

специя(соль).

приправа(сметана).

тыквенный(кабачок).
тыквенный(огурец).

томатный(томат).
томатный('перец стручковый').
томатный(баклажан).

плодовый(X):- 
    томатный(X);
    тыквенный(X).

добавка(X):- 
    специя(X);
    пряность(X);
    приправа(X).

ингредиент(X):-
    добавка(X);
    жидкость(X);
    клубнеплод(X);
    корнеплод(X);
    капустный(X);
    бобовый(X);
    луковый(X);
    плодовый(X).