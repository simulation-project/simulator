/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package msc;

import java.sql.*;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vendetta
 */
public class DatabaseHandler {
            //Class.forName("org.postgresql.Driver");
     static public Connection con ;       

     public DatabaseHandler()
     {
        this.con = ms_app.DBConnection.getConnection();                
     }

    public void insert_msc_info(String name, String ni, String spc, String gt, String vlr)
    {
      //  Connection con = null;
//                con = DBConnection.getConnection();
        java.sql.Statement s = null;
        try {
            s = con.createStatement();
            String ni_spc = ni+spc;
            int v = s.executeUpdate("INSERT INTO msc_data VALUES ('"+name+"','"+vlr+"','"+ni_spc+"','"+gt+"')");
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");

        } catch (SQLException ex) {
            System.out.println("not inserted");
            ex.printStackTrace();
        }
    }
    public void insert_msc_lais(String name, String vlr, String lai)
    {
        java.sql.Statement s = null;
        try {
            s = con.createStatement();
            int v = s.executeUpdate("INSERT INTO msc_lai VALUES ('"+name+"','"+vlr+"','"+lai+"')");
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");
            
        } catch (SQLException ex) {    
            System.out.println("not inserted");
            ex.printStackTrace();
        }
    }
    public void update_msc_info(String name, String ni, String spc, String gt, String vlr)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement s = null;
        try {
            s = con.createStatement();
            String ni_spc = ni+spc;
            int no = s.executeUpdate("update msc_data SET ni_spc='"+ni_spc+"', gt='"+gt+"', vlr_add='"+vlr+"' where name='"+name+"'" );
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        
    }
            
    public boolean check_msc_name_vlr(String msc_name, String vlr_add)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement st = null;
        boolean check = false;
        ResultSet rs = null;
        try {
            st = con.createStatement();
            rs = st.executeQuery("select name, vlr_add from msc_data where name ='"+msc_name+"' or vlr_add = '"+vlr_add+"'" );
            while(rs.next())
            {
                check = true;
            }
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        return check;
    }
    public boolean check_msc_name(String msc_name)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement st = null;
        boolean check = false;
        ResultSet rs = null;
        try {
            st = con.createStatement();
            rs = st.executeQuery("select name from msc_data where name ='"+msc_name+"'" );
            while(rs.next())
            {
                check = true;
            }
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        return check;
    }

    public boolean check_msc_ni_spc(String spc)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement st = null;
        boolean check = false;
        ResultSet rs = null;
        try {
            st = con.createStatement();
            rs = st.executeQuery("select ni_spc from msc_data where ni_spc ='"+spc+"'" );
            while(rs.next())
            {
                check = true;
            }
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        return check;
    }
    
    public boolean check_msc_gt(String gt)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement st = null;
        boolean check = false;
        ResultSet rs = null;
        try {
            st = con.createStatement();
            rs = st.executeQuery("select gt from msc_data where gt ='"+gt+"'" );
            while(rs.next())
            {
                check = true;
            }
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        return check;
    }
    
    public boolean check_msc_vlr(String vlr)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement st = null;
        boolean check = false;
        ResultSet rs = null;
        try {
            st = con.createStatement();
            rs = st.executeQuery("select vlr_add from msc_data where vlr_add ='"+vlr+"'" );
            while(rs.next())
            {
                check = true;
            }
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        return check;
    }
    
    public boolean check_msc_lai(String lai)
    {
        Connection con = null;        
        con = DBConnection.getConnection();
        java.sql.Statement st = null;
        boolean check = false;
        ResultSet rs = null;
        try {
            st = con.createStatement();
            rs = st.executeQuery("select lai from msc_lai where lai ='"+lai+"'" );
            while(rs.next())
            {
                check = true;
            }
        }
         catch (SQLException ex) {
           System.out.println("exception update availability");
        }
        return check;
    }
    
    public boolean insert_gt_translation(Hashtable gt_trans, String msc_name, String vlr)
    {
        Connection con = null;
        con = DBConnection.getConnection();
        boolean check = false;
        java.sql.Statement s = null;
        try {
            s = con.createStatement();
            Enumeration keys = gt_trans.keys();
            while (keys.hasMoreElements()) 
            {
                String key = (String) keys.nextElement();
                String value = (String) gt_trans.get(key);
                int v = s.executeUpdate("INSERT INTO gt_translation VALUES ('"+key+"','"+value+"', '"+msc_name+"', '"+vlr+"')");
            }

        check = true;
        } catch (SQLException ex) {
            System.out.println("not inserted");
            ex.printStackTrace();
        }
        return check;
    }
}
