/**
@author initkfs
*/
:- module(exceptions, []).

prolog:error_message(resourceLoadError(ResourcePath)) --> 
    ['Resource load error: ~w'- ResourcePath].