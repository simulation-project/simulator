/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ms_app;

import com.ericsson.otp.erlang.OtpErlangDecodeException;
import com.ericsson.otp.erlang.OtpErlangExit;
import com.iti.telecom.beans.MS;
import com.iti.telecom.editor.BasicGraphEditor;
import com.mxgraph.model.mxCell;
import com.mxgraph.view.mxGraph;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.*;

/**
 *
 * @author somaya
 */
public class ms_form extends JDialog {

    sendtoerl serl;
    String imsi;
    boolean mson = false;
    private MS mobileStation;   //  This is Mobile Station Object
    private JFrame parent = null;
    private mxGraph graph;
    private mxCell cell;
    private BasicGraphEditor editor;
    // String[] lais;
    static public Vector<String> lai_vect = new Vector<String>();
    static public Vector<String> used_imsi_vect = new Vector<String>();
    static public Vector<String> imsi_vect = new Vector<String>();
    /**
     * Creates new form ms_form
     */
    public ms_form(JFrame parent, BasicGraphEditor editor, Object cell, mxGraph graph, mxCell agentsCell) {
        super(parent);

        serl = new sendtoerl();
        lai_vect.clear();
        lai_vect = DatabaseHandler.getlais();
        imsi_vect.clear();
        imsi_vect = DatabaseHandler.getimsis();

        initComponents();
        //jComboBox1.setToolTipText(" ");

        setVerifiers();



        this.parent = parent;
        this.editor = editor;
        this.graph = graph;
        this.cell = agentsCell;
        this.mobileStation = (MS) cell;
        getCellProperties();
  //      mcc.setText("MCC");
  //      mnc.setText("MNC");
  //      msin.setText("        MSIN");
        
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        mcc = new javax.swing.JTextField();
        mnc = new javax.swing.JTextField();
        msin = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jComboBox1 = new javax.swing.JComboBox(lai_vect);
        jLabel15 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("MS Form");
        setResizable(false);

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Mobile Station Form"));

        jLabel2.setFont(new java.awt.Font("Ubuntu", 0, 14)); // NOI18N
        jLabel2.setText("IMSI :");

        jLabel4.setFont(new java.awt.Font("Ubuntu", 0, 12)); // NOI18N
        jLabel4.setText("LAI :");

        jButton1.setText("Submit");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        mcc.setText("MCC");
        mcc.setRequestFocusEnabled(false);
        mcc.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                mccFocusGained(evt);
            }
        });

        mnc.setText("MNC");
        mnc.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                mncFocusGained(evt);
            }
        });

        msin.setText("                    MSIN");
        msin.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                msinActionPerformed(evt);
            }
        });
        msin.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                msinFocusGained(evt);
            }
        });

        jLabel6.setText("-");

        jLabel7.setText("-");

        jComboBox1.setEditable(true);
        jComboBox1.addPopupMenuListener(new javax.swing.event.PopupMenuListener() {
            public void popupMenuCanceled(javax.swing.event.PopupMenuEvent evt) {
            }
            public void popupMenuWillBecomeInvisible(javax.swing.event.PopupMenuEvent evt) {
                jComboBox1PopupMenuWillBecomeInvisible(evt);
            }
            public void popupMenuWillBecomeVisible(javax.swing.event.PopupMenuEvent evt) {
            }
        });
        jComboBox1.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                jComboBox1ItemStateChanged(evt);
            }
        });
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGap(209, 209, 209)
                                .addComponent(jLabel10))
                            .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 197, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(178, 178, 178)
                        .addComponent(jButton1))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(mcc, javax.swing.GroupLayout.PREFERRED_SIZE, 56, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(mnc, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(msin, javax.swing.GroupLayout.PREFERRED_SIZE, 159, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(375, 375, 375)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel17, javax.swing.GroupLayout.PREFERRED_SIZE, 73, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(141, 141, 141)
                        .addComponent(jLabel16, javax.swing.GroupLayout.PREFERRED_SIZE, 83, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(628, 628, 628)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel13, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel14))
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel17, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                        .addGap(16, 16, 16)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(mnc)
                                .addComponent(mcc, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel2))
                            .addGroup(jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 16, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(msin, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))))
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel13, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addComponent(jLabel10)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jButton1)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel14, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(40, 40, 40))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, 625, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, 151, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(150, 150, 150))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, 166, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    public  void switchOn()
    {
        try {
            String imsi1 = mobileStation.getSimsi1() + mobileStation.getSimsi2() + mobileStation.getSimsi3();
            serl.sendimsiattach(imsi1, "turn_on_idle");
            
       mobileStation.setnormallu(true);
            
        } catch (Exception ex) {
            Logger.getLogger(ms_form.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public  void switchOff()
    {
        try {
            String imsi1 = mobileStation.getSimsi1() + mobileStation.getSimsi2() + mobileStation.getSimsi3();
            System.out.println(imsi1);
            serl.sendimsideattach(imsi1, "turn_off");
            
       mobileStation.setnormallu(false);
            
        } catch (Exception ex) {
            Logger.getLogger(ms_form.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    
    
    
    
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        // TODO add your handling code here:
        //     String ms_name = jTextField10.getText();
        //  mobileStation.setMsNumber(ms_name);
        /**
         * ****IMSI String******
         */
        
        mobileStation.setSimsi1(mcc.getText());
        mobileStation.setSimsi2(mnc.getText());
        mobileStation.setSimsi3(msin.getText());
        imsi = mobileStation.getSimsi1() + mobileStation.getSimsi2() + mobileStation.getSimsi3();

        /**
         * ****MSISDN String******
         */
//        mobileStation.setSmsisdn1(cc.getText());
//        mobileStation.setSmsisdn2(ndc.getText());
//        mobileStation.setSmsisdn3(sn.getText());
        //String msisdn = mobileStation.getSmsisdn1() + mobileStation.getSmsisdn2() + mobileStation.getSmsisdn3();
        //BasicGraphEditor.logMsg("MSISDN="+msisdn);
        /**
         * ****Location Area String******
         */
        //      mobileStation.setSlai1(LAmcc.getText());
        //    mobileStation.setSlai2(LAmnc.getText());
        //    mobileStation.setSlai3(lac.getText());
        String lai = (String) jComboBox1.getSelectedItem();
        mobileStation.setSlai1(lai);
        if(lai != null && imsi !=null){
            if(checkimsi(imsi)){
                if(checkusedimsi(imsi)){
        try {
            serl.sendnewms("ms_name", imsi, lai);
             lai_vect.add(lai); 
             used_imsi_vect.add(imsi);
        } catch (Exception ex) {
            
            String message = ex.getMessage();
            BasicGraphEditor.logMsg("Error : "+message );
        }
        mobileStation.setaftersubmit(false);
        mson = true;
        mobileStation.setFormObject(this);
        mobileStation.setSwitchedOn(true);
        mobileStation.setMsNumber(imsi);
        dispose();
                }
                else
                    JOptionPane.showMessageDialog(this, "This IMSI is used, Try another one");
        }
            else
               // jLabel15.setText("IMSI doesn't exist in any HLR");
                JOptionPane.showMessageDialog(this, "This IMSI doesn't exist in any HLR, Please enter any of these IMSIs:\n"+getAllIMSI(imsi_vect));
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jComboBox1ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_jComboBox1ItemStateChanged
/*
        if (mscon == true) {
            System.out.println("item event");
            
            String mslai;
            mslai = (String) jComboBox1.getSelectedItem();
            mobileStation.setSlai1(mslai);
            try {
                serl.sendnormallu(imsi,mslai);
            } catch (Exception ex) {
                Logger.getLogger(ms_form.class.getName()).log(Level.SEVERE, null, ex);
            } 

        }*/
        // TODO add your handling code here:
    }//GEN-LAST:event_jComboBox1ItemStateChanged

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed

        
        // TODO add your handling code here:
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void jComboBox1PopupMenuWillBecomeInvisible(javax.swing.event.PopupMenuEvent evt) {//GEN-FIRST:event_jComboBox1PopupMenuWillBecomeInvisible

         System.out.println("item event0000000");
                   
        if (mobileStation.getnormallu()) {
            
            if(! mobileStation.getSlai1().equals((String)jComboBox1.getSelectedItem()))
            {
            System.out.println("item event");
            
            String mslai;
            mslai = (String) jComboBox1.getSelectedItem();
            mobileStation.setSlai1(mslai);
            try {
          String imsi2 = mobileStation.getSimsi1() + mobileStation.getSimsi2() + mobileStation.getSimsi3();

                serl.sendnormallu(imsi2,mslai);
            } catch (Exception ex) {
                Logger.getLogger(ms_form.class.getName()).log(Level.SEVERE, null, ex);
            } 

        }}        // TODO add your handling code here:
    }//GEN-LAST:event_jComboBox1PopupMenuWillBecomeInvisible

    private void msinFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_msinFocusGained
        // TODO add your handling code here:
        if (mobileStation.getaftersubmit()) {
            msin.setText("");
        }
    }//GEN-LAST:event_msinFocusGained

    private void msinActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_msinActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_msinActionPerformed

    private void mncFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_mncFocusGained
        // TODO add your handling code here:
        if (mobileStation.getaftersubmit()) {
            mnc.setText("");
        }
    }//GEN-LAST:event_mncFocusGained

    private void mccFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_mccFocusGained
        // TODO add your handling code here:
        //     if (mobileStation.getaftersubmit())
        //     mcc.setText("");
    }//GEN-LAST:event_mccFocusGained

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JTextField mcc;
    private javax.swing.JTextField mnc;
    private javax.swing.JTextField msin;
    // End of variables declaration//GEN-END:variables

    public static boolean isNumeric(String aStringValue) {
        Pattern pattern = Pattern.compile("\\d+");
        Matcher matcher = pattern.matcher(aStringValue);
        return matcher.matches();
    }

    private void setVerifiers() {
        mcc.setInputVerifier(new mccverifier());
//        cc.setInputVerifier(new ccverifier());
        //   LAmcc.setInputVerifier(new LAmccverifier());
        mnc.setInputVerifier(new mncverifier());
//        ndc.setInputVerifier(new ndcverifier());
        //    LAmnc.setInputVerifier(new LAmncverifier());
        msin.setInputVerifier(new msinverifier());
//        sn.setInputVerifier(new snverifier());
        //    lac.setInputVerifier(new lacverifier());
    }

    private void getCellProperties() {
        // TODO add your handling code here:
//        jTextField10.setText(mobileStation.getMsNumber());
        /**
         * ****IMSI String******
         */
        mcc.setText(mobileStation.getSimsi1());
        mnc.setText(mobileStation.getSimsi2());
        msin.setText(mobileStation.getSimsi3());
        /**
         * ****MSISDN String******
         */
//        cc.setText(mobileStation.getSmsisdn1());
//        ndc.setText(mobileStation.getSmsisdn2());
//        sn.setText(mobileStation.getSmsisdn3());
        /**
         * ****Location Area String******
         */
        jComboBox1.setSelectedItem(mobileStation.getSlai1());
        //      LAmnc.setText(mobileStation.getSlai2());
        //     lac.setText(mobileStation.getSlai3());


        mcc.setEnabled(mobileStation.getaftersubmit());
        mnc.setEnabled(mobileStation.getaftersubmit());
        msin.setEnabled(mobileStation.getaftersubmit());
        jButton1.setEnabled(mobileStation.getaftersubmit());

    }

    class mccverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel15.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 3) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel15.setText("MCC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class LAmccverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel17.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 3) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel17.setText(" MCC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class mncverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel15.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 2) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel15.setText(" MNC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class LAmncverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel17.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 2) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel17.setText(" MNC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class snverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel16.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 10) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel16.setText(" SN Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class lacverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel17.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                int lac = Integer.parseInt(textField.getText());
                bool = true;
            }
            if (!bool) {
                jLabel17.setText(" LAC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class ndcverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel16.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 2 || textField.getText().length() == 3) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel16.setText("NDC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class ccverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel16.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 2 || textField.getText().length() == 3) {
                    bool = true;
                }
            }
            if (!bool) {
                jLabel16.setText(" CC Error");
                textField.setText("");
            }
            return bool;
        }
    }

    class msinverifier extends InputVerifier {

        boolean bool = false;

        public boolean verify(JComponent input) {
            JTextField textField = (JTextField) input;
            jLabel15.setText("");
            if (ms_form.isNumeric(textField.getText())) {
                if (textField.getText().length() == 10) {
                    bool = true;
                }
                jLabel15.setText("");
            }
            if (!bool) {
                jLabel15.setText(" MSIN Error");
                textField.setText("");
            }
            return bool;
        }
    }

    public static boolean checkimsi(String imsi)
    {
        //Vector<String> imsi_Vector = DatabaseHandler.getimsis();
        for (String str : imsi_vect)
        {
            if(imsi.equals(str))
                return true;
        }
        return false;
    }

    public static boolean checkusedimsi(String imsi)
    {
        //Vector<String> imsi_Vector = DatabaseHandler.getimsis();
        for (String str : used_imsi_vect)
        {
            if(imsi.equals(str))
                imsi_vect.remove(str);
                return false;
        }
        return true;
    }
    
     public static String getAllIMSI(Vector<String> vect)
        {
            String allimsi = "";
            for(String str : vect)
            {
                allimsi +=str+"\n";
                System.out.println(allimsi);
                //allimsi = allimsi.concat(", ");
            
            }
            return allimsi;
        }
    
    
}
