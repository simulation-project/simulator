/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package sim001;

/**
 *
 * @author ahmed
 */
import java.beans.Statement;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        public void addSubscriber(String IMSI,String info,String n) throws SQLException
        {
            
            System.out.println("add subscriber");
            stmt.executeUpdate("insert into "+n+" (imsi,subinfo) values ('"+IMSI+"','"+info+"');");
            System.out.println("add subscriber DONE");
            
        }

    void createDB(String name,long s,long e) throws SQLException {
        hlrName=name;
        start=s;
        end=e;
        System.out.println("start is"+start);
        System.out.println("end is"+end);
        System.out.println("create table ");
        stmt.executeUpdate("create table "+hlrName+" (imsi varchar(50) primary key,vlradd varchar(50),subinfo varchar(80));");
        System.out.println("create table DONE");
    }

    void deleteTable(String name)
    {
        try {
            stmt.executeQuery("drop table " + name + "; ");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
