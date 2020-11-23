/**
@author initkfs
*/

бульон(мясо).
бульон(кости).
бульон(птица).
бульон(рыба).

основаСупа(картофель, бульон).

гарнирСупа(картофель, [картофель(260), морковь(50), 'лук репчатый'(25), томат(100)]).
гарнирСупа(картофель, [картофель(400), морковь(100), 'лук репчатый'(100), томат(25), 'горошек зеленый'(20)]).

гарнирСупаДля(MainIngredient, OtherIngredientList):- 
    findall(Y, гарнирСупа(MainIngredient, Y), OtherIngredientList).

заправочныйСупНаОснове(MainIngredient, IngredientList):- 
    гарнирСупаДля(MainIngredient, IngredientList).

нормальныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 4.

концентрированныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 1.25.