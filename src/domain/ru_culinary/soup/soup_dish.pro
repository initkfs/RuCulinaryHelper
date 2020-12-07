/**
@author initkfs
*/
:- include('../broth/broth_dish.pro').

основаСупа(овощнойГарнир, мяснойБульон).

гарнирСупа(овощнойГарнир, картофель(260)).
гарнирСупа(овощнойГарнир,'лук репчатый'(25)).
гарнирСупа(овощнойГарнир, морковь(50)).
гарнирСупа(овощнойГарнир, томат(100)).

гарнирыДляИнгредиента(Ingredient, GarnishList):-
    findall(X, гарнирСупа(X, Ingredient), GarnishList).

игредиентыДляГарнира(Garnish, IngredientList):-
    findall(Y, гарнирСупа(Garnish, Y), IngredientList).

основаДляГарнира(Garnish, SoupBaseIngredientsList):-
    findall(Y, основаСупа(Garnish, Y), SoupBaseIngredientsList).

заправочныйСупНаОснове(MainIngredient, GarnishIngredientList):- 
    functor(MainIngredientTerm, MainIngredient, 1),
    гарнирыДляИнгредиента(MainIngredientTerm, SideDishesForSoup),
    maplist(игредиентыДляГарнира, SideDishesForSoup, GarnishIngredientList).