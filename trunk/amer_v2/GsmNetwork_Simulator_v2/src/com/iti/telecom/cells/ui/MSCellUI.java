/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iti.telecom.cells.ui;

import com.iti.telecom.beans.MSC;
import com.iti.telecom.editor.BasicGraphEditor;
import com.mxgraph.model.mxCell;
import com.mxgraph.model.mxGeometry;
import com.mxgraph.util.mxPoint;
import com.mxgraph.view.mxGraph;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

/**
 *
 * @author ahmed_amer
 */
public class MSCellUI extends JDialog {

    private JFrame parent = null;
    private MSC msc;
    private mxGraph graph ;
    private mxCell cell ;
    private BasicGraphEditor editor;
    private JButton save;
    private JLabel name;
    private JTextField nameTextField;

    public MSCellUI(JFrame parent, BasicGraphEditor editor, Object cell ,mxGraph graph, mxCell agentsCell) {
        super(parent);
        this.parent = parent;
        this.editor = editor;
        this.graph =graph;
        this.cell=agentsCell;
        initComponents();
        setTitle("MSC UserName Password");
        setLocationRelativeTo(null);
        this.msc = (MSC) cell;
        getCellProperties();
        setVisible(true);
    }

    private void initComponents() {
        this.name = new JLabel("Name : ");
        this.nameTextField = new JTextField();

        this.save = new JButton("Save");
        this.save.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                saveResult(e);
            }

            private void saveResult(ActionEvent e) {
                MSCellUI.this.msc.setMscName(MSCellUI.this.nameTextField.getText());
                MSCellUI.this.msc.setHlrEdge(drawEdge("HLR Connection", 90));
                MSCellUI.this.msc.setMsEdge(drawEdge("MobileStation", 360));
                dispose();
            }

            Object drawEdge(String label, int offset) {
                Object edge = null;
                Object parentCell = MSCellUI.this.graph.getDefaultParent();
                MSCellUI.this.graph.getModel().beginUpdate();
                try {
                    mxGeometry geoCell = MSCellUI.this.cell.getGeometry();
                    mxPoint termPoint = new mxPoint(geoCell.getX() - (120 - offset), geoCell.getY() + 100.0D);

                    edge = MSCellUI.this.graph.insertEdge(parentCell, null, label, MSCellUI.this.cell, null, "edgeStyle=elbowEdgeStyle;elbow=horizontal;orthogonal=0;");

                    mxGeometry geo = MSCellUI.this.graph.getCellGeometry(edge);
                    geo.setTerminalPoint(termPoint, false);
                } finally {
                    MSCellUI.this.graph.getModel().endUpdate();
                }
                return edge;
            }
            private void  removeEdge(Object edge , mxGraph g)
            {
                g.getModel().beginUpdate();
                try{
                    System.out.println(graph.getModel().remove(edge));

                }
                finally{
                    g.getModel().endUpdate();
                }
            }
            
        });
        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING).addGroup(layout.createSequentialGroup().addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING).addGroup(layout.createSequentialGroup().addGap(21, 21, 21).addComponent(name).addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED).addComponent(nameTextField, javax.swing.GroupLayout.DEFAULT_SIZE, 347, Short.MAX_VALUE)).addGroup(layout.createSequentialGroup().addGap(181, 181, 181).addComponent(save))).addContainerGap()));
        layout.setVerticalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING).addGroup(layout.createSequentialGroup().addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE).addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE).addComponent(name).addComponent(nameTextField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)).addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED).addComponent(save).addGap(7, 7, 7)));
        pack();
    }

    private void getCellProperties() {
        this.nameTextField.setText(msc.getMscName());
    }
}
