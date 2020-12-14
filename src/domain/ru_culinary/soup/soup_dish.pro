/**
@author initkfs
*/
:- include('../broth/broth_dish.pro').

основаСупа(овощнойГарнир, мяснойБульон).

суп('суп овощной', овощнойГарнир).
суп('суп крестьянский', морковноЛуковыйГарнир).

гарнирСупа(овощнойГарнир, картофель(260)).
гарнирСупа(овощнойГарнир,'лук репчатый'(25)).
гарнирСупа(овощнойГарнир, морковь(50)).
гарнирСупа(овощнойГарнир, томат(100)).

гарнирСупа(морковноЛуковыйГарнир,'лук репчатый'(70)).
гарнирСупа(морковноЛуковыйГарнир, морковь(100)).

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
