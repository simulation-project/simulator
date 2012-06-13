/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package sim001;

import java.io.IOException;
import java.util.Scanner;

/**
 *
 * @author marwa
 */
import com.ericsson.otp.erlang.*;
import java.io.IOException;
import java.net.InetAddress;
import java.nio.Buffer;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author alaa
 */
public class sendtoerl {
   
     OtpNode node = null;
    OtpMbox mbox;
    OtpErlangPid pd = null ;
    OtpErlangObject[] erlobjs = new OtpErlangObject[3];
    OtpErlangObject[] erlobjs_ms = new OtpErlangObject[2];
   // OtpErlangAtom atom;
    
    
    public sendtoerl(String ms,String locupdate) throws OtpErlangExit, OtpErlangDecodeException, Exception
    {
   
        sendtoerl2 sender = new sendtoerl2();
        
 //       try {
//            node = new OtpNode("javambox@marwa@ubuntu");// + InetAddress.getLocalHost().getHostName());//alaa-laptop");//, "zed"); // name, cookie
//        } catch (IOException ex) {
 //           System.out.println(ex);
 //           System.exit(-1);
 //       }
        System.out.println("Connected to epmd...");
        
        
        /*if (node.ping("koko@alaa-PC", 2000)) {
            System.out.println("koko@alaa-PC is up.");
        } else {
            System.out.println("koko@alaa-PC is down");
        }*/
//        mbox = node.createMbox("mbox");

//        System.out.println("waiting connection - pid ");
//        pd = (OtpErlangPid) mbox.receive();
 
//        System.out.println("%%%%%%%% connected %%%%%%%%");

//        while(true)
{   

//System.out.println("insert request");

 //     Scanner in = new Scanner(System.in);
 //    String input = in.nextLine();
     OtpErlangAtom atom1 = new OtpErlangAtom(ms);
     erlobjs_ms[0]=atom1;
     OtpErlangAtom atom2 = new OtpErlangAtom(locupdate);
     erlobjs_ms[1]=atom2;
    OtpErlangTuple t2 = new OtpErlangTuple(erlobjs_ms);
    
    OtpErlangObject[] ob = new OtpErlangObject[1]; 
                ob[0] = t2;
            try {
                sender.sendtoerl("newms", ob );
       ///mbox.send(pd, t2); 
  //    System.out.println("data sent");
            } catch (Exception ex) {
                Logger.getLogger(sendtoerl.class.getName()).log(Level.SEVERE, null, ex);
            } 
}
    
    }
    public sendtoerl(String imsi, String msisdn, String lai ) throws OtpErlangExit, OtpErlangDecodeException, Exception {
     //   System.out.println(InetAddress.getLocalHost());
   
    //    sendtoerl2 sender = new sendtoerl2();

       /* try {
            node = new OtpNode("javambox@marwa@ubuntu");// + InetAddress.getLocalHost().getHostName());//alaa-laptop");//, "zed"); // name, cookie
        } catch (IOException ex) {
            System.out.println(ex);
            System.exit(-1);
        }
        System.out.println("Connected to epmd...");
{   */
             /*if (node.ping("koko@alaa-PC", 2000)) {
            System.out.println("koko@alaa-PC is up.");
            } else {
            System.out.println("koko@alaa-PC is down");
            }*/ //    mbox = node.createMbox("mbox");
            //    mbox = node.createMbox("mbox");
            //    pd = (OtpErlangPid) mbox.receive();
            //  System.out.println("%%%%%%%% connected %%%%%%%%");
            //      while(true)
            {
                //System.out.println("insert request");

                  //    Scanner in = new Scanner(System.in);
                  //   String input = in.nextLine();
                     OtpErlangAtom atom = new OtpErlangAtom(imsi);
                     erlobjs[0]= atom ;
                     
                     OtpErlangAtom k = new OtpErlangAtom(msisdn);
                 erlobjs[1]= k ;
                  
                    OtpErlangAtom atom2 = new OtpErlangAtom(lai);
                     erlobjs[2]= atom2 ;
                     
                          
                 
                OtpErlangTuple t1 = new OtpErlangTuple(erlobjs);
                OtpErlangObject[] erlobjs1 = new OtpErlangObject[2];
                erlobjs1[0] = new OtpErlangAtom(imsi);
                erlobjs1[1] = t1;
                OtpErlangTuple t2 = new OtpErlangTuple(erlobjs1);

                //OtpErlangObject[] erlobjs2 = new OtpErlangObject[3];
                //erlobjs2[0] = new OtpErlangAtom("ms");
                //erlobjs2[1] = new OtpErlangAtom("call");
                //erlobjs2[2] = t2;
                //OtpErlangTuple t3 = new OtpErlangTuple(erlobjs2);
                OtpErlangObject[] ob = new OtpErlangObject[1]; 
                ob[0] = t1;

                NewJFrame.sender.sendtoerl("newms", ob );
                //mbox.send(pd, t2); 
                    System.out.println("data sent");
            
}}
  
    
     public static void main(String[] args) throws OtpErlangExit, OtpErlangDecodeException{
        //new sendtoerl2(, );
    }
}
