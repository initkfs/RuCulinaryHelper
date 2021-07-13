/**
@author initkfs
*/
:- module(condiment_controller, [
        printCondimentsForIngredients/2
    ]).

:- use_module('src/app_services.pro').
:- use_module('src/core/util/string_util.pro').
:- use_module('src/core/util/collection_util.pro').
:- use_module('condiment_service.pro').

printCondimentsForIngredients(IngredientListAsString, OutputString):-

    app_services:getI18nValue("culinaryCommandFindCondimentsFor", I18nFindMessage),
    format(string(SearchIngredientsMessage), "~s '~s'", [I18nFindMessage, IngredientListAsString]),
    app_services:logInfo(SearchIngredientsMessage),

    collection_util:biConvertListString(IngredientStringsList, IngredientListAsString),
    maplist(atom_string, IngredientList, IngredientStringsList),
    string_util:createStringBuffer(StringBuffer, Stream),

    app_services:getI18nValue("culinaryIngredients", I18nIngredientsMessage),
    format(Stream, "~s: ~s~n", [I18nIngredientsMessage, IngredientListAsString]),

    findCondimentsByGoalToSet(condiment_service:getCondimentsFor, IngredientList, CondimentForIngredientsSet),
    collection_util:biConvertListString(CondimentForIngredientsSet, CondimentForIngredientString),
    app_services:getI18nValue("culinaryCondiments", I18nCondimentsMessage),
    format(Stream, "~s: ~s~n", [I18nCondimentsMessage, CondimentForIngredientString]),

    findCondimentsByGoalToSet(condiment_service:getCondimentsForCondiment, CondimentForIngredientsSet, CondimentsForCondimentsSet),
    intersection(CondimentForIngredientsSet, CondimentsForCondimentsSet, IntersectionCondiments),
    subtract(CondimentsForCondimentsSet, IntersectionCondiments, CondimentsForCondimentsResultSet),
    collection_util:biConvertListString(CondimentsForCondimentsResultSet, CondimentsForCondimentsString),
    app_services:getI18nValue("culinaryСondimentsMix", I18nCondimentsMixMessage),
    format(Stream, "~s: ~s~n", [I18nCondimentsMixMessage, CondimentsForCondimentsString]),

    string_util:closeAndReadStringBuffer(OutputString, StringBuffer, Stream).

findCondimentsByGoalToSet(Goal, InputList, OutputSet):-
    maplist(Goal, InputList, ResultList),
    collection_util:toFlattenSet(ResultList, OutputSet).