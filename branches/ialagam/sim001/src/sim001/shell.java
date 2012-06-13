/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package sim001;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author alaa
 */
public class shell {

    public shell() throws IOException, InterruptedException {

     /*      List<String> commands = new ArrayList<String>();
        commands.add("ls");
        commands.add("ls -l");
*/
       // Process p = Runtime.getRuntime().exec(new String[]{"bash","ls /home/alaa"});
String[] command= {"/usr/bin/xterm"};//,"cd /home/alaa/erlang2/request_handler/","erl -pa ebin -sname server@localhost"}; 
Runtime rt = Runtime.getRuntime();
Process pr = rt.exec(command);
//pr.waitFor();
OutputStream outst = pr.getOutputStream();
        System.out.println("1");

String cs1 = "cd /home/alaa/erlang2/request_handler/ \n";
byte[] c1 = cs1.getBytes();
 System.out.println("2");
outst.write(c1);
        System.out.println(cs1);
        
        System.out.println(pr);

/*
Runtime rt1 = Runtime.getRuntime();
Process pr1 = rt1.exec("cd /home/alaa/erlang2/request_handler/");



Runtime rt2 = Runtime.getRuntime();
Process pr2 = rt2.exec("erl -pa ebin -sname server@localhost");

*/

      //  System.out.println(p);
    }

    public static void main (String args[]) throws IOException, InterruptedException {
        new shell();
    }
}
