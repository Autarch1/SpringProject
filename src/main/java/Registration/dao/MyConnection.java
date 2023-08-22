package Registration.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MyConnection {
    private static final String DATABASE_URL = "jdbc:mysql://localhost:3306/registerform";
    private static final String DATABASE_USER = "root";
    private static final String DATABASE_PASSWORD = "rootroot";

    static Connection con = null;

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection(DATABASE_URL,DATABASE_USER,DATABASE_PASSWORD);
            System.out.println("Connecting...");
        }catch(SQLException e) {
            System.out.println(e.getMessage());
        }catch(ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        return con;
    }
}
