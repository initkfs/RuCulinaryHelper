/**
@author initkfs
*/
:- module(condiment_processor, [
        getCondimentForIngredient/2
    ]).

:- use_module('src/core/util/string_util.pro').
:- use_module('condiment_service.pro').

getCondimentForIngredient(X, OutputString):-
    string_util:createStringBuffer(StringBuffer, Stream),
    printCondimentsForIngredient(X, Stream),
    string_util:closeAndReadStringBuffer(OutputString, StringBuffer, Stream).

printCondimentsForIngredient(Ingredient, Stream):-
    condiment_service:getCondimentsFor(Ingredient, CondimentsList),
    maplist(condiment_service:getCondimentsForCondiment, CondimentsList, ForCondimentList),
    flatten(ForCondimentList, FlatForCondimentList),
    append(CondimentsList, FlatForCondimentList, ResultCondimentsList),
    list_to_set(ResultCondimentsList, ResultCondimentSet),
    writeln(Stream, ResultCondimentSet).