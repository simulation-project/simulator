/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package hlr;

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
        public void addSubscriber(String IMSI,String info,String n) throws SQLException
        {
            
            System.out.println("add subscriber");
            stmt.executeUpdate("insert into "+n+" (imsi,isd) values ('"+IMSI+"','"+info+"');");
            System.out.println("add subscriber DONE");
            
        }
        boolean imsiExist(String imsi,String n) throws SQLException
        {
        
            ResultSet rs=null;
            System.out.println("imsi exist "+n+"  "+imsi);
            rs=stmt.executeQuery("select * from "+n+" where imsi='"+imsi+"';"); 
            while(rs.next())
            {
                return false;
            }
            return false;
        
        
        }

    void createDB(String name,long s,long e) throws SQLException {
        hlrName=StartFrame.getHlrName();
        start=s;
        end=e;
        System.out.println("create table "+hlrName);
        stmt.executeUpdate("create table "+hlrName+" (imsi varchar(50) primary key,vlr varchar(50),isd varchar(80));");
        System.out.println("create table DONE");
        stmt.executeUpdate("create table node_"+hlrName+" (nispc varchar(50),gt varchar(50) primary key);");
        stmt.executeUpdate("insert into hlrs values ('"+hlrName+"');");
    }

    void deleteTable(String name)
    {
        try {
            stmt.executeQuery("drop table "+name+", node_"+name+";");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    void addMsc(String NiSpc, String Gt) {
        hlrName=StartFrame.getHlrName();
        System.out.println(hlrName);
        try {
            stmt.executeUpdate("insert into node_"+hlrName+" (nispc,gt) values(" + NiSpc + "," + Gt + ");");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
//    boolean checkMsc(String Gt)
//    {
//        ResultSet rs=null;
//        try {
//            rs=stmt.executeQuery("select * from node_"+StartFrame.getHlrName()+";");
//        } catch (SQLException ex) {
//            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        if(rs==null)
//                return true;
//            else
//                return false;
//    }
    
    ResultSet hlrExist(String name)
    {
        ResultSet rs=null;
        try {
            rs=stmt.executeQuery("select * from hlrs where hlrname='"+name+"';");
        } catch (SQLException ex) {
            Logger.getLogger(DBhandler.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rs;
    }
}
