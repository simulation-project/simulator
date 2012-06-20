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

     public DatabaseHandler(){

                this.con = ms_app.DBConnection.getConnection();                
            }

            public void insert_msc_info(String name, String ni, String spc, String gt, String vlr){
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
            
            
            public void insert_msc_lais(String name, String vlr, String lai){
     //           Connection con = null;
    //            con = DBConnection.getConnection();
                
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

