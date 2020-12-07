/** <module> Main data service
@author initkfs
*/
:- module(main_database_service, [
    getDataForIngredient/2, 
    printCombinations/2
    ]).

:- use_module(library(dcg/basics)).

:- use_module('src/core/util/string_util.pro').

:- include('domain/ru_culinary/ru_culinary_main.pro').

getDataForIngredient(Ingredient, OutputString):-
    string_util:createStringBuffer(StringBuffer, Stream),
    printCombinations(Ingredient, Stream), 
    string_util:closeAndReadStringBuffer(OutputString, StringBuffer, Stream).

printCombinations(Ingredient, Stream):- 
    всеСочетания(Ingredient, ListCombinations),
    format(Stream, 'К ингредиенту ~w хорошо подходит: ~n', Ingredient),
    formatList(Stream, ListCombinations, 0), fail;
   
    варка(Ingredient),
    всеСочетанияВарка(Ingredient, ListCombinationsForBoil),
    format(Stream, 'Если ~w отварить, то следует добавить: ~n', Ingredient),
    formatList(Stream, ListCombinationsForBoil, 0), fail;

    жарка(Ingredient),
    всеСочетанияЖарка(Ingredient, ListCombinationsForRoast),
    format(Stream, 'Если ~w пожарить, то можно взять: ~n', Ingredient),
    formatList(Stream, ListCombinationsForRoast, 0).

formatList(_, [], _).
formatList(Stream, [H|T], Index) :-
    writeln(Stream, H),
    NextIndex is Index + 1,
    formatList(Stream, T, NextIndex).