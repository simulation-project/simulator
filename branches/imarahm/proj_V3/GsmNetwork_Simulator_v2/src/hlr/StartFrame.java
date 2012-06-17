/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package hlr;

import com.iti.telecom.editor.BasicGraphEditor;
import com.mxgraph.model.mxCell;
import com.mxgraph.view.mxGraph;
import hlr.HLRForm;
import javax.swing.JFrame;

/**
 *
 * @author ahmed
 */
public class StartFrame extends javax.swing.JFrame {

    /**
     * Creates new form StartFrame
     */
    HLRForm hf;
    String hlrName;
    long startRange,endRane;
    private com.iti.telecom.beans.HLR hlr;
    private JFrame parent = null;
    private mxGraph graph;
    private mxCell cell;
    private BasicGraphEditor editor;


    public StartFrame(JFrame parent, BasicGraphEditor editor, Object cell, mxGraph graph, mxCell agentsCell) {
        initComponents();
        this.parent = parent;
        this.editor = editor;
        this.graph = graph;
        this.cell = agentsCell;
        System.out.println("before hlr asigning");
        this.hlr = (com.iti.telecom.beans.HLR) cell;
        hf=new HLRForm();
        getCellProperties();
        System.out.println("after hlr assigning");
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        confBtn = new javax.swing.JButton();
        subBtn = new javax.swing.JButton();
        addMscBtn = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        confBtn.setText("edit Configuration ");
        confBtn.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                confBtnMouseClicked(evt);
            }
        });

        subBtn.setText("add subscriber");
        subBtn.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                subBtnMouseClicked(evt);
            }
        });

        addMscBtn.setText("Add Msc info");
        addMscBtn.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                addMscBtnMouseClicked(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(38, 38, 38)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(subBtn)
                    .addComponent(confBtn, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(addMscBtn, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(57, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(43, 43, 43)
                .addComponent(confBtn)
                .addGap(43, 43, 43)
                .addComponent(addMscBtn)
                .addGap(54, 54, 54)
                .addComponent(subBtn)
                .addContainerGap(77, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void confBtnMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_confBtnMouseClicked
            // TODO add your handling code here:
//        hf=new HLRForm();
        hf.setVisible(true);
        hf.setSize(300,300);
    }//GEN-LAST:event_confBtnMouseClicked

    private void subBtnMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_subBtnMouseClicked
        // TODO add your handling code here:
        getInfo();
        SubscriberForm sf=new SubscriberForm();
        sf.setSize(300,300);
        sf.setVisible(true);
        sf.setInfo(hlrName,startRange,endRane);
    }//GEN-LAST:event_subBtnMouseClicked

    private void addMscBtnMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_addMscBtnMouseClicked
        // TODO add your handling code here:
        MscForm mf=new MscForm();
        mf.setVisible(true);
        mf.setSize(300,300);
    }//GEN-LAST:event_addMscBtnMouseClicked

    /**
     * @param args the command line arguments
     */

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton addMscBtn;
    private javax.swing.JButton confBtn;
    private javax.swing.JButton subBtn;
    // End of variables declaration//GEN-END:variables

    private void getInfo() {
        startRange=hf.getStartRange();
        endRane=hf.getendRange();
        hlrName=hf.getHlrName();
    }
    public void getCellProperties() {
        System.out.println("get cell properties");
        hf.setGtTf(hlr.getGt());
        hf.setNispcTf(hlr.getNiSpc());
        //hf.stNispcTf(hlr.getNiSpc());
        hf.setHlrNameTf(hlr.getHlrName());
        System.out.println("get cell properties 2");
        hf.setStartRangeTf(hlr.getStartRange());
        hf.setEndRangeTf(hlr.getendRange());
        System.out.println("get cell properties end");

    }
}
