/**
@author initkfs
*/
:- module(soup_processor, [buildRecipeSoupForIngredient/2]).

:- use_module('src/core/util/string_util.pro').

:- include('soup_dish.pro').

buildRecipeSoupForIngredient([], _).
buildRecipeSoupForIngredient(IngredientAtomsList, ResultString):-
    string_util:createStringBuffer(StringBuffer, Stream),
    заправочныйСуп(IngredientAtomsList, GarnishIngredients),
    formatRecipeSoup(Stream, GarnishIngredients),   
    string_util:closeAndReadStringBuffer(ResultString, StringBuffer, Stream).

formatRecipeSoup(_, []).
formatRecipeSoup(Stream, [H|T]):-
    nl(Stream),
    writeln(Stream, "Рецепт супа:"),
    formatRecipeParts(Stream, H),
    formatRecipeSoup(Stream, T).

formatRecipeParts(_, []).
formatRecipeParts(Stream, [H|T]):-
    H =.. IngredientData,
    nth0(0, IngredientData, IngredientName),
    nth0(1, IngredientData, IngredientMass),
    format(Stream, '~w ~d гр. ~n', [IngredientName, IngredientMass]),
    formatRecipeParts(Stream, T).