/** <module> Main gui
@author initkfs
*/
:- module(main_gui, [runGui/0]).

:- use_module(library(pce)).
:- use_module(library(toolbar)).

:- use_module('src/app_services.pro').
:- use_module('src/main_data_processor.pro').

:- include('domain/ru_culinary/ru_culinary_main.pro').

runGui:- 
    setof(Y, ингредиент(Y), IngredientsList),
    runViewer(IngredientsList).

runViewer(IngredientList):-

     app_services:getI18nValue("guiMainWindowTitle", MainWindowTitle),
     new(CulinaryHelper, frame(MainWindowTitle)),

     send(CulinaryHelper, append, new(Menu, tool_dialog)),
     send(CulinaryHelper, append, new(IngredientsBrowser, browser)),
     send(CulinaryHelper, append, new(DialogPanel, dialog)),
     send(CulinaryHelper, append, new(MainTextArea, view(size := size(50,20)))),
     
     send(MainTextArea, right, IngredientsBrowser),
     send(DialogPanel, below, IngredientsBrowser),
     send(Menu, above, IngredientsBrowser),

     send(Menu, append, new(MenuBar, menu_bar)),
     app_services:getI18nValue("guiMainMenuFileItem", MainMenuFileItem),
     send(MenuBar, append, new(FileMenuItem, popup(MainMenuFileItem))),
     app_services:getI18nValue("guiMainMenuExitItem", MainMenuExitItem),
     send_list(FileMenuItem, append, [menu_item(MainMenuExitItem, message(CulinaryHelper, destroy))]),
          
     send_list(IngredientsBrowser, append, IngredientList),
     send(IngredientsBrowser, open_message, message(@prolog, setTextToMainTextArea, MainTextArea, @arg1?key)),
     
     send(CulinaryHelper, open).
     
setTextToMainTextArea(TextArea, Ingredient):- 
     send(TextArea, clear),
     getDataForIngredient(Ingredient, ResultString),
     send(TextArea, append, ResultString).  