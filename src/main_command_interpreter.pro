/** <module> Main command interpreter
@author initkfs
*/
:- module(main_command_interpreter, [interpretCommand/4]).

:- use_module(library(dcg/basics)).
:- use_module(library(pcre)).

:- use_module('src/main_data_processor.pro').

:- use_module('domain/ru_culinary/services/soup/soup_processor.pro').
:- use_module('domain/ru_culinary/services/condiment/condiment_processor.pro').

%for testing, TODO remove
:- include('domain/ru_culinary/ru_culinary_main.pro').

%for --> [для].
%searchFor --> [найди].
%searchForCombinations(X) --> searchFor, ([сочетание] ; [сочетания]), (for ; []), [X].
searchForCombinations(X) --> ([сочетание] ; [сочетания]), [X].
generateRecipeSoup(X) --> [суп], [X].
findCondimentForIngredient(X) --> [добавка], [X].

interpretCommand(Config, I18n, Command, ResultString):-
    atomic_list_concat(WordsList,' ', Command),
    parseCommand(Config, I18n, Command, WordsList, ResultString);
    writeln(I18n.cliCulinaryCommandInterpretError),
    exitWithFail.

parseCommand(_, _, _, WordsList, ResultString):-
    phrase(searchForCombinations(X), WordsList), getDataForIngredient(X, ResultString);
    phrase(findCondimentForIngredient(X), WordsList), condiment_processor:getCondimentForIngredient(X, ResultString);
    phrase(generateRecipeSoup(X), WordsList), 
    re_replace("_", " ", X, RawString),
    split_string(RawString, ",", "", IngredientsList),
    maplist(atom_string, MainIngredientsAtomsList, IngredientsList),
    soup_processor:buildRecipeSoupForIngredient(MainIngredientsAtomsList, ResultString).

formatList(_, [], _).
formatList(Stream, [H|T], Index) :-
    writeln(Stream, H),
    NextIndex is Index + 1,
    formatList(Stream, T, NextIndex).