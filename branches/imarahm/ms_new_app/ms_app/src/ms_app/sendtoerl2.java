/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ms_app;

import com.ericsson.otp.erlang.*;
import java.io.IOException;

/**
 *
 * @author alaa
 */
public class sendtoerl2
{
    OtpNode node = null;
    OtpMbox mbox;
    OtpErlangPid pd = null;
    OtpErlangObject[] erlobjs = new OtpErlangObject[4];
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

    static public void sendtoms(String mod, String fn,OtpErlangObject[] Ls) throws IOException, OtpAuthException
    {
        connection.sendRPC(mod, fn, Ls);
    }

    public void sendtoerl(String filter,OtpErlangObject[] Obj) throws OtpErlangExit, OtpErlangDecodeException, IOException, OtpAuthException 
    {
        System.out.println("Connected to epmd...");
        if (filter.equals("new_ms"))
        {sendtoms("ms_app","create_ms",Obj);
        System.out.println("data sent");}
        if (filter.equals("ms_loc"))
        {sendtoms("ms_app","change_state",Obj);
        System.out.println("data sent");}
        
    }
}
