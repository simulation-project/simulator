/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package hlr;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

/**
 *
 * @author ahmed
 */
public class SubscriberForm extends javax.swing.JFrame {

    /**
     * Creates new form SubscriberForm
     */
    private DBhandler db;
    private String hlrName;
    private long startRange,endRange;
    private String fullImsi;
    public SubscriberForm() {
        initComponents();
        db=new DBhandler();
        db.startConnection();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        imsiTf = new javax.swing.JTextField();
        subInfoTf = new javax.swing.JTextField();
        addBtn = new javax.swing.JButton();
        closeBtn = new javax.swing.JButton();
        imsiTf1 = new javax.swing.JTextField();
        imsiTf2 = new javax.swing.JTextField();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);

        jLabel1.setText("IMSI");

        jLabel2.setText("MSISDN");

        imsiTf.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                imsiTfActionPerformed(evt);
            }
        });

        addBtn.setText("Add");
        addBtn.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                addBtnMouseClicked(evt);
            }
        });
        addBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                addBtnActionPerformed(evt);
            }
        });

        closeBtn.setText("Close");
        closeBtn.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                closeBtnActionPerformed(evt);
            }
        });

        imsiTf1.setEditable(false);
        imsiTf1.setText("602");
        imsiTf1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                imsiTf1ActionPerformed(evt);
            }
        });

        imsiTf2.setEditable(false);
        imsiTf2.setText("02");
        imsiTf2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                imsiTf2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(22, 22, 22)
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 94, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(79, 79, 79)
                        .addComponent(addBtn, javax.swing.GroupLayout.PREFERRED_SIZE, 64, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(closeBtn, javax.swing.GroupLayout.PREFERRED_SIZE, 51, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(subInfoTf))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(imsiTf1, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(imsiTf2, javax.swing.GroupLayout.PREFERRED_SIZE, 48, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(12, 12, 12)
                                .addComponent(imsiTf, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE)))))
                .addGap(157, 157, 157))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(39, 39, 39)
                .addComponent(jLabel1)
                .addGap(18, 18, 18)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(imsiTf1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(imsiTf2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(imsiTf, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(31, 31, 31)
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(subInfoTf, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(30, 30, 30)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(addBtn, javax.swing.GroupLayout.DEFAULT_SIZE, 40, Short.MAX_VALUE)
                    .addComponent(closeBtn, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(35, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void closeBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_closeBtnActionPerformed
        // TODO add your handling code here:
        this.setVisible(false);
    }//GEN-LAST:event_closeBtnActionPerformed

    private void addBtnMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_addBtnMouseClicked
        try{
        insertImsi(imsiTf.getText(),subInfoTf.getText(),hlrName,startRange,endRange);
        }
     catch(Exception ex){
         System.out.println(ex);
     }
    }//GEN-LAST:event_addBtnMouseClicked

    private void imsiTfActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_imsiTfActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_imsiTfActionPerformed

    private void imsiTf1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_imsiTf1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_imsiTf1ActionPerformed

    private void imsiTf2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_imsiTf2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_imsiTf2ActionPerformed

    private void addBtnActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_addBtnActionPerformed
        // TODO add your handling code here:try{
        try{
            insertImsi(imsiTf.getText(),subInfoTf.getText(),hlrName,startRange,endRange);
        }
     catch(Exception ex){
         System.out.println(ex);
     }
    }//GEN-LAST:event_addBtnActionPerformed

    public void insertImsi(String imsi,String info,String name,long start,long end)
    {
        System.out.println(imsi);
        System.out.println(imsi.length());
        //if(!imsiExist()){
            if(checkRange(imsi)){
                if(checkImsi()){
                try {
                    // TODO add your handling code here:
                    fullImsi="60202";
                    fullImsi+=imsi;
                    System.out.println("full imsi "+fullImsi);
                    db.addSubscriber(fullImsi,info,name);
                    System.out.println(imsi);
                } catch (SQLException ex) {
                    Logger.getLogger(SubscriberForm.class.getName()).log(Level.SEVERE, null, ex);
                }
                imsiTf.setText("");
                subInfoTf.setText("");
                }
                else
                    JOptionPane.showMessageDialog(this, "the length of the imsi should be 10 digits");
                }
            else
                JOptionPane.showMessageDialog(this, "imsi out of range");
       // }
//        else
//            JOptionPane.showMessageDialog(this,"imsi exist");
    }
    /**
     * @param args the command line arguments
     */
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton addBtn;
    private javax.swing.JButton closeBtn;
    private javax.swing.JTextField imsiTf;
    private javax.swing.JTextField imsiTf1;
    private javax.swing.JTextField imsiTf2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JTextField subInfoTf;
    // End of variables declaration//GEN-END:variables

    void setInfo(String hName, String sRange, String eRange) {
     hlrName=hName;
     startRange=Long.parseLong(sRange);
     endRange=Long.parseLong(eRange);
    }

    private boolean  checkRange(String i) {
        long imsi=Long.parseLong(i);
        if(imsi>=startRange&&imsi<=endRange)
            return true;
        else
            return false;
    }

    private boolean checkImsi() {
        if(imsiTf.getText().matches("[0-9]{10}"))
            return true;
        else
            return false;
    }
    private boolean imsiExist()
    {
        try {
            return db.imsiExist(fullImsi,StartFrame.getHlrName());
        } catch (SQLException ex) {
            Logger.getLogger(SubscriberForm.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
