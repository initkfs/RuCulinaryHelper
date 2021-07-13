/** <module> Main command interpreter
@author initkfs
*/
:- module(main_command_interpreter, [interpretCommand/2]).

:- use_module(library(dcg/basics)).
:- use_module(library(pcre)).

:- use_module('src/app_services.pro').
:- use_module('src/main_data_processor.pro').

:- use_module('domain/ru_culinary/services/soup/soup_controller.pro').
:- use_module('domain/ru_culinary/services/condiment/condiment_controller.pro').

%for testing, TODO remove
:- include('domain/ru_culinary/ru_culinary_main.pro').

%for --> [для].
%searchFor --> [найди].
%searchForCombinations(X) --> searchFor, ([сочетание] ; [сочетания]), (for ; []), [X].
searchForCombinations(X) --> ([сочетание] ; [сочетания]), [X].
generateRecipeSoup(X) --> [суп], [X].
findCondimentForIngredient(X) --> [добавка], [X].

interpretCommand(Command, ResultString):-
    atomic_list_concat(WordsList,' ', Command),

    format(string(RecieveCommandMessage), "Received command for parsing: '~s'", Command),
    app_services:logDebug(RecieveCommandMessage),

    parseCommand(Command, WordsList, ResultString);
    app_services:getI18nValue("cliCulinaryCommandInterpretError", CommandErrorText),
    writeln(CommandErrorText),
    false.

parseCommand(_, WordsList, ResultString):-
    phrase(searchForCombinations(X), WordsList), main_data_processor:getDataForIngredient(X, ResultString);
    phrase(findCondimentForIngredient(X), WordsList), atom_string(X, IngredientsListAsString), condiment_controller:printCondimentsForIngredients(IngredientsListAsString, ResultString);
    phrase(generateRecipeSoup(X), WordsList), 
    re_replace("_", " ", X, RawString),
    split_string(RawString, ",", "", IngredientsList),
    maplist(atom_string, MainIngredientsAtomsList, IngredientsList),
    soup_controller:buildRecipeSoupForIngredient(MainIngredientsAtomsList, ResultString).

formatList(_, [], _).
formatList(Stream, [H|T], Index) :-
    writeln(Stream, H),
    NextIndex is Index + 1,
    formatList(Stream, T, NextIndex).