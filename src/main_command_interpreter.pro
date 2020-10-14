/** <module> Main command interpreter
@author initkfs
*/
:- module(main_command_interpreter, [interpretCommand/4]).

:- use_module(library(dcg/basics)).

:- use_module('src/main_data_processor.pro').

%for --> [для].
%searchFor --> [найди].
%searchForCombinations(X) --> searchFor, ([сочетание] ; [сочетания]), (for ; []), [X].
searchForCombinations(X) --> ([сочетание] ; [сочетания]), [X].
generateRecipeSoup --> ([суп]).

interpretCommand(Config, I18n, Command, ResultString):-
    atomic_list_concat(WordsList,' ', Command),
    parseCommand(Config, I18n, Command, WordsList, ResultString);
    writeln(I18n.cliCulinaryCommandInterpretError),
    exitWithFail.

parseCommand(_, _, _, WordsList, ResultString):-
    phrase(searchForCombinations(X), WordsList), getDataForIngredient(X, ResultString);
    phrase(generateRecipeSoup, WordsList), getDataForRecipeSoup(ResultString).

formatList(_, [], _).
formatList(Stream, [H|T], Index) :-
    writeln(Stream, H),
    NextIndex is Index + 1,
    formatList(Stream, T, NextIndex).