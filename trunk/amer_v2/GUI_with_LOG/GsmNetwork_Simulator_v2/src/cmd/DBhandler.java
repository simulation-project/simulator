/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package cmd;

/**
 *
 * @author ahmed
 */
import java.beans.Statement;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
 
public class DBhandler {
    java.sql.Statement stmt;
    String hlrName;
    long start,end;
	public DBhandler(){
	}
        public void startConnection()
        {

		System.out.println("-------- PostgreSQL "
				+ "JDBC Connection Testing ------------");

		try {

			Class.forName("org.postgresql.Driver");

		} catch (ClassNotFoundException e) {

			System.out.println("Where is your PostgreSQL JDBC Driver? "
					+ "Include in your library path!");
			e.printStackTrace();
			return;

		}

		System.out.println("PostgreSQL JDBC Driver Registered!");

		Connection connection = null;

		try {
                        connection = DriverManager.getConnection(
                    "jdbc:postgresql://127.0.0.1:5432/hlr", "postgres", "iti");
            System.out.println("I am here 1");
            stmt = connection.createStatement();
            
                       // stmt=connection.createStatement();
                        System.out.print("connection established");

		} catch (SQLException e) {

			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();
			return;

		}

		if (connection != null) {
			System.out.println("You made it, take control your database now!");
		} else {
			System.out.println("Failed to make connection!");
		}
        }
        public ArrayList<String> getHlrs()
        {
        
            ArrayList<String> hlrs=new ArrayList<String>();
            ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select hlrName from hlrs");
        
        while(rs.next())
        {
            hlrs.add(rs.getString(1));
        }
        
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
            return hlrs;
        }

    ResultSet getHlrData(String string) {
       ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from "+string+" ;");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
   
    ResultSet getHlrsinfo() {
       ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from hlrs;");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
    ResultSet getMscsinfo()
    {
        ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from msc_data;");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
    ResultSet getAllMsc()
    {
        ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select name from msc_data;");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
    ResultSet getMsc(String n)
    {
        ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from msc_data where name='"+n+"';");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }

    ResultSet getMs(String imsi,String hlr) {
        ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from "+hlr+" where imsi='"+imsi+"' ;");
            System.out.println("select * from "+hlr+" where imsi='"+imsi+"' ;");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }

    ResultSet getAllMs(String hlr) {
        ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from "+hlr+";");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }

}
