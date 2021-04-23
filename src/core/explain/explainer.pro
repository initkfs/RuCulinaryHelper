/**
@author initkfs
*/
:- module(explainer, [
    explainI18nForVarValue/4
]).

:- use_module('src/app_services.pro').

%TODO validate arguments
explainI18nForVarValue(Frame, I18nKey, ForVar, Value):-
    app_services:getI18nValue(I18nKey, I18nInfoMessage),

    prolog_frame_attribute(Frame, goal, Goal),
    app_services:getI18nValue("explainGoalThatApplied", I18nGoalMessage),

    format(string(Message), "~s '~w': ~w. ~s ~w", [I18nInfoMessage, ForVar, Value, I18nGoalMessage, Goal]),

    app_services:logInfo(Message).