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
public class sendtoerl
{
    OtpNode node = null;
    OtpMbox mbox;
    OtpErlangPid pd = null ;
    OtpErlangObject[] erlobjs = new OtpErlangObject[3];
    OtpErlangObject[] erlobjs_ms = new OtpErlangObject[2];
   // OtpErlangAtom atom;
    
 public sendtoerl(String ms,String locupdate) throws OtpErlangExit, OtpErlangDecodeException, Exception
 {
     sendtoerl2 sender = new sendtoerl2();
     System.out.println("Connected to epmd...");
     OtpErlangAtom atom1 = new OtpErlangAtom(ms);
     erlobjs_ms[0]=atom1;
     OtpErlangAtom atom2 = new OtpErlangAtom("turn_on_idle");
     erlobjs_ms[1]=atom2;
     OtpErlangTuple t2 = new OtpErlangTuple(erlobjs_ms);
     OtpErlangObject[] ob = new OtpErlangObject[1];
     ob[0] = t2;
     try 
     {
        sender.sendtoerl("ms_loc", ob );
     } catch (Exception ex) {
                Logger.getLogger(sendtoerl.class.getName()).log(Level.SEVERE, null, ex);
            } 
    }
    public sendtoerl(String imsi, String msisdn, String lai ) throws OtpErlangExit, OtpErlangDecodeException, Exception
    {
        sendtoerl2 sender = new sendtoerl2();
        OtpErlangAtom atom = new OtpErlangAtom(imsi);
        erlobjs[0]= atom ;            
        OtpErlangAtom k = new OtpErlangAtom(msisdn);
        erlobjs[1]= k ;          
        OtpErlangAtom atom2 = new OtpErlangAtom(lai);
        erlobjs[2]= atom2 ;
        OtpErlangTuple t1 = new OtpErlangTuple(erlobjs);
        //OtpErlangObject[] erlobjs1 = new OtpErlangObject[2];
        //erlobjs1[0] = new OtpErlangAtom(imsi);
        //erlobjs1[1] = t1;
        //OtpErlangTuple t2 = new OtpErlangTuple(erlobjs1);
        OtpErlangObject[] ob = new OtpErlangObject[1]; 
        ob[0] = t1;
        sender.sendtoerl("new_ms", ob );
        System.out.println("data sent");
    }
 
     public static void main(String[] args) throws OtpErlangExit, OtpErlangDecodeException
     {
        //new sendtoerl2(, );
     }
}
