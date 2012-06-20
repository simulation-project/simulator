/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iti.telecom.cells.ui;

import com.iti.telecom.beans.MS;
import com.iti.telecom.beans.MSC;
import com.iti.telecom.editor.BasicGraphEditor;
import com.mxgraph.model.mxCell;
import com.mxgraph.view.mxGraph;
import javax.swing.JDialog;
import javax.swing.JFrame;
import ms_app.ms_form;

/**
 *
 * @author ahmed_amer
 */
public class MS_UI  {

    private JFrame parent = null;
    private MS mobileStation;
    private mxGraph graph;
    private mxCell cell;
    private BasicGraphEditor editor;
    private ms_form mobileStation_Form ;

    public MS_UI(JFrame parent, BasicGraphEditor editor, Object cell, mxGraph graph, mxCell agentsCell) {
        this.parent = parent;
        this.editor = editor;
        this.graph = graph;
        this.cell = agentsCell;
        this.mobileStation =   (MS) cell;
        getCellProperties();

    }

    private void getCellProperties() {

    }
}
