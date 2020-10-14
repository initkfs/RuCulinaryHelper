/** <module> Main gui
@author initkfs
*/
:- module(main_gui, [runGui/2]).

:- use_module(library(pce)).
:- use_module(library(toolbar)).

:- use_module('src/main_data_processor.pro').

:- include('domain/ru_culinary/ingredient.pro').

runGui(Config, I18n):- 
    setof(Y, ингредиент(Y), IngredientsList),
    runViewer(Config, I18n, IngredientsList).

runViewer(_, I18n, IngredientList):- 
     new(CulinaryHelper, frame(I18n.guiMainWindowTitle)),
     send(CulinaryHelper, append, new(Menu, tool_dialog)),
     send(CulinaryHelper, append, new(IngredientsBrowser, browser)),
     send(CulinaryHelper, append, new(DialogPanel, dialog)),
     send(CulinaryHelper, append, new(MainTextArea, view(size := size(50,20)))),
     
     send(MainTextArea, right, IngredientsBrowser),
     send(DialogPanel, below, IngredientsBrowser),
     send(Menu, above, IngredientsBrowser),

     send(Menu, append, new(MenuBar, menu_bar)),
     send(MenuBar, append, new(FileMenuItem, popup(I18n.guiMainMenuFileItem))),
     send_list(FileMenuItem, append, [menu_item(I18n.guiMainMenuExitItem, message(CulinaryHelper, destroy))]),
          
     send_list(IngredientsBrowser, append, IngredientList),
     send(IngredientsBrowser, open_message, message(@prolog, setTextToMainTextArea, MainTextArea, @arg1?key)),
     
     send(CulinaryHelper, open).
     
setTextToMainTextArea(TextArea, Ingredient):- 
     send(TextArea, clear),
     getDataForIngredient(Ingredient, ResultString),
     send(TextArea, append, ResultString).  