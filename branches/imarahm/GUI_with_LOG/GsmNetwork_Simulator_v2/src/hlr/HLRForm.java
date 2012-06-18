/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package hlr;

import com.ericsson.otp.erlang.*;
import com.iti.telecom.editor.BasicGraphEditor;
import com.mxgraph.model.mxCell;
import com.mxgraph.view.mxGraph;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;

/**
 *
 * @author ahmed
 */
public class HLRForm extends javax.swing.JFrame {

    /**
     * Creates new form HLRForm
     */
    private DBhandler db;
    private IMSIForm iForm;
    private long imsiRangeE,imsiRangeS;
    private String hlrName;
    
    public HLRForm() {
        
        iForm=new IMSIForm();
        initComponents();
       // setVerifiers();
        
        
        db=new DBhandler();
        db.startConnection();
        System.out.println("end hlr form constructor ");
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
        nameTf = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        NiTf = new javax.swing.JTextField();
        SpcTf = new javax.swing.JTextField();
        GtTf = new javax.swing.JTextField();
        SubmitBtn = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);

        jLabel1.setText("Name:");

        nameTf.setColumns(7);
        nameTf.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nameTfActionPerformed(evt);
            }
        });

        jLabel2.setText("NI:");

        jLabel3.setText("SPC:");

        jLabel4.setText("GT:");

        NiTf.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                NiTfActionPerformed(evt);
            }
        });

        SubmitBtn.setText("Submit");
        SubmitBtn.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                SubmitBtnMouseClicked(evt);
            }
        });

        jButton1.setText("Set IMSI Range");
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jButton1MouseClicked(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel1)
                            .addComponent(jLabel2))
                        .addGap(27, 27, 27)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(NiTf, javax.swing.GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                            .addComponent(nameTf, javax.swing.GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                            .addComponent(SpcTf, javax.swing.GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)
                            .addComponent(GtTf, javax.swing.GroupLayout.DEFAULT_SIZE, 120, Short.MAX_VALUE)))
                    .addComponent(jLabel3)
                    .addComponent(jLabel4))
                .addContainerGap(154, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(244, Short.MAX_VALUE)
                .addComponent(SubmitBtn)
                .addGap(33, 33, 33))
            .addGroup(layout.createSequentialGroup()
                .addGap(56, 56, 56)
                .addComponent(jButton1)
                .addContainerGap(179, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(24, 24, 24)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(nameTf, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(NiTf, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel3)
                    .addComponent(SpcTf, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel4)
                    .addComponent(GtTf, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 54, Short.MAX_VALUE)
                .addComponent(jButton1)
                .addGap(46, 46, 46)
                .addComponent(SubmitBtn)
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void nameTfActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nameTfActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_nameTfActionPerformed

    private void NiTfActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_NiTfActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_NiTfActionPerformed

    private void SubmitBtnMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_SubmitBtnMouseClicked
        try {
            // TODO add your handling code here:
            sendToErlang();
        } catch (SQLException ex) {
            Logger.getLogger(HLRForm.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            createDB(hlrName);
        } catch (SQLException ex) {
            Logger.getLogger(HLRForm.class.getName()).log(Level.SEVERE, null, ex);
        }
        imsiRangeS=iForm.getStart();
        imsiRangeE=iForm.getEnd();
        this.setVisible(false);
    }//GEN-LAST:event_SubmitBtnMouseClicked

    private void jButton1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseClicked
        // TODO add your handling code here:
        iForm.setVisible(true);
        iForm.setSize(300,300);
    }//GEN-LAST:event_jButton1MouseClicked
    private void createDB(String name) throws SQLException
    {
        System.out.println("range "+iForm.getStart()+"  "+iForm.getEnd());
        db.createDB(name,iForm.getStart(),iForm.getEnd());
    }
    private void sendToErlang() throws SQLException
    {
        hlrName = nameTf.getText();
        String hlrSpc = NiTf.getText().concat(SpcTf.getText());
        String hlrGt = GtTf.getText();

        OtpErlangObject[] obj1 = new OtpErlangObject[2];
        OtpErlangAtom ehlrname = new OtpErlangAtom(hlrName);
        OtpErlangAtom ehlrname1 = new OtpErlangAtom("hlr_name");
        obj1[0] = ehlrname;
        obj1[1] = ehlrname1;
        OtpErlangTuple t1 = new OtpErlangTuple(obj1);

        OtpErlangAtom ehlrspc = new OtpErlangAtom(hlrSpc);
        OtpErlangAtom ehlrspc1 = new OtpErlangAtom("spc");
        obj1[0] = ehlrspc;
        obj1[1] = ehlrspc1;
        OtpErlangTuple t2 = new OtpErlangTuple(obj1);

        OtpErlangAtom ehlrgt = new OtpErlangAtom(hlrGt);
        OtpErlangAtom ehlrgt1 = new OtpErlangAtom("gt");
        obj1[0] = ehlrgt;
        obj1[1] = ehlrgt1;
        OtpErlangTuple t3 = new OtpErlangTuple(obj1);

        OtpErlangObject[] obj2 = new OtpErlangObject[3];
        obj2[0] = t1;
        obj2[1] = t2;
        obj2[2] = t3;

        OtpErlangList l1 = new OtpErlangList(obj2);

                OtpErlangObject[] obj3 = new OtpErlangObject[1];
obj3[0] = l1;
try{
//sendtoerl2 sender = new sendtoerl2();////////////////////////
                com.iti.telecom.main.GraphEditor.sender.sendtoerl("newhlr", obj3);
}catch(Exception ex){}

    
    }
    /**
     * @param args the command line arguments
     */
//    public static void main(String args[]) {
//        try {
//            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
//                if ("Nimbus".equals(info.getName())) {
//                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
//                    break;
//                }
//            }
//        } catch (ClassNotFoundException ex) {
//            java.util.logging.Logger.getLogger(HLRForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        } catch (InstantiationException ex) {
//            java.util.logging.Logger.getLogger(HLRForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        } catch (IllegalAccessException ex) {
//            java.util.logging.Logger.getLogger(HLRForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
//            java.util.logging.Logger.getLogger(HLRForm.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        }
//        //</editor-fold>
//
//        /*
//         * Create and display the form
//         */
//        java.awt.EventQueue.invokeLater(new Runnable() {
//
//            public void run() {
//                new HLRForm().setVisible(true);
//            }
//        });
//    }

    public String getHlrName()
    {
        return hlrName;
    }
    public long getStartRange()
    {
        return imsiRangeS;
    }
    public long getendRange()
    {
        return imsiRangeE;
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextField GtTf;
    private javax.swing.JTextField NiTf;
    private javax.swing.JTextField SpcTf;
    private javax.swing.JButton SubmitBtn;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JTextField nameTf;
    // End of variables declaration//GEN-END:variables

    void setGtTf(String gt) {
        GtTf.setText(gt);
    }

    void setNispcTf(String niSpc) {
        NiTf.setText(niSpc);
        SpcTf.setText(niSpc);
    }

    void setHlrNameTf(String hlrName) {
        nameTf.setText(hlrName);
    }

    void setStartRangeTf(long startRange) {
        iForm.setStartTf(startRange);
    }

    void setEndRangeTf(long ENDRange) {
        iForm.setEndTf(ENDRange);
    }


    
}
