/**
@author initkfs
*/
:- module(logger, [
    createLogger/2, 
    getLoggerLevel/2,
    addLogHandler/1,
    simpleCliLogHandler/2,
    logError/2,
    logWarn/2,
    logInfo/2,
    logDebug/2,
    logTrace/2
]).

:- use_module(library(error)).
:- use_module(library(prolog_stack)).

logLevels([error, warn, info, debug, trace, all]).

isValidLevel(LogLevel, LogLevelRank):-
    logLevels(LogLevels),
    nth0(LogLevelRank, LogLevels, LogLevel).

createLogger(LogLevelString, Logger):-
    atom_string(LogLevelAtom, LogLevelString),
    createLoggerDict(LogLevelAtom, Logger).

createLoggerDict(LogLevelAtom, LoggerDict):-
    not(isValidLevel(LogLevelAtom, _)),
    logLevels(LogLevels),
    throw(error(domain_error(LogLevels, LogLevelAtom), context(_, "")));
    LoggerDict = logger{level:LogLevelAtom}.

getLoggerLevel(Logger, LevelAtom):-
    not(is_dict(Logger)),
    throw(error(type_error("Dict", Logger), context(_, "")));
    get_dict(level, Logger, LevelAtom).

isForLevel(LevelValue, Logger):-
    isValidLevel(LevelValue, LevelRankValue),
    getLoggerLevel(Logger, LoggerLevel),
    isValidLevel(LoggerLevel, LoggerLevelRankValue),
    !,
    LoggerLevelRankValue >= LevelRankValue.

logError(Logger, Message):-
    logForLevel(error, Logger, Message).

logWarn(Logger, Message):-
    logForLevel(warn, Logger, Message).

logInfo(Logger, Message):-
    logForLevel(info, Logger, Message).

logDebug(Logger, Message):-
    logForLevel(debug, Logger, Message).

logTrace(Logger, Message):-
    logForLevel(trace, Logger, Message).

logForLevel(LogLevel, Logger, Message):-
    isForLevel(LogLevel, Logger),
    log(LogLevel, Message);
    true.

log(Level, Message):-
    not(isLogHandlerDefined);
    forall(logHandler(Handler), call(Handler, Level, Message)).

isLogHandlerDefined:-
    current_predicate(logHandler/1).

addLogHandler(Handler):-
    isLogHandlerDefined,
    logHandler(Handler), 
    throw(error(instantiation_error("The logger handler is already installed"), context(_, Handler)));
    assertz(logHandler(Handler)).

simpleCliLogHandler(LogLevel, LogMessage):-
    get_time(Time),
    stamp_date_time(Time, Date, 'UTC'),
    format_time(string(DateTimeInfo),
                    '%d.%m.%Y %T UTC',
                    Date, posix),
    format(string(Message), "~s ~a: ~w", [DateTimeInfo, LogLevel, LogMessage]),
    writeln(Message),
    flush_output.