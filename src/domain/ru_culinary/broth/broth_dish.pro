/**
@author initkfs
*/

мяснойБульон(птица).
мяснойБульон(кости).
мяснойБульон(мясо).

нормальныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 4.

концентрированныйБульон(MassProductKg, VolumeLiquidL):-
    VolumeLiquidL is MassProductKg * 1.25.