/**
@author initkfs
*/
:- module(condiment_service, [
    getCondimentsFor/2
]).

:- use_module('src/core/explain/explainer.pro').
:- include('./../../database/culinary_condiments.pro').

getCondimentsFor(X, CondimentsList):-
    findall(Condiment, добавкаДля(Condiment, X), CondimentsList),
    prolog_current_frame(Frame),
    explainer:explainI18nForVarValue(Frame, "culinaryFoundCondimentsFor", X, CondimentsList).

getCondimentsForCondiment(Condiment, CondimentsList):-
    findall(Y, добавкаКДобавке(Condiment, Y), CondimentsList),
    prolog_current_frame(Frame),
    explainer:explainI18nForVarValue(Frame, "culinaryFoundCondimentsForCondiments", Condiment, CondimentsList).