/**
@author initkfs
*/
:- module(soup_processor, [
    buildRecipeSoupForIngredient/2, 
    findGarnishForIngredients/2
    ]).

:- use_module('src/core/util/string_util.pro').
:- use_module('./../../database/soups.pro').
:- use_module('soup_service.pro').

:- include('./../../database/culinary_cutting.pro').

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
    string_util:capitalize(SoupName, CapitalizedSoupName),
    format(Stream, "Рецепт супа '~w':~n", CapitalizedSoupName),
    formatRecipeParts(GarnishIngredientList, Stream).

formatRecipeParts([], _).
formatRecipeParts([H|T], Stream):-
    H =.. IngredientData,
    nth0(0, IngredientData, IngredientName),
    nth0(1, IngredientData, IngredientMass),
    format(Stream, '~w ', [IngredientName]),
    formatStringOrMass(Stream, IngredientMass),
    formatIngredientCutting(Stream, IngredientName),
    formatRecipeParts(T, Stream).

formatStringOrMass(Stream, MustBeMass):-
    number(MustBeMass),
    format(Stream, "~d гр.", MustBeMass);
    format(Stream, "~w.", MustBeMass).

formatIngredientCutting(Stream, IngredientName):-
    findall(X, нарезка(IngredientName, суп, X), CuttingList),
    length(CuttingList, CuttingListLenght),
    CuttingListLenght > 0,
    atomic_list_concat(CuttingList, ',', CuttingResultAtom),
    format(Stream, ' ~a. ~n', [CuttingResultAtom]);
    format(Stream, '~n', []).