/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package ms_app;

import java.sql.*;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vendetta
 */
public class DatabaseHandler {
    static public Vector<String> lai_vect = new Vector<String>();            //Class.forName("org.postgresql.Driver");
            public DatabaseHandler(){
            }

            static public Vector<String> getlais(){
                
                lai_vect.add("Off");
                
                Connection con = null;
                con = DBConnection.getConnection();
                
                java.sql.Statement s = null;
        try {
            s = con.createStatement();
     //       ResultSet rs = new ResultSet() {};
              ResultSet rs = s.executeQuery("select lai from msc_lai;");
              
              
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");
        int k=0;
            System.out.println("rsss info : "+rs.getFetchSize());
        
              while (rs.next())
        {
         //   rs.next();rs.next();
       //     System.out.println("rsn : "+rs.getString(1));
            
           System.out.println("rsn : "+rs.getString("lai"));
            
            System.out.println(k);
            lai_vect.add(rs.getString("lai"));
            k++;
        }
            
            
        } catch (SQLException ex) {
            
            System.out.println("no data");
            ex.printStackTrace();
        }
        
        DBConnection.CloseConnection(con);
        return lai_vect;
            }
     /*       
        public boolean insert_gt_translation(Hashtable gt_trans)
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
                   int v = s.executeUpdate("INSERT INTO gt_translation VALUES ('"+key+"','"+value+"')");
               }

            check = true;
        } catch (SQLException ex) {
            
            System.out.println("not inserted");
            ex.printStackTrace();
        }
            return check;
        }*/
    }
