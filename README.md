# fgl_table_actionpanel
Library to add an "actionpanel" beneath a table containing actions with scope on that table 

![fgl_table_actionpanel example screenshot](https://user-images.githubusercontent.com/13615993/32205891-c86c1ca6-be56-11e7-943a-ce70591c52e0.png)

## Usage
IMPORT FGL table_actionpanel

Call the function table_actionpanel.append_actionpanel_to_table() inside a ui.Form.setDefaultInitializer, and for every table in the form it will then add a GRID containing a number of BUTTONS and a LABEL (the "action panel" of the title) if the following conditions are met ...
* The TABLE has as its parent a VBOX container
* The TABLE's TAG attribute contains the value actionpanel

The buttons added will include actions for find and append, and six table navigation actions.  Also added will be a LABEL which is used to populate with row X of Y messages

In the DISPLAY ARRAY or INPUT ARRAY add the line "CALL table_actionpanel.set_currentrow_text(screen_record_name)"  at the end of the BEFORE DISPLAY, BEFORE INPUT, BEFORE ROW so that the label containing the row X of Y text is updated.

Also after ON DELETE add CALL table_actionpanel.after_delete_text(screen_record_name).  This is needed because no trigger is called in the case of deleting the last row i.e there is no BEFORE ROW.  So this HACK is required to display a message indicating there are no rows.  If there is a row, BEFORE ROW will be called and its set_current_row_text will overwrite this message.

Take this as a starting point and feel free to modify the actions that are catered for in the TABLE action panel and modify appearance as you see fit.
