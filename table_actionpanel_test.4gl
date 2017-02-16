IMPORT FGL table_actionpanel
PUBLIC CONSTANT UPDATE_IMAGE = "fa-pencil"
PUBLIC CONSTANT DELETE_IMAGE = "fa-minus"


MAIN
DEFINE arr1 DYNAMIC ARRAY OF RECORD
    field11, field12 STRING,
    update1, delete1 STRING
END RECORD
DEFINE arr2 DYNAMIC ARRAY OF RECORD
    field21, field22 STRING,
    update2, delete2 STRING
END RECORD
DEFINE arr3 DYNAMIC ARRAY OF RECORD
    field31, field32 STRING,
    update3, delete3 STRING
END RECORD
DEFINE i INTEGER

    OPTIONS FIELD ORDER FORM
    OPTIONS INPUT WRAP
    CALL ui.Interface.loadActionDefaults("table_actionpanel_test")
    CALL ui.Interface.loadStyles("table_actionpanel_test")

    --  Populate first array, leave second array empty to test append still works and no rows message
    FOR i = 1 TO 100
        LET arr1[i].field11 = i
        LET arr1[i].field12 = i*100
        LET arr1[i].update1 = UPDATE_IMAGE
        LET arr1[i].delete1 = DELETE_IMAGE
    END FOR

    CALL ui.Form.setDefaultInitializer("init_form")
    OPEN WINDOW w WITH FORM "table_actionpanel_test"

    -- 
    DIALOG ATTRIBUTES(UNBUFFERED)
        DISPLAY ARRAY arr1 TO scr1.* 
            BEFORE ROW
                CALL table_actionpanel.set_currentrow_text()
            ON APPEND
                INPUT arr1[arr_curr()].* FROM scr1[scr_line()].* ATTRIBUTES(WITHOUT DEFAULTS=FALSE);
                LET arr1[arr_curr()].update1 = UPDATE_IMAGE
                LET arr1[arr_curr()].delete1 = DELETE_IMAGE
            ON UPDATE
                INPUT arr1[arr_curr()].* FROM scr1[scr_line()].* ATTRIBUTES(WITHOUT DEFAULTS=TRUE);
            ON DELETE
        END DISPLAY
        
        DISPLAY ARRAY arr2 TO scr2.*
            BEFORE ROW
                CALL table_actionpanel.set_currentrow_text()
            ON APPEND
                INPUT arr2[arr_curr()].* FROM scr2[scr_line()].* ATTRIBUTES(WITHOUT DEFAULTS=FALSE);
                LET arr2[arr_curr()].update2 = UPDATE_IMAGE
                LET arr2[arr_curr()].delete2 = DELETE_IMAGE
            ON UPDATE
                INPUT arr2[arr_curr()].* FROM scr2[scr_line()].* ATTRIBUTES(WITHOUT DEFAULTS=TRUE);
            ON DELETE
        END DISPLAY

         DISPLAY ARRAY arr3 TO scr3.*
           ON APPEND
                INPUT arr3[arr_curr()].* FROM scr3[scr_line()].* ATTRIBUTES(WITHOUT DEFAULTS=FALSE);
                LET arr3[arr_curr()].update3 = UPDATE_IMAGE
                LET arr3[arr_curr()].delete3 = DELETE_IMAGE
            ON UPDATE
                INPUT arr3[arr_curr()].* FROM scr3[scr_line()].* ATTRIBUTES(WITHOUT DEFAULTS=TRUE);
            ON DELETE
        END DISPLAY
        
        BEFORE DIALOG  
            CALL table_actionpanel.set_currentrow_text()
            
        ON ACTION close
            EXIT DIALOG
    END DIALOG
END MAIN



FUNCTION init_form(f)
DEFINE f ui.Form

    -- Call library method that will append an actionpanel to a table
    CALL table_actionpanel.append_actionpanel_to_table(f)
END FUNCTION