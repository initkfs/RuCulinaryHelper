/**
@author initkfs
*/

бульон(мясо).
бульон(кости).
бульон(птица).
бульон(рыба).

основаСупа(вода).
основаСупа(отвар).
основаСупа(молоко).
основаСупа(квас).
основаСупа(бульон).

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

нормальныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 4.

концентрированныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 1.25.