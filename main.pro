#!/usr/bin/env swipl

/** <module> Application entry point.
@author initkfs
*/

:- set_prolog_flag(verbose, silent).
:- initialization(main).

:- use_module(library(optparse)).
:- use_module(library(yaml)).

:- use_module('src/core/app/exceptions.pro').
:- use_module('src/main_command_interpreter.pro').
:- use_module('src/main_gui.pro').

dataDir(Path):- Path = "./data/".

withDataDir(SomeDir, Path):-
    dataDir(DataDirPath),
    string_concat(DataDirPath, SomeDir, Path).

langDir(Path):-
    withDataDir("langs/", Path).

mainConfigFile(Path):-
    withDataDir("configs/main.yaml", Path).

cliOptSpec(_, _, [
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

	[opt(cliGuiFlag),  
        type(boolean), 
        default(false), 
        shortflags([g]), 
        longflags([gui]), 
        help('Run simble GUI viewer.')],

    [opt(cliDocBrowserFlag),
        type(boolean), 
        default(false),   
        shortflags([b]), 
        longflags([docbrowser]), 
        help('Run documentation browser.')],

    [opt(cliCommandFlag), 
        type(atom), 
        default('command'),
        shortflags([c]), 
        longflags([command]), 
	    help('Natural language command for interpretation.')]
]).

processCli(Config, I18n, Opts):- 
    
    member(cliHelpFlag(true), Opts), 
    printHelp(Config, I18n), 
    exitWithSuccess;

    member(cliVersionFlag(true), Opts), 
    printVersion(Config, I18n), 
    exitWithSuccess;
    
    member(cliGuiFlag(true), Opts), 
    main_gui:runGui(Config, I18n);
    
    member(cliDocBrowserFlag(true), Opts), 
    runDocServer(Config, I18n);
    
    member(cliCommandFlag(Command), Opts), 
    main_command_interpreter:interpretCommand(Config, I18n, Command, ResultString),
    writeln(ResultString),
    exitWithSuccess.

printHelp(Config, I18n):-
	cliOptSpec(Config, I18n, CliSpec),		
	optparse:opt_help(CliSpec, HelpText),
	format('Usage:~n'),
	write(HelpText).

printVersion(Config, _):-
    string_concat("Version: ", Config.version, VersionString),
    writeln(VersionString).

runDocServer(Config, _):-
    doc_server(Config.docServerPort),
    portray_text(true),
    doc_browser.

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
    loadYamlResource(ResourcePath, I18n).

loadConfig(Config):-
    mainConfigFile(ConfigFilePath),
    loadYamlResource(ConfigFilePath, Config).

main(Argv) :-
    beforeStart(Argv);
    loadConfig(Config),
    loadI18nResources(Config.language, I18n),
    startApp(Config, I18n, Argv).

startApp(Config, I18n, Argv):-
    cliOptSpec(Config, I18n, Spec),
	optparse:opt_parse(Spec, Argv, Opts, _),
    
    processCli(Config, I18n, Opts),
    beforeEnd(Config, I18n, Argv);

    beforeErrorStart(Config, I18n, Argv),
    writeln("Unable to process command line arguments"), 
    printHelp(Config, I18n, Argv),
    beforeErrorEnd(Config, I18n, Argv),
    exitWithSuccess.

beforeStart(_):- false.

beforeEnd(_,_,_):- true.

beforeErrorStart(_,_,_):- true.

beforeErrorEnd(_,_,_):- true.

exitWithSuccess:-
    halt.
exitWithFail:-
    halt.