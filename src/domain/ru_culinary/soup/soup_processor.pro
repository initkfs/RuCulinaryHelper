/**
@author initkfs
*/
:- module(soup_processor, [buildRecipeSoupForIngredient/2]).

:- use_module('src/core/util/string_util.pro').

:- include('soup_dish.pro').

buildRecipeSoupForIngredient(Ingredient, ResultString):-
    string_util:createStringBuffer(StringBuffer, Stream),
    заправочныйСупНаОснове(Ingredient, GarnishIngredients),
    formatRecipeSoup(Ingredient, Stream, GarnishIngredients),   
    string_util:closeAndReadStringBuffer(ResultString, StringBuffer, Stream).

formatRecipeSoup(_, _, []).
formatRecipeSoup(Ingredient, Stream, [H|T]):-
    nl(Stream),
    writeln(Stream, "Рецепт супа:"),
    formatRecipeParts(Stream, H),
    formatRecipeSoup(Ingredient, Stream, T).

formatRecipeParts(_, []).
formatRecipeParts(Stream, [H|T]):-
    H =.. IngredientData,
    nth0(0, IngredientData, IngredientName),
    nth0(1, IngredientData, IngredientMass),
    format(Stream, '~w ~d гр. ~n', [IngredientName, IngredientMass]),
    formatRecipeParts(Stream, T).