/**
@author initkfs
*/

основнойИнгредиент(X, M):- 
    варка(X), 
    клубнеплод(X), 
    M is 100.

дополнительныйИнгредиент(X, M):-
    варка(X),
    корнеплод(X), 
    M is 50.

акцентныйИнгредиент(X):- специя(X); приправа(X); пряность(X).

суп(Liquid, MainIngredientsList, MainIngredientsMassList, AdditionalIngredientsList, AdditionalIngredientsMassList):-
    жидкость(Liquid),
    maplist(основнойИнгредиент, MainIngredientsList, MainIngredientsMassList),
    maplist(дополнительныйИнгредиент, AdditionalIngredientsList, AdditionalIngredientsMassList).

рецептСупа(L):- 
    findall(
        [Liquid, 
        MainIngredientsList, 
        MainIngredientsMassList, 
        AdditionalIngredientsList,
        AdditionalIngredientsMassList], 
        
        суп(
        Liquid, 
        [MainIngredientsList], 
        [MainIngredientsMassList], 
        [AdditionalIngredientsList],
        [AdditionalIngredientsMassList]), 
        L).