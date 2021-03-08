/**
@author initkfs
*/
:- module(soup_service, [
    гарнирСупаИзИнгредиентов/2,
    гарнирыДляИнгредиентов/2,
    игредиентыДляГарнира/2
]).

:- use_module('./../../database/soups.pro').

гарнирСупаИзИнгредиентов(_, []).
гарнирСупаИзИнгредиентов(Garnish, [IngredientTerm|Tail]):-
    гарнирСупа(Garnish, IngredientTerm),
    гарнирСупаИзИнгредиентов(Garnish, Tail).

гарнирыДляИнгредиентов(IngredientAtomsList, GarnishList):-
    findall(X, гарнирСупаИзИнгредиентов(X, IngredientAtomsList), GarnishList).

игредиентыДляГарнира(Garnish, IngredientList):-
    findall(Y, гарнирСупа(Garnish, Y), IngredientList).

основаДляГарнира(Garnish, SoupBaseIngredientsList):-
    findall(Y, основаСупа(Garnish, Y), SoupBaseIngredientsList).
