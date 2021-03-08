/**
@author initkfs
*/
:- module(main_database_filesystem_loader, [
    loadRecipesFromDir/1
    ]).

:- include('domain/ru_culinary/ru_culinary_main.pro').

:-use_module('domain/ru_culinary/services/soup/soup_processor.pro').
:-use_module('core/util/io_util.pro').

:- use_module(library(readutil)).

loadRecipesFromDir(DirectoryPath):-
    io_util:dirRegularFiles(DirectoryPath, DirFiles),
    eachRecipeDir(DirFiles).

eachRecipeDir([]).
eachRecipeDir([Dir|T]):-
    exists_directory(Dir),
    file_base_name(Dir, ModuleNameString),
    atom_string(ModuleNameAtom, ModuleNameString),
    current_module(ModuleNameAtom),

    io_util:dirRegularFiles(Dir, RecipeFiles),
    eachRecipeFile(ModuleNameAtom, Dir, RecipeFiles),

    fail;
    eachRecipeDir(T).    

eachRecipeFile(_, _, []).
eachRecipeFile(ModuleNameAtom, ParentDir, [File|T]):-
    loadRecipeFile(ModuleNameAtom, File),
    fail;
    eachRecipeFile(ModuleNameAtom, ParentDir, T).

loadRecipeFile(ModuleNameAtom, File):- 
    read_file_to_string(File, FileContent, []),
    split_string(FileContent, "\r\n", "", Lines),
    nth0(0, Lines, RecipeName),

    ModuleNameAtom == супы,
    loadRecipeSoup(ModuleNameAtom, RecipeName, Lines, RecipePart),
    parseRecipe(ModuleNameAtom, Lines, RecipePart).
    
loadRecipeSoup(ModuleNameAtom, RecipeName, _, SoupGarnishName):-
    string_concat("Гарнир для ", RecipeName, SoupGarnishName),
    atom_string(RecipeNameAtom, RecipeName),
    atom_string(SoupGarnishAtom, SoupGarnishName),
    assertz(ModuleNameAtom:суп(RecipeNameAtom, SoupGarnishAtom)).

parseRecipe(_, [], _).
parseRecipe(ModuleNameAtom, [Line|Lines], RecipePart):-
    sub_string(Line, _, _, _, 'Ингредиенты'),
    parseIngredients(ModuleNameAtom, Lines, RecipePart);
    parseRecipe(ModuleNameAtom, Lines, RecipePart).

parseIngredients(_, [], _).
parseIngredients(ModuleNameAtom, [IngredientData|T], RecipePart):-
    sub_string(IngredientData, _, _, _, 'Приготовление'),
    true;
    split_string(IngredientData, "-", "", IngredientNameAndMassList),
    parseIngredientsData(ModuleNameAtom, IngredientNameAndMassList, RecipePart),

    parseIngredients(ModuleNameAtom, T, RecipePart).

parseIngredientsData(_, [], _).
parseIngredientsData(ModuleNameAtom, IngredientNameAndMassList, RecipePart):-
    nth0(0, IngredientNameAndMassList, IngredientRawName),
    nth0(1, IngredientNameAndMassList, IngredientRawMass),
    normalize_space(string(IngredientName), IngredientRawName),
    normalize_space(string(IngredientMass), IngredientRawMass),
    
    atom_string(IngredientNameAtom, IngredientName),
    atom_string(IngredientMassAtom, IngredientMass),
    functor(IngredientNameFunctor, IngredientNameAtom, 1),
    arg(1, IngredientNameFunctor, IngredientMassAtom),

    atom_string(RecipePartAtom, RecipePart),

    loadIngredientsDatabase(ModuleNameAtom, RecipePartAtom, IngredientNameFunctor).

loadIngredientsDatabase(ModuleNameAtom, RecipePartAtom, IngredientNameFunctor):-
    ModuleNameAtom == супы,
    assertz(ModuleNameAtom:гарнирСупа(RecipePartAtom, IngredientNameFunctor)).
