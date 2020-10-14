/**
@author initkfs
*/
:- module(string_util, [
    createStringBuffer/2, 
    closeAndReadStringBuffer/3
    ]).

:- use_module(library(memfile)).

createStringBuffer(StringBuffer, Stream):- 
    memfile:new_memory_file(StringBuffer),
    memfile:open_memory_file(StringBuffer, write, Stream).

closeAndReadStringBuffer(Output, StringBuffer, Stream):-
    close(Stream),
    memfile:memory_file_to_string(StringBuffer, Output).