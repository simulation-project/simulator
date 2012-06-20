/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ms_app;

/**
 *
 * @author marwa
 */
import com.ericsson.otp.erlang.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author alaa
 */
public class sendtoerl {

    OtpNode node = null;
    OtpMbox mbox;
    OtpErlangPid pd = null;
    OtpErlangObject[] erlobjs = new OtpErlangObject[2];
    OtpErlangObject[] erlobjs_ms = new OtpErlangObject[2];
    // OtpErlangAtom atom;

    public sendtoerl(){}
    
    public void sendimsiattach(String ms, String locupdate) throws OtpErlangExit, OtpErlangDecodeException, Exception {
        OtpErlangAtom atom1 = new OtpErlangAtom(ms);
        erlobjs_ms[0] = atom1;
        OtpErlangAtom atom2 = new OtpErlangAtom("turn_on_idle");
        erlobjs_ms[1] = atom2;
        OtpErlangTuple t2 = new OtpErlangTuple(erlobjs_ms);
        OtpErlangObject[] ob = new OtpErlangObject[1];
        ob[0] = t2;
                        
        try {
            com.iti.telecom.main.GraphEditor.sender.sendtoerl("mslu", ob);
        } catch (Exception ex) {
            Logger.getLogger(sendtoerl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void sendnewms(String ms_name, String imsi, String lai) throws OtpErlangExit, OtpErlangDecodeException, Exception {
        OtpErlangAtom atom = new OtpErlangAtom(imsi);
        erlobjs[0] = atom;
        //OtpErlangAtom k = new OtpErlangAtom(msisdn);
        //erlobjs[1] = k;
        OtpErlangAtom atom2 = new OtpErlangAtom(lai);
        erlobjs[1] = atom2;
        OtpErlangTuple t1 = new OtpErlangTuple(erlobjs);
        OtpErlangObject[] erlobjs1 = new OtpErlangObject[2];
        erlobjs1[0] = new OtpErlangAtom(ms_name);
        erlobjs1[1] = t1;
        OtpErlangTuple t2 = new OtpErlangTuple(erlobjs1);
        OtpErlangObject[] ob = new OtpErlangObject[1];
        ob[0] = t1;
        com.iti.telecom.main.GraphEditor.sender.sendtoerl("newms", ob);
    }
    
    
    
    
        public void sendnormallu(String ms, String lai) throws OtpErlangExit, OtpErlangDecodeException, Exception {
        OtpErlangAtom atom1 = new OtpErlangAtom(ms);
        erlobjs_ms[0] = atom1;
        OtpErlangAtom atom2 = new OtpErlangAtom(lai);
        erlobjs_ms[1] = atom2;
        OtpErlangTuple t2 = new OtpErlangTuple(erlobjs_ms);
        OtpErlangObject[] ob = new OtpErlangObject[1];
        ob[0] = t2;
        try {
            com.iti.telecom.main.GraphEditor.sender.sendtoerl("msnormallu", ob);
        } catch (Exception ex) {
            Logger.getLogger(sendtoerl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    

  /*  public static void main(String[] args) throws OtpErlangExit, OtpErlangDecodeException {
        //new sendtoerl2(, );
    }*/
}
