/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iti.telecom.beans;

import com.iti.telecom.cells.ui.MSCellUI;
import com.iti.telecom.editor.BasicGraphEditor;
import com.mxgraph.model.mxCell;
import com.mxgraph.view.mxGraph;
import javax.swing.JFrame;
import ms_app.ms_form;
import msc.Msc_Screen;

/**
 *
 * @author ahmed_amer
 */
public class CellPropertise {

    private Object cellBean;
    private mxGraph graph;
    private mxCell cell;
    private BasicGraphEditor basicGraphEditor;
    private JFrame parent;

    public CellPropertise() {
    }

    public CellPropertise(Object cellBean, mxGraph graph, mxCell cell, BasicGraphEditor basicGraphEditor, JFrame parent) {
        this.cellBean = cellBean;
        this.graph = graph;
        this.cell = cell;
        this.basicGraphEditor = basicGraphEditor;
        this.parent = parent;
        System.out.println("Constructor !!!");
    }

    public void populatePropertiesWindow() {
        if (this.cellBean instanceof MSC) {
            new Msc_Screen(this.parent, this.basicGraphEditor, this.cellBean, this.graph, this.cell);
        } else if (this.cellBean instanceof MS) {
            new ms_form(parent, basicGraphEditor, cellBean, graph, cell).setVisible(true);
            
        }
            else if(this.cellBean instanceof HLR)
            {
                new hlr.StartFrame(parent, basicGraphEditor, cellBean, graph, cell).setVisible(true);
            }
    }
}
