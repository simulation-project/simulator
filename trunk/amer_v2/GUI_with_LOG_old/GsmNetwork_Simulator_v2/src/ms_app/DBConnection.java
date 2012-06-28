/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ms_app;

/**
 *
 * @author Vendetta
 */
import java.sql.*;

public class DBConnection {

    public DBConnection() {
    }
    static Connection connection = null;
    static Connection connection1 = null;

    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (Exception ex) {
            System.out.println("Error in loading driver" + ex);
        }

    }

    public static Connection getConnection() {
        try {

            connection = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/msc","postgres","iti");
            
            System.out.println("inside connection");
        } catch (SQLException e) {
            System.out.println("not connected");
            e.printStackTrace();
        }
        return connection;
    }

    public static Connection getConnection1() {
        try {

            connection1 = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/hlr","postgres","iti");
            
            System.out.println("inside connection");
        } catch (SQLException e) {
            System.out.println("not connected");
            e.printStackTrace();
        }
        return connection1;
    }

    
    public static synchronized void CloseConnection(Connection con) {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static synchronized void CloseConnection1(Connection con) {
        try {
                connection1.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
}