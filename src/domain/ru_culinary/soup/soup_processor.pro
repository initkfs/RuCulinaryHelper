/**
@author initkfs
*/
:- module(soup_processor, [buildRecipeSoupForIngredient/2]).

:- use_module('src/core/util/string_util.pro').

:- include('soup_dish.pro').
:- include('./../culinary_cutting.pro').

buildRecipeSoupForIngredient([], _).
buildRecipeSoupForIngredient(IngredientAtomsList, ResultString):-
    string_util:createStringBuffer(StringBuffer, Stream),
    findGarnishForIngredients(IngredientAtomsList, GarnishIngredients),
    eachSoupGarnish(GarnishIngredients, Stream),
    string_util:closeAndReadStringBuffer(ResultString, StringBuffer, Stream).

findGarnishForIngredients(MainIngredientAtomsList, GarnishList):-
    length(MainIngredientAtomsList, MainIngredientCount),
    length(ArityList, MainIngredientCount),
    maplist(=(1), ArityList),
    maplist(functor, MainIngredientTermsList, MainIngredientAtomsList, ArityList),
    гарнирыДляИнгредиентов(MainIngredientTermsList, GarnishList).

eachSoupGarnish([], _).
eachSoupGarnish([Garnish|T], Stream):-
    игредиентыДляГарнира(Garnish, GarnishIngredientList),
    суп(SoupName, Garnish),
    formatRecipeSoup(SoupName, GarnishIngredientList, Stream),
    eachSoupGarnish(T, Stream).

formatRecipeSoup(_, [], _).
formatRecipeSoup(SoupName, GarnishIngredientList, Stream):-
    nl(Stream),
    format(Stream, "Рецепт супа '~w':~n", SoupName),
    formatRecipeParts(GarnishIngredientList, Stream).

formatRecipeParts([], _).
formatRecipeParts([H|T], Stream):-
    H =.. IngredientData,
    nth0(0, IngredientData, IngredientName),
    nth0(1, IngredientData, IngredientMass),
    findall(X, нарезка(IngredientName, суп, X), CuttingList),
    atomic_list_concat(CuttingList, ',', CuttingResultAtom),
    format(Stream, '~w ~d гр. ~a. ~n', [IngredientName, IngredientMass, CuttingResultAtom]),
    formatRecipeParts(T, Stream).