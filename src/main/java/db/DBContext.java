package db;

import util.DatabaseConfig;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    // Fallback values for local development
    private static final String LOCAL_URL = "jdbc:mysql://localhost:3306/spamanagement";
    private static final String LOCAL_USERNAME = "root";
    private static final String LOCAL_PASSWORD = "root";

    private static Connection connection = null;

    // Private constructor to prevent instantiation
    public DBContext() {
    }

    /**
     * Get database connection (automatically detects Heroku vs Local)
     * 
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                // Register JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Check if running on Heroku (JAWSDB_URL exists)
                String jawsDbUrl = System.getenv("JAWSDB_URL");

                if (jawsDbUrl != null) {
                    // Heroku deployment - use DatabaseConfig
                    String jdbcUrl = DatabaseConfig.getJdbcUrl();
                    String username = DatabaseConfig.getUsername();
                    String password = DatabaseConfig.getPassword();

                    System.out.println("=== HEROKU DATABASE CONNECTION ===");
                    System.out.println("Raw JAWSDB_URL: " + jawsDbUrl);
                    System.out.println("Converted JDBC URL: " + jdbcUrl);
                    System.out.println("Username: " + username);
                    System.out.println("Password: " + (password != null ? "[HIDDEN]" : "null"));

                    connection = DriverManager.getConnection(jdbcUrl, username, password);
                    System.out.println("Database connected successfully (Heroku JawsDB)");
                } else {
                    // Local development - use hardcoded values
                    System.out.println("=== LOCAL DATABASE CONNECTION ===");
                    System.out.println("Using local MySQL: " + LOCAL_URL);
                    connection = DriverManager.getConnection(LOCAL_URL, LOCAL_USERNAME, LOCAL_PASSWORD);
                    System.out.println("Database connected successfully (Local MySQL)");
                }
            } catch (ClassNotFoundException e) {
                System.out.println("ERROR: MySQL JDBC Driver not found!");
                throw new SQLException("MySQL JDBC Driver not found.", e);
            } catch (SQLException e) {
                System.out.println("ERROR: Database connection failed: " + e.getMessage());
                throw e;
            }
        }
        return connection;
    }

    /**
     * Close database connection
     */
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed");
            } catch (SQLException e) {
                System.out.println("Error closing database connection: " + e.getMessage());
            }
        }
    }

    /**
     * Test database connection
     */
    public static void testConnection() {
        try {
            Connection conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("Database connection test successful!");
                String jawsDbUrl = System.getenv("JAWSDB_URL");
                if (jawsDbUrl != null) {
                    System.out.println("Running on Heroku with JawsDB");
                } else {
                    System.out.println("Running locally with MySQL");
                }
            }
        } catch (SQLException e) {
            System.out.println("Database connection test failed: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        DBContext.testConnection();
    }
}