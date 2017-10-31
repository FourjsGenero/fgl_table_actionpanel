# fgl_table_actionpanel
Library to add an "actionpanel" beneath a table containing actions with scope on that table 

![fgl_table_actionpanel example screenshot](https://user-images.githubusercontent.com/13615993/32205891-c86c1ca6-be56-11e7-943a-ce70591c52e0.png)

## Usage
IMPORT FGL table_actionpanel

Call the function table_actionpanel.append_actionpanel_to_table() inside a ui.Form.setDefaultInitializer, and for every table in the form it will then add a GRID containing a number of BUTTONS and a LABEL (the "action panel" of the title) if the following conditions are met ...
* The TABLE has as its parent a VBOX container
* The TABLE's STYLE attribute contains the value actionpanel

The buttons added will include actions for find and append, and six table navigation actions.  Also added will be a LABEL which is used to populate with row X of Y messages

In the DISPLAY ARRAY or INPUT ARRAY add the line "CALL table_actionpanel.set_currentrow_text()"  at the end of the BEFORE DISPLAY, BEFORE INPUT, BEFORE ROW so that the label containing the row X of Y text is updated.

Take this as a starting point and feel free to modify the actions that are catered for in the TABLE action panel and modify appearane as you see fit.
