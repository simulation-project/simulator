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
    static public Vector<String> imsi_vect = new Vector<String>();
    static public Vector<String> hlr_vect = new Vector<String>();
    
    public DatabaseHandler(){
            }

            static public Vector<String> getlais(){
                
                //lai_vect.add("Off");
                
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
    
             static public Vector<String> gethlrs(){
                
                //lai_vect.add("Off");
                
                Connection con = null;
                con = DBConnection.getConnection1();
                
                java.sql.Statement s = null;
        try {
            s = con.createStatement();
     //       ResultSet rs = new ResultSet() {};
              ResultSet rs = s.executeQuery("select hlrname from hlrs;");
              
              
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");
            int k=0;
            System.out.println("rsss info marwa : "+rs.getFetchSize());
        
              while (rs.next())
        {
         //   rs.next();rs.next();
       //     System.out.println("rsn : "+rs.getString(1));
            
           System.out.println("rsn : "+rs.getString("hlrname"));
            
            System.out.println(k);
            hlr_vect.add(rs.getString("hlrname"));
            k++;
        }
            
            
        } catch (SQLException ex) {
            
            System.out.println("no data");
            ex.printStackTrace();
        }
        
        DBConnection.CloseConnection1(con);
        return hlr_vect;
            }

             
       static public Vector<String> getimsis(){
                
                //lai_vect.add("Off");
                
                Connection con = null;
                con = DBConnection.getConnection1();
                
                java.sql.Statement s = null;
                for (String hlr_name : gethlrs()){
        try {
            s = con.createStatement();
     //       ResultSet rs = new ResultSet() {};
            
              ResultSet rs = s.executeQuery("select imsi from "+hlr_name+";");
              
              
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");
            int k=0;
            System.out.println("rsss info rara : "+rs.getFetchSize());
        
              while (rs.next())
        {
         //   rs.next();rs.next();
       //     System.out.println("rsn : "+rs.getString(1));
            
           System.out.println("rsn : "+rs.getString("imsi"));
            
            System.out.println(k);
            imsi_vect.add(rs.getString("imsi"));
            k++;
        }
            
            
        } catch (SQLException ex) {
            
            System.out.println("no data");
            ex.printStackTrace();
        }
                }
        hlr_vect.clear();
        DBConnection.CloseConnection1(con);
        return imsi_vect;
            }

       public static void deleteDB_HLR()
       {
       
           Connection con = null;
           con = DBConnection.getConnection1();     
           java.sql.Statement s = null;
           
            for (String hlr_name : gethlrs()){
        try {
            s = con.createStatement();
     //       ResultSet rs = new ResultSet() {};
            
               s.executeUpdate("drop table "+hlr_name+";");
               s.executeUpdate("drop table node_"+hlr_name+";");
              
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");
            //int k=0;
           // System.out.println("rsss info rara : "+rs.getFetchSize());
       
            
            
        } catch (SQLException ex) {
            
            System.out.println("no data");
            ex.printStackTrace();
        }
                }
        try {
              s = con.createStatement();
            int rs = s.executeUpdate("delete from hlrs;");
        } catch (SQLException ex) {
            Logger.getLogger(DatabaseHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
       // hlr_vect.clear();
        DBConnection.CloseConnection1(con);
        
       }
       
       public static void deleteDB_MSC()
       {
       
           Connection con = null;
           con = DBConnection.getConnection();     
           java.sql.Statement s = null;
           
            
        try {
            s = con.createStatement();
            
            s.executeUpdate("delete from msrn ;");
                s.executeUpdate("delete from sub_info ;");
                s.executeUpdate("delete from bno_analysis ;");
                s.executeUpdate("delete from gt_translation ;");
//                s.executeUpdate("delete from imsi_analysis ;");
                s.executeUpdate("delete from msc;");
                s.executeUpdate("delete from msc_lai;");
                s.executeUpdate("delete from msc_data;");
               // s.executeUpdate("delete from msrn;");
                
                
                //s.executeUpdate("delete from msc_data;");
            
        } catch (SQLException ex) {
            
            System.out.println("no data");
            ex.printStackTrace();
        }
                
        DBConnection.CloseConnection(con);
        
       }
       
}

