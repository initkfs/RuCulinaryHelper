/**
@author initkfs
*/
:- module(condiment_processor, [
        printCondimentsForIngredients/2
    ]).

:- use_module('src/core/util/string_util.pro').
:- use_module('src/core/util/collection_util.pro').
:- use_module('condiment_service.pro').

printCondimentsForIngredients(IngredientListAsString, OutputString):-

    collection_util:biConvertListString(IngredientStringsList, IngredientListAsString),
    maplist(atom_string, IngredientList, IngredientStringsList),
    string_util:createStringBuffer(StringBuffer, Stream),

    format(Stream, "Ingredients: ~s~n", IngredientListAsString),

    findCondimentsByGoalToSet(condiment_service:getCondimentsFor, IngredientList, CondimentForIngredientsSet),
    collection_util:biConvertListString(CondimentForIngredientsSet, CondimentForIngredientString),
    format(Stream, "Condiments: ~s~n", CondimentForIngredientString),

    findCondimentsByGoalToSet(condiment_service:getCondimentsForCondiment, CondimentForIngredientsSet, CondimentsForCondimentsSet),
    intersection(CondimentForIngredientsSet, CondimentsForCondimentsSet, IntersectionCondiments),
    subtract(CondimentsForCondimentsSet, IntersectionCondiments, CondimentsForCondimentsResultSet),
    collection_util:biConvertListString(CondimentsForCondimentsResultSet, CondimentsForCondimentsString),
    format(Stream, "Mix: ~s~n", CondimentsForCondimentsString),

    string_util:closeAndReadStringBuffer(OutputString, StringBuffer, Stream).

findCondimentsByGoalToSet(Goal, InputList, OutputSet):-
    maplist(Goal, InputList, ResultList),
    collection_util:toFlattenSet(ResultList, OutputSet).