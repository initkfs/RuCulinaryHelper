/**
@author initkfs
*/
:- module(interaction_util, [
    readOneSymbolAnswer/1,
    askBooleanQuestionWithDefaultYes/4,
    checkEmptyAnswerOrYes/1
    ]).

readOneSymbolAnswer(AnswerString):-
    read_string(user_input, 1, InputRawString),
    normalize_space(string(AnswerString), InputRawString).

askBooleanQuestionWithDefaultYes(QuestionString, AnswerString, YesShortValueString, NoShortValueString):-
    format("~s, ~s\\~s? (~s) ~n", [
        QuestionString, YesShortValueString, NoShortValueString, YesShortValueString
        ]),
    readOneSymbolAnswer(AnswerString),
    checkCorrectYesOrNoAnswer(AnswerString, YesShortValueString, NoShortValueString).

checkCorrectYesOrNoAnswer(AnswerString, YesShortValueString, NoShortValueString):-
    % empty answer like 'yes'
    checkEmptyAnswer(AnswerString);
    AnswerString == NoShortValueString;
    AnswerString == YesShortValueString.

checkEmptyAnswer(AnswerString):-
    string_length(AnswerString, AnswerLength),
    AnswerLength == 0.

checkEmptyAnswerOrValue(AnswerString, ValueString):-
    checkEmptyAnswer(AnswerString);
    AnswerString == ValueString.