/**
@author initkfs
*/

мяснойБульон(птица).
мяснойБульон(кости).
мяснойБульон(мясо).

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

нормальныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 4.

концентрированныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 1.25.