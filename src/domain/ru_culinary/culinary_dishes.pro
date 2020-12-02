/**
@author initkfs
*/

бульон(мясо).
бульон(кости).
бульон(птица).
бульон(рыба).

основаСупа(картофель, бульон).

гарнирСупа(овощнойГарнир,'лук репчатый'(25)).
гарнирСупа(овощнойГарнир, морковь(50)).
гарнирСупа(овощнойГарнир, томат(100)).

основаГарнира(картофель, 260, овощнойГарнир).


гарнирСупа(X, XMass, L):- 
    findall([A, B, C], основаГарнира(A, B, C), L).

гарнирСупаДля(MainIngredient, MainIngredientMass, OtherIngredientList):- 
    findall(Y, гарнирСупа(MainIngredient, Y), OtherIngredientList).

заправочныйСупНаОснове(MainIngredient, IngredientList):- 
    гарнирСупа(MainIngredient, _, IngredientList).

нормальныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 4.

концентрированныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 1.25.