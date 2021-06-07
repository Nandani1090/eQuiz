//M:Model - Pure Java Class following design guidelines
package com.tecdev;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
public class DatabaseBean {
    //static - Single copy and called using classname
    private static Connection con;  //To connect with database
    private static Statement st;    //To run queries
    private static ResultSet rs;     //For Select Statement
    //Static Anonymous Block - Execute once when class is 
    //referenced for the first - Singleton block
    static {    
        try {   //Dealing with exceptions
            //Using Context class we are accessing Context.xml
            //Earlier Core Java - Accessing Settings.properties
            Context initContext = new InitialContext();
            //Use word java:/comp/env to access Context.xml [Downcast to Context]
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            //Once context is obtained, retreive Datasource by its name
            DataSource ds = (DataSource) envContext.lookup("jdbc/myora");
            con = ds.getConnection();  //Obtain Database Connection
            con.setAutoCommit(false); //Do not save data till we issue commit fn
            //We are designing commit fn to manually perform commit
            //Now, create statement object to run SQL Queries
            st=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
           // st = con.createStatement();  //Create instance of Statement class
            
        } catch (Exception e) {
            System.out.println(e);
        }
    }
    public static void commit() throws SQLException{
        if(con!=null) con.commit();
    }
    //To execute Select Query, which return rows inside Result
    //Same as we designed in Core Java
    public static ResultSet executeQuery(String sql) {
        try {
            ResultSet rs = st.executeQuery(sql);
            return rs;
        } catch (Exception e) {
            return null;  //OCJP: null can be returned in place of object
        }
    }
    //To execute insert/update/delete, it returns number of rows affected as int
    public static int executeUpdate(String sql) {
        try {
            int result = st.executeUpdate(sql);
            return result;
        } catch (Exception e) {
            System.out.println("execUpdate" + e.toString());
            return 0;
        }
    }
}
