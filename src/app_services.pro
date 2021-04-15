/** <module> Main command interpreter
@author initkfs
*/
:- module(app_services, [
    setMainConfig/1, 
    getConfigValue/2, 
    setMainI18N/1, 
    getI18nValue/2
]).

:- use_module(library(error)).
:- use_module(library(prolog_stack)).

getOrSetService(ServiceKeyAtom, Service):-
    not(atom(ServiceKeyAtom)),
    throw(error(type_error("Atom", ServiceKeyAtom), context(_, "")));

    nonvar(Service),
    b_setval(ServiceKeyAtom, Service);

    b_getval(ServiceKeyAtom, Service).

createServiceName(ServiceNameString, ServiceNameAtom):-
    atom_string(ServiceNameAtom, ServiceNameString).

getServiceDictValue(KeyString, ServiceKeyAtom, Value):-
    atom_string(KeyAtom, KeyString),
    getOrSetService(ServiceKeyAtom, Service),
    Value = Service.get(KeyAtom).
    
mainConfigKey(ConfigName):- 
    createServiceName("MainConfigKey", ConfigName).

setMainConfig(Config):-
    mainConfigKey(ConfigKey),
    getOrSetService(ConfigKey, Config).

getConfigValue(KeyString, ConfigValue):-
    mainConfigKey(ConfigKey),
    getServiceDictValue(KeyString, ConfigKey, ConfigValue).

mainI18nKey(I18nName):- 
    createServiceName("MainI18nKey", I18nName).

setMainI18N(I18n):-
    mainI18nKey(I18nName),
    getOrSetService(I18nName, I18n).

getI18nValue(KeyString, Value):-
    mainI18nKey(I18nName),
    getServiceDictValue(KeyString, I18nName, Value).