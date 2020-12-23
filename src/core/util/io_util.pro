/**
@author initkfs
*/
:- module(io_util, [
    dirRegularFiles/2
    ]).

:- use_module(library(apply)).

dirFileList([]).

dirRegularFiles(DirectoryPath, DirFiles):-
    absolute_file_name(DirectoryPath, DirectoryFullPath),
    directory_files(DirectoryFullPath, Files),
    exclude(=('.'), Files, DirFilesWithoutCurrent),
    exclude(=('..'), DirFilesWithoutCurrent, FileNames),
    length(FileNames, FilesCount),
    FilesCount > 0,
    length(ParentPaths, FilesCount),
    maplist(=(DirectoryFullPath), ParentPaths),
    maplist(buildPathForDir, ParentPaths, FileNames, DirFiles);
    DirFiles = [].

buildPathForDir(DirPath, FileName, ResultPath):-
    string_concat(DirPath, "/", NormalizedDir),
    string_concat(NormalizedDir, FileName, ResultPath).
