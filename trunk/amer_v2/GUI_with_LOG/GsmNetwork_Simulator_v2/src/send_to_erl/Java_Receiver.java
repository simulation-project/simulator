/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package send_to_erl;

import com.ericsson.otp.erlang.*;
import com.iti.telecom.editor.BasicGraphEditor;
import java.io.IOException;
import java.net.InetAddress;
import java.util.logging.Level;
import java.util.logging.Logger;
import ms_app.MsStatusForm;
import ms_app.ms_form;

/**
 *
 * @author alaa
 */
public class Java_Receiver extends Thread {

    OtpNode node = null;
    OtpErlangObject o = null;
    OtpMbox mbox;
    //  int linecount = 0;

    public Java_Receiver() {

        try {
            node = new OtpNode("java_receiver@localhost");//+InetAddress.getLocalHost().getHostName());//alaa-laptop");//, "zed"); // name, cookie
        } catch (IOException ex) {
            System.out.println(ex);
            System.exit(-1);
        }
        mbox = node.createMbox("mbox");
        start();
    }

    public void run() {
        System.out.println("Receiving");
        BasicGraphEditor.logMsg("Receiving ....");
        int linecount = 0;

        while (true) {

            try {
                o = mbox.receive();
                System.out.println("receive something");
                linecount++;
            } catch (Exception ex) {
                System.out.println(ex);
                continue;
            }

            System.out.println("received :: " + o);
//            BasicGraphEditor.logMsg("reiceived :: " + o);
            OtpErlangAtom oat = (OtpErlangAtom) o;
            //                  OtpErlangList oat = (OtpErlangList) o;
            String ost = oat.toString();
            //String[] oarr = ost.split('|');
            int index = ost.indexOf('|');
            String signal = ost.substring(1, index);

            String msg = ost.substring(index + 1, ost.length() - 1);

            System.out.println("msg000 : " + signal);

            System.out.println("msg1111 : " + msg);


            if (signal.equals("outputlog")) {
                //  BasicGraphEditor.logMsg("line" + linecount);
                BasicGraphEditor.logMsg(msg);
//                System.out.println("line" + linecount);
//                System.out.println("logger ----- " + oarr[1]);
                //BasicGraphEditor.logMsg(oarr[1]);
            }

            if (signal.equals("signal")) {
                BasicGraphEditor.logMsg(msg);
                //int index1 = msg.indexOf(',');
                //String msg1 = msg.substring(1,index1);
                //String msg2 = msg.substring(index1+1,msg.length()-1);
                //System.out.println(msg1);
                //System.out.println(msg2);
                String[] msg1 = msg.split(",");
                if (msg1[0].equals("receiving_call")) { // B numb
                    System.out.println("marwaaaa");


                    com.iti.telecom.main.GraphEditor.mobile.get(msg1[1]).ms_receive_call.setVisible(true);

                    /*
                     * if(ms_form.ms_receive_call.imsi.equals(msg1[1])) {
                     * ms_form.ms_receive_call.setVisible(true);
                     * ms_form.ms_receive_call.jLabel2.setText(msg1[2]+"
                     * "+msg1[1]); System.out.println(msg1[1]);
                    }
                     */
                }

                if (msg1[0].equals("alert_msg")) {   // A numb
                    System.out.println("marwaaaa");
                    com.iti.telecom.main.GraphEditor.mobile.get(msg1[1]).ms_call.setVisible(true);

                    /*
                     * if(ms_form.ms_call.imsi.equals(msg1[1])) {
                     * ms_form.ms_call.setVisible(true);
                     * ms_form.ms_call.transferFocus();
                     * ms_form.ms_call.jLabel3.setText("Alert Msg");
                    }
                     */
                }

                if (msg1[0].equals("connected")) {   /// A numb
                    System.out.println("marwaaaa");
                    com.iti.telecom.main.GraphEditor.mobile.get(msg1[1]).ms_call.jLabel3.setText("connected");

                    /*
                     * if(ms_form.ms_call.imsi.equals(msg1[1])) {
                     * ms_form.ms_call.setVisible(true);
                     * ms_form.ms_call.jLabel3.setText("connected");
                     * //System.out.println(msg1[1]);
                    }
                     */
                }



            }

        }
//          NewJFrame.jTextArea1.append(linecount+": "+o+"\n");

    }
}
