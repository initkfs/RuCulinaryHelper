/**
@author initkfs
*/
:- module(collection_util, [
    toFlattenSet/2,
    biConvertListString/2
    ]).

:- use_module(library(error)).
:- use_module(library(prolog_stack)).

toFlattenSet(InputList, OutSet):-
    not(is_list(InputList)),
    throw(error(type_error("List", InputList), context(backtrace, "")));

    flatten(InputList, FlatList),
    list_to_set(FlatList, OutSet).

biConvertListString(List, String):-
    string(String),
    is_list(List),
    throw(error(instantiation_error, context(backtrace, "Unable to convert list and string, both arguments exist")));

    string(String),
    split_string(String, ",", "", List);

    is_list(List),
    atomic_list_concat(List, ',', String);

    format(string(ErrorMessage), "Unable to convert list and string, invalid types of both or one argument received, list: ~w, string: ~w", [List, String]),
    throw(error(instantiation_error, context(backtrace, ErrorMessage))).