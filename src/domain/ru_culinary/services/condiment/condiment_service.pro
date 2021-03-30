/**
@author initkfs
*/
:- module(condiment_service, [
    getCondimentsFor/2
]).

:- include('./../../database/culinary_condiments.pro').

getCondimentsFor(X, CondimentsList):-
    findall(Condiment, добавкаДля(Condiment, X), CondimentsList).

getCondimentsForCondiment(Condiment, CondimentsList):-
    findall(Y, добавкаКДобавке(Condiment, Y), CondimentsList).