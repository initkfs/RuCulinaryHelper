/** <module> Main data service
@author initkfs
*/
:- module(main_database_service, [
    getDataForIngredient/2, 
    printCombinations/2, 
    getDataForRecipeSoup/1
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

getDataForRecipeSoup(ResultString):-
    string_util:createStringBuffer(StringBuffer, Stream),
    рецептСупа(L),
    formatRecipe(Stream, L),
    string_util:closeAndReadStringBuffer(ResultString, StringBuffer, Stream).

formatRecipe(_, []).
formatRecipe(Stream, [H|T]):-
    writeln(Stream, "Рецепт супа:"),
    formatRecipeParts(Stream, H),
    formatRecipe(Stream, T).

formatRecipeParts(_, []).
formatRecipeParts(Stream, [N|[]]):-
    formatRecipePartsAsIngredientOrMass(Stream, N).
formatRecipeParts(Stream, [H|[N|T]]):-
    formatRecipePartsAsIngredientOrMass(Stream, H, N),
    formatRecipeParts(Stream, T).

formatRecipePartsAsIngredientOrMass(Stream, Ingredient):-
    atom(Ingredient),
    writeln(Stream, Ingredient);
    number(Ingredient),
    format(Stream, " ~d гр. ~n", Ingredient).
formatRecipePartsAsIngredientOrMass(Stream, Ingredient, NextIngredient):-
    atom(Ingredient),
    atom(NextIngredient),
    writeln(Stream, Ingredient),
    write(Stream, NextIngredient);
    number(Ingredient), 
    atom(NextIngredient),
    format(Stream, " ~d гр. ~n", Ingredient),
    write(Stream, NextIngredient);
    atom(Ingredient),
    number(NextIngredient),
    format(Stream, "~w ~d гр. ~n", [Ingredient, NextIngredient]).

formatList(_, [], _).
formatList(Stream, [H|T], Index) :-
    writeln(Stream, H),
    NextIndex is Index + 1,
    formatList(Stream, T, NextIndex).