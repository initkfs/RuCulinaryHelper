/**
@author initkfs
*/
:- include('../broth/broth_dish.pro').

основаСупа(овощнойГарнир, мяснойБульон).

суп('суп крестьянский', овощнойГарнир).
суп('суп картофельный', картофельныйГарнир).
суп('суп картофельный c фасолью', картофельноБобовыйГарнир).
суп('суп с рыбными консервами', картофельноРыбноПолуфабрикатный).

гарнирСупа(картофельныйГарнир, картофель(430)).
гарнирСупа(картофельныйГарнир, 'крупа перловая'(40)).
гарнирСупа(картофельныйГарнир, 'лук репчатый'(50)).
гарнирСупа(картофельныйГарнир, морковь(50)).

гарнирСупа(овощнойГарнир, 'горошек зеленый консервированный'(45)).
гарнирСупа(овощнойГарнир, 'капуста белокочанная'(100)).
гарнирСупа(овощнойГарнир, картофель(270)).
гарнирСупа(овощнойГарнир,'лук репчатый'(25)).
гарнирСупа(овощнойГарнир, морковь(50)).
гарнирСупа(овощнойГарнир, томат(100)).

гарнирСупа(картофельноБобовыйГарнир, картофель(330)).
гарнирСупа(картофельноБобовыйГарнир,'лук репчатый'(50)).
гарнирСупа(картофельноБобовыйГарнир, морковь(50)).
гарнирСупа(картофельноБобовыйГарнир, фасоль(80)).

гарнирСупа(картофельноРыбноПолуфабрикатный, картофель(200)).
гарнирСупа(картофельноРыбноПолуфабрикатный, 'консервы рыбные'(250)).
гарнирСупа(картофельноРыбноПолуфабрикатный, 'лук репчатый'(100)).
гарнирСупа(картофельноРыбноПолуфабрикатный, морковь(130)).
гарнирСупа(картофельноРыбноПолуфабрикатный, рис(50)).
