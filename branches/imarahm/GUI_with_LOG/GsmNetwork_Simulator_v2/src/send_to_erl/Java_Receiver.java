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
                System.out.println("recieve something");
                linecount++;
            } catch (Exception ex) {
                System.out.println(ex);
                continue;
            }

            System.out.println("reiceived :: " + o);
            BasicGraphEditor.logMsg("reiceived :: " + o);
            OtpErlangAtom oat = (OtpErlangAtom) o;
            //                  OtpErlangList oat = (OtpErlangList) o;
            String ost = oat.toString();
            String[] oarr = ost.split("|");

            if (oarr[0].equals("outpulog")) {
                BasicGraphEditor.logMsg("line" + linecount);
                BasicGraphEditor.logMsg("logger ----- " + oarr[1]);
//                System.out.println("line" + linecount);
//                System.out.println("logger ----- " + oarr[1]);
                BasicGraphEditor.logMsg(oarr[1]);
            }

        }
//          NewJFrame.jTextArea1.append(linecount+": "+o+"\n");

    }
}
