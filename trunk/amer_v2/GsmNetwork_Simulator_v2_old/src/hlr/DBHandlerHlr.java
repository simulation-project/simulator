/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package hlr;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author welcome
 */
public class DBHandlerHlr {

    java.sql.Statement stmt;
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
                    "jdbc:postgresql://127.0.0.1:5555/HLR", "postgres", "123456");
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
    public void addHlr(String HlrName,String NiSpc,String Gt,long start,long end)
    {
        try {
            stmt.executeUpdate("insert into hlr (hlrName,niSpc,Gt,s,e) valus('" + HlrName + "','" + NiSpc + "','" + Gt + "','" + start + "','" + end + "');");
        } catch (SQLException ex) {
            Logger.getLogger(DBHandlerHlr.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public void addSubscriber(String IMSI,String info,String Gt) throws SQLException
        {
            
            System.out.println("add subscriber");
            stmt.executeUpdate("insert into subscriber (imsi,subinfo,gt) values ('"+IMSI+"','"+info+"','"+Gt+"');");
            System.out.println("add subscriber DONE");
            
        }
    void addMsc(String NiSpc, String Gt) {
        try {
            stmt.executeUpdate("insert into msc (nispc,gt) values(" + NiSpc + "," + Gt + ");");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
