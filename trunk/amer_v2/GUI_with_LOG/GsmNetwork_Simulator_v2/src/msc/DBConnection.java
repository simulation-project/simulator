/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package msc;

/**
 *
 * @author Vendetta
 */
import java.sql.*;

public class DBConnection {

    public DBConnection() {
    }
    static Connection connection = null;

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
            
        }
        return connection;
    }

    public static synchronized void CloseConnection(Connection con) {
        try {
            connection.close();
        } catch (SQLException e) {
            
        }
    }
}
