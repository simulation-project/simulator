/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package cmd;

import com.iti.telecom.editor.BasicGraphEditor;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author mahmoud
 */
public class CommandParser {
    
    DBhandler db;
    tokenizer tok;
    String oldComands,command;
    ArrayList<String> hlrs,msc,ms;
    String[] splitted;
    BasicGraphEditor jf;
    
    public CommandParser(BasicGraphEditor j)
    {
        jf=j;
        db=new DBhandler();
        db.startConnection();
        tok=new tokenizer();
        getHlrs();
    }

public void executeCommand(String c)
    {
        command=c;
        System.out.println("\n........................."+command+".......................");
        getTokens(command);
        checkSpelling();
        checkSyntex();
        execute();
    }
void getTokens(String t)
    {    
        splitted=t.split(" ");
        System.out.println("the number of "+splitted.length);
    }
private void checkSpelling() {
        boolean flag=true;
        int i;
        for(i=0;i<splitted.length;i++)
            if(splitted[i].matches("[A-Z|a-z]([A-za-z0-9])*"))
                continue;
            else{
                if(i==2&&splitted[1].compareToIgnoreCase("ms")==0)
                    continue;
                flag=false;
                break;
            }
        if(!flag)
            jf.appendResult("unrecognized word : "+splitted[i]);
    }

    private void checkSyntex() {
        
    }
    
    boolean checkHlr(int i)
    {
        
        return true;
    }
    
    String checkMsc(int i)
    {
        return "";
    }
    
    String checkMs(int i)
    {
        return "";
    }

    private void getHlrs() {
        hlrs=db.getHlrs();
        System.out.print("number of hlrs is "+hlrs.size());
    }

    private void execute() {
        System.out.println(splitted[0]);
        if(splitted[0].compareToIgnoreCase("show")==0)
            executeShow();
        else
            if(splitted[0].compareToIgnoreCase("add")==0)
                executeAdd();
            else
                if(splitted[0].compareToIgnoreCase("clear")==0||splitted[0].compareToIgnoreCase("clr")==0)
                    clear();
            else
                jf.appendResult("syntex error at :"+splitted[0]);
    }

    private void executeShow() {
        if(splitted[1].compareToIgnoreCase("all")==0)
            showAll();
        else
            if(splitted[1].compareToIgnoreCase("hlr")==0)
                try {
            showHlr();
        } catch (SQLException ex) {
            Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
        }
            else
                if(splitted[1].compareToIgnoreCase("msc")==0)
                    showMsc();
                else
                    if(splitted[1].compareToIgnoreCase("ms")==0)
                        showMs();
                    else
                        jf.appendResult("syntex error at :"+splitted[1]);
    }

    private void showAll() {
        String node=splitted[2];
        if(node.compareToIgnoreCase("hlr")==0||node.compareToIgnoreCase("hlrs")==0)
            showAllHlr();
        else
            if(node.compareToIgnoreCase("msc")==0||node.compareToIgnoreCase("mscs")==0)
                showAllMsc();
            else
                if(node.compareToIgnoreCase("ms")==0||node.compareToIgnoreCase("mss")==0)
                    showAllMs();
                else
                    jf.appendResult("syntex error at :"+splitted[2]);
    }

    private void showHlr() throws SQLException {
        
            ResultSet rs=null;
            int i;
            boolean flag=false;
            getHlrs();
            for(i=0;i<hlrs.size();i++)
                if(splitted[2].compareToIgnoreCase(hlrs.get(i))==0)
                {
                    rs=db.getHlrData(splitted[2]);
                    flag=true;
                }
            if(!flag)jf.appendResult("hlr does not exist ");
            
            while(rs.next())
            {   
                System.out.println("hlr found and got data");
                jf.appendResult("imsi:"+rs.getString(1)+" vlr address:"+rs.getString(2)+" isd:"+rs.getString(3)+" ");
            }
        
    }

    private void showMsc() {
        try {
            ResultSet rs=null;
            rs=db.getMsc(splitted[2]);
            while(rs.next())
                {   
                    jf.appendResult("MSc name: "+rs.getString(1)+" vlr: "+rs.getString(2)+" Ni-Spc: "+rs.getString(3)+" Gt: "+rs.getString(4));
                }
        } catch (SQLException ex) {
            Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private void showMs() {
        
            String imsi=splitted[2];
            ResultSet rs=null;
            int i=0;
            getHlrs();
            boolean found=false;
            for(;i<hlrs.size();i++)
            {
                rs=db.getMs(imsi,hlrs.get(i));
                if(rs==null)
                    continue;
                else
                    break;
            }
        try {
            while(rs.next())
            {
                found=true;
                jf.appendResult("imsi:"+rs.getString(1)+" vlr:"+rs.getString(2)+" isd:"+rs.getString(3)+" hlr name:"+hlrs.get(i));
            }
            System.out.println("ms");
        } catch (SQLException ex) {
            Logger.getLogger(CommandParser.class.getName()).log(Level.SEVERE, null, ex);
        }
        if(!found)jf.appendResult("imsi does not exist");
    }

    private void showAllHlr() {
        getHlrs();
        if(splitted.length==4)
        {
            if(splitted[3].compareToIgnoreCase("info")==0)
            {
                try {
                    ResultSet rs=null;
                    rs=db.getHlrsinfo();
                    while(rs.next())
                    jf.appendResult("hlr name :"+rs.getString(1)+" imsi start range :"+rs.getString(2)+" imsi end range :"+rs.getString(3)+" Ni-Spc :"+rs.getString(4)+" Gt :"+rs.getString(5));
                } catch (SQLException ex) {
                    Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            else
                jf.appendResult("error in word "+splitted[3]);
        }
            else
        for(int i=0;i<hlrs.size();i++)
            jf.appendResult(hlrs.get(i));
    }

    private void showAllMsc() {
        ResultSet rs=null;
        if(splitted.length==4)
        {
            if(splitted[3].compareToIgnoreCase("info")==0)
            {
                try {
                    rs=db.getMscsinfo();
                    while(rs.next())
                            jf.appendResult("Msc name: "+rs.getString(1)+" vlr: "+rs.getString(2)+" Ni-Spc: "+rs.getString(3)+" Gt: "+rs.getString(4));
                } catch (SQLException ex) {
                    Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            else
                jf.appendResult(" syntex error near "+splitted[3]);
        }
        else
        {
            try {
                rs=db.getAllMsc();
                while(rs.next())
                        jf.appendResult(rs.getString(1));
            } catch (SQLException ex) {
                Logger.getLogger(BasicGraphEditor.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
    }

    private void showAllMs() {
        getHlrs();
        int i=0;
        ResultSet rs=null;
        for(;i<hlrs.size();i++)
        {
            rs=db.getAllMs(hlrs.get(i));
            try {
                while(rs.next())
                    jf.appendResult("imsi:"+rs.getString(1)+" vlr:"+rs.getString(2)+" isd:"+rs.getString(3)+" hlr name:"+hlrs.get(i));
            } catch (SQLException ex) {
                Logger.getLogger(CommandParser.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    private void executeAdd() {
        
    }

    private void clear() {
        jf.clearTextArea();
    }
}