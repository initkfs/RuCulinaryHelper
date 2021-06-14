#!/usr/bin/env swipl

/** <module> Application entry point.
@author initkfs
*/

:- set_prolog_flag(verbose, silent).
:- initialization(main).

:- use_module(library(optparse)).
:- use_module(library(yaml)).

:- use_module('src/core/app/exceptions.pro').
:- use_module('src/core/logger/logger.pro').
:- use_module('src/core/util/io_util.pro').
:- use_module('src/main_command_interpreter.pro').
:- use_module('src/main_database_filesystem_loader.pro').
:- use_module('src/app_services.pro').

dataDir(Path):- Path = "./data/".

withDataDir(SomeDir, Path):-
    dataDir(DataDirPath),
    string_concat(DataDirPath, SomeDir, Path).

langDir(Path):-
    withDataDir("langs/", Path).

mainConfigFile(Path):-
    withDataDir("configs/main.yaml", Path).

cliOptSpec([
    [opt(cliHelpFlag), 
        type(boolean),
        default(false),
        shortflags([h]), 
        longflags([help]), 
        help('Print help.')],

	[opt(cliVersionFlag), 
        type(boolean), 
        default(false), 
        shortflags([v]), 
        longflags([version]), 
        help('Print version.')],

    [opt(cliDocBrowserFlag),
        type(boolean), 
        default(false),   
        shortflags([b]), 
        longflags([docbrowser]), 
        help('Run documentation browser.')],

    [opt(cliSpellFlag), 
        type(boolean), 
        default(false),
        shortflags([s]), 
        longflags([spell]), 
	    help('Check spelling for a domain database.')],

    [opt(cliCommandFlag), 
        type(atom), 
        default('command'),
        shortflags([c]), 
        longflags([command]), 
	    help('Natural language command for interpretation.')]
]).

processCli(Opts):- 
    
    member(cliHelpFlag(true), Opts), 
    printHelp, 
    exitWithSuccess;

    member(cliVersionFlag(true), Opts), 
    printVersion, 
    exitWithSuccess;

    member(cliSpellFlag(true), Opts), 
    checkSpell, 
    exitWithSuccess;
    
    member(cliDocBrowserFlag(true), Opts), 
    runDocServer;
    
    member(cliCommandFlag(Command), Opts), 
    main_command_interpreter:interpretCommand(Command, ResultString),
    writeln(ResultString),
    exitWithSuccess.

printHelp:-
	cliOptSpec(CliSpec),		
	optparse:opt_help(CliSpec, HelpText),
	format('Usage:~n'),
	write(HelpText).

printVersion:-
    app_services:getConfigValue("appVersion", AppVersion),
    string_concat("Version: ", AppVersion, VersionString),
    writeln(VersionString).

runDocServer:-
    app_services:getConfigValue("appDocServerPort", DocServerPort),
    doc_server(DocServerPort),
    portray_text(true),
    doc_browser.

checkSpell:-
    app_services:getConfigValue("domainDataBaseDirPath", DatabaseDirPath),
    exists_directory(DatabaseDirPath),
    dirRegularFiles(DatabaseDirPath, DatabaseFiles),
    eachDatabaseFileForSpell(DatabaseFiles).

eachDatabaseFileForSpell([]).
eachDatabaseFileForSpell([DatabaseFile|T]):-
    exists_file(DatabaseFile),
    atom_string(DatabaseFile, DatabaseFilePath),
    %! WARNING! Unsafe exec
    string_concat("yaspeller --lang ru --format plain --report console --only-errors --ignore-capitalization ", DatabaseFilePath, SpellCommand),
    shell(SpellCommand, _),
    eachDatabaseFileForSpell(T).

loadYamlResource(ResourcePath, YamlContent):-
    exists_file(ResourcePath),
    open(ResourcePath, read, ResourceStream),
    yaml:yaml_read(ResourceStream, YamlContent),
    close(ResourceStream);
    throw(error(resourceLoadError(ResourcePath), _)).

loadI18nResources(Language, I18n):-
    string_concat(Language, ".yaml", ResourceFileName),
    langDir(LangDirPath),
    string_concat(LangDirPath, ResourceFileName, ResourcePath),
    loadYamlResource(ResourcePath, I18n),
    format(string(LoadI18nMessage), "Load I18n, language: ~s, resource: ~s", [Language, ResourcePath]),
    app_services:logDebug(LoadI18nMessage).

loadConfig(Config):-
    mainConfigFile(ConfigFilePath),
    loadYamlResource(ConfigFilePath, Config).

main(Argv) :-
    beforeStart(Argv);
    loadConfig(Config),
    app_services:setMainConfig(Config),
    
    app_services:getConfigValue("appMainLoggerLevel", LoggerLevelString),
    logger:createLogger(LoggerLevelString, Logger),
    logger:addLogHandler(logger:simpleCliLogHandler),
    app_services:setMainLogger(Logger),
    logger:getLoggerLevel(Logger, LoggerLevelAtom),
    format(string(LoadLoggerMessage), "Load logger, level: ~a, config level: ~s", [LoggerLevelAtom, LoggerLevelString]),
    app_services:logDebug(LoadLoggerMessage),
    
    app_services:getConfigValue("appCurrentLanguage", CurrentLanguage),
    loadI18nResources(CurrentLanguage, I18n),
    app_services:setMainI18N(I18n),

    app_services:getConfigValue("domainRecipePath", RecipePathConfigValue),
    main_database_filesystem_loader:loadRecipesFromDir(RecipePathConfigValue),

    catch_with_backtrace(startApp(Argv), Error,
                         print_message(error, Error)),
    (  nonvar(Error)->  
        stopApp;
        true
    ).

startApp(Argv):-
    cliOptSpec(Spec),
	optparse:opt_parse(Spec, Argv, Opts, _),

    processCli(Opts),
    beforeEnd(Argv);

    beforeErrorStart(Argv),
    writeln("Unable to process command line arguments"), 
    printHelp,
    beforeErrorEnd(Argv),
    exitWithSuccess.

stopApp:-
    halt.

beforeStart(_):- false.

beforeEnd(_):- true.

beforeErrorStart(_):- true.

beforeErrorEnd(_):- true.

exitWithSuccess:-
    stopApp.
exitWithFail:-
    stopApp.