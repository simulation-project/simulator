/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package sim001;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Vendetta
 */
public class DatabaseHandler {
            //Class.forName("org.postgresql.Driver");
            public DatabaseHandler(){
            }

            public void insert_msc_info(String name, String ni, String spc, String gt, String vlr, String la){
                Connection con = null;
                con = DBConnection.getConnection();
                java.sql.Statement st = null;
                ResultSet rs = null;
        try {
            st = con.createStatement();
            //rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+"','"+spc+"','"+gt+"','"+vlr+"','"+la+"')");
            rs = st.executeQuery("INSERT INTO msc_data VALUES ('"+name+"','"+ni+spc+"','"+vlr+"','"+gt+"')");
        } catch (SQLException ex) {
            Logger.getLogger(DatabaseHandler.class.getName()).log(Level.SEVERE, null, ex);
        }
            }
    }

