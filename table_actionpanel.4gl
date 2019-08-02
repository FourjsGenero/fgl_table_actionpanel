FUNCTION append_actionpanel_to_table(f)
DEFINE f ui.Form

DEFINE nl om.NodeList
DEFINE root_node,table_node,parent_node, grid_node,hbox_node,label_node om.DomNode
DEFINE tab_name STRING
DEFINE i INTEGER

    LET root_node = f.getNode()
    LET nl = root_node.selectByTagName("Table")
    FOR i = 1 TO nl.getLength()
        LET table_node = nl.item(i)
        LET tab_name = table_node.getAttribute("tabName")

        -- Table must have VBOX node as parent.  If not move onto to next table             
        LET parent_node = table_node.getParent()
        IF parent_node.getTagName() != "VBox" THEN
           CONTINUE FOR
        END IF

        -- Use a value of actionpanel inside tag attribute to determine if add
        -- actionpanel
        IF table_node.getAttribute("tag") MATCHES "*actionpanel*" THEN
            #OK
        ELSE
            CONTINUE FOR
        END IF

        LET hbox_node = parent_node.createChild("HBox")

        -- add node that will stretch, in this case empty image so that panel is centered
        CALL add_empty_image(hbox_node)

        LET grid_node = hbox_node.createChild("Grid")

        -- add buttons on left hand side
        CALL add_table_button(grid_node,tab_name,"find",1)
        CALL add_table_button(grid_node,tab_name,"firstrow",3)
        CALL add_table_button(grid_node,tab_name,"prevpage",5)
        CALL add_table_button(grid_node,tab_name,"prevrow",7)

        -- add a label in middle for text
        LET label_node = grid_node.createChild("Label")
        CALL label_node.setAttribute("name",SFMT("lbl_%1", tab_name))
        CALL label_node.setAttribute("width",8)
        CALL label_node.setAttribute("sizePolicy","fixed")
        CALL label_node.setAttribute("justify","center")
        CALL label_node.setAttribute("posX",9)

        -- add buttons on right hand side
        CALL add_table_button(grid_node,tab_name,"nextrow",17)
        CALL add_table_button(grid_node,tab_name,"nextpage",19)
        CALL add_table_button(grid_node,tab_name,"lastrow",21)
        CALL add_table_button(grid_node,tab_name,"append", 23)

        -- add node that will stretch, in this case empty image so that panel is centered
        CALL add_empty_image(hbox_node)
    END FOR
END FUNCTION



FUNCTION set_currentrow_text(tab_name)
DEFINE tab_name STRING
DEFINE scope STRING
DEFINE current_row, row_count INTEGER

DEFINE lbl_name STRING
DEFINE value STRING

DEFINE label_node, root_node, table_node om.DomNode
DEFINE w ui.Window
DEFINE f ui.Form
DEFINE i INTEGER
DEFINE nl om.NodeList

    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    LET root_node = f.getNode()
    LET nl = root_node.selectByTagName("Table")
    FOR i = 1 TO nl.getLength()
        LET table_node = nl.item(i)
        LET scope = table_node.getAttribute("tabName")
        IF scope = tab_name THEN
            LET current_row = table_node.getAttribute("currentRow") + 1
            LET row_count = table_node.getAttribute("size")

            -- If you have arrays greater than 99999 in size, you may have to amend <<<<<
            LET value =  IIF(row_count>0,SFMT("%1 of %2", current_row USING "<<<<<", row_count USING "<<<<<"),"No rows") 

            LET lbl_name = SFMT("lbl_%1", scope)
            LET label_node = f.findNode("Label", lbl_name)
            IF label_node IS NOT NULL THEN
                CALL label_node.setAttribute("text",value)
            END IF
        END IF
    END FOR
END FUNCTION



-- This is a special case of the set_currentrow_text
-- It needs to be called by ON DELETE.  
-- If there is a row, the set_currentrow_text in BEFORE ROW will override this text
-- if there is no row ie deleted last row, then this text will remain in place
-- this is because there is no trigger called after ON DELETE is called on the last row
FUNCTION after_delete_text(tab_name)
DEFINE tab_name STRING
DEFINE scope STRING
DEFINE lbl_name STRING
DEFINE value STRING
DEFINE label_node, root_node, table_node om.DomNode

DEFINE w ui.Window
DEFINE f ui.Form
DEFINE i INTEGER
DEFINE nl om.NodeList

    LET w = ui.Window.getCurrent()
    LET f = w.getForm()
    LET root_node = f.getNode()
    LET nl = root_node.selectByTagName("Table")
    FOR i = 1 TO nl.getLength()
        LET table_node = nl.item(i)
        LET scope = table_node.getAttribute("tabName")
        IF scope = tab_name THEN
            LET value = "No rows" 

            LET scope = table_node.getAttribute("tabName")
            LET lbl_name = SFMT("lbl_%1", scope)
            LET label_node = f.findNode("Label", lbl_name)
            IF label_node IS NOT NULL THEN
                CALL label_node.setAttribute("text",value)
            END IF
        END IF
    END FOR
END FUNCTION



PRIVATE FUNCTION add_table_button(grid_node, tab_name, name,x)
DEFINE tab_name STRING
DEFINE name STRING
DEFINE grid_node, button_node om.DomNode
DEFINE x INTEGER

    LET button_node = grid_node.createChild("Button")
    CALL button_node.setAttribute("name",SFMT("%1.%2", tab_name, name))
    CALL button_node.setAttribute("text","")
    CALL button_node.setAttribute("posX",x)
END FUNCTION



PRIVATE FUNCTION add_empty_image(hbox_node)
DEFINE hbox_node, grid_node, image_node om.DomNode

    LET grid_node = hbox_node.createChild("Grid")
    LET image_node = grid_node.createChild("Image")
    CALL image_node.setAttribute("image","empty")
    CALL image_node.setAttribute("style","empty")
END FUNCTION