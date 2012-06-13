/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package sim001;

import com.ericsson.otp.erlang.*;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.Buffer;
import java.util.Scanner;

/**
 *
 * @author alaa
 */
public class sendtoerl2 {

    OtpNode node = null;
    OtpMbox mbox;
    OtpErlangPid pd = null;
    OtpErlangObject[] erlobjs = new OtpErlangObject[4];
    // OtpErlangAtom atom;
    static OtpConnection connection;

    public sendtoerl2() throws Exception
    {
    
       OtpSelf client;
        OtpPeer server;


        client = new OtpSelf("client");
        server = new OtpPeer("server@localhost");
        connection = client.connect(server);
        System.out.println("connected to server@localhost");
     
    }
    
//    static public void init() throws IOException, OtpAuthException {
        //    connection.sendRPC("funcall", "translate", obj);
//    }

 /*   static public void sendtoms(OtpErlangObject[] Ls) throws IOException, OtpAuthException {

        connection.sendRPC("ms_gen_server", "call", Ls);
    }

        static public void sendtohlr(OtpErlangObject[] Ls) throws IOException, OtpAuthException {

        connection.sendRPC("hlr_mgr", "start_gen", Ls);
    }*/
  static public void send(OtpErlangObject[] Ls) throws IOException, OtpAuthException {

        connection.sendRPC("request_handler", "erlang_receive", Ls);
    }
    public void sendtoerl(String filter,OtpErlangObject[] Obj) throws OtpErlangExit, OtpErlangDecodeException, IOException, OtpAuthException {

  //      init();
  
        System.out.println("Connected to epmd...");
   /*         if (filter.equals("new_ms"))
            sendtoms(Obj);
            //if (filter.equals("ms_loc"))
              //  sendmsloc(Obj);
        if (filter.equals("new_hlr"))
            sendtohlr(Obj);*/
        OtpErlangObject[] Obj1 = new OtpErlangObject[2];
        Obj1[0]= new OtpErlangAtom(filter);
        Obj1[1]= Obj[0];
       
        send(Obj1);
        
        
        
       System.out.println("data sent");
   
    }

}
