package dao;

import db.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;

/**
 * @author quang
 */
public class CustomerDAO implements BaseDAO<Customer, Integer> {

    // Helper method to build Customer from ResultSet
    private Customer buildCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setFullName(rs.getString("full_name"));
        customer.setEmail(rs.getString("email"));
        customer.setPhoneNumber(rs.getString("phone_number"));
        customer.setHashPassword(rs.getString("hash_password"));
        customer.setGender(rs.getString("gender"));
        customer.setBirthday(rs.getDate("birthday"));
        customer.setAddress(rs.getString("address"));
        customer.setIsActive(rs.getBoolean("is_active"));
        customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
        customer.setRoleId(rs.getInt("role_id"));
        customer.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        customer.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        customer.setIsVerified(rs.getObject("is_verified") != null ? rs.getBoolean("is_verified") : false);
        return customer;
    }

    @Override
    public <S extends Customer> S save(S customer) {
        AccountDAO accountDAO = new AccountDAO();

        if (accountDAO.isEmailTakenInSystem(customer.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        if (accountDAO.isPhoneTakenInSystem(customer.getPhoneNumber())) {
            throw new IllegalArgumentException("Phone number already exists");
        }

        String sql = "INSERT INTO customers (full_name, email, hash_password, phone_number, role_id, is_active, loyalty_points, is_verified, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, BCrypt.hashpw(customer.getHashPassword(), BCrypt.gensalt()));
            ps.setString(4, customer.getPhoneNumber());
            ps.setInt(5, customer.getRoleId());
            ps.setBoolean(6, customer.getIsActive() != null ? customer.getIsActive() : true);
            ps.setInt(7, customer.getLoyaltyPoints() != null ? customer.getLoyaltyPoints() : 0);
            ps.setBoolean(8, customer.getIsVerified() != null ? customer.getIsVerified() : false);
            ps.setTimestamp(9, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setTimestamp(10, Timestamp.valueOf(java.time.LocalDateTime.now()));
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    customer.setCustomerId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error saving customer: " + e.getMessage(), e);
        }
        return customer;
    }

    @Override
    public Optional<Customer> findById(Integer id) {
        String sql = "SELECT * FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customer by ID: " + e.getMessage(), e);
        }
        return Optional.empty();
    }

    @Override
    public List<Customer> findAll() {
        return findAll(1, 10); // Default to first page with 10 items
    }

    public List<Customer> findAll(int page, int pageSize) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers LIMIT ? OFFSET ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(buildCustomerFromResultSet(rs));
                }
                Logger.getLogger(CustomerDAO.class.getName()).log(Level.INFO,
                        "Retrieved " + list.size() + " customers for page " + page);
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.SEVERE, "Error finding customers", e);
            throw new RuntimeException("Error finding customers: " + e.getMessage(), e);
        }
        return list;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting customers: " + e.getMessage(), e);
        }
        return 0;
    }

    @Override
    public boolean existsById(Integer id) {
        String sql = "SELECT 1 FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking customer existence: " + e.getMessage(), e);
        }
    }

    @Override
    public void deleteById(Integer id) {
        String sql = "DELETE FROM customers WHERE customer_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting customer: " + e.getMessage(), e);
        }
    }

    @Override
    public <S extends Customer> S update(S customer) {
        String sql = "UPDATE customers SET full_name=?, email=?, phone_number=?, gender=?, birthday=?, address=?, is_active=?, loyalty_points=?, role_id=?, is_verified=?, updated_at=? WHERE customer_id=?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getFullName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhoneNumber());
            ps.setString(4, customer.getGender());
            ps.setDate(5, customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            ps.setString(6, customer.getAddress());
            ps.setBoolean(7, customer.getIsActive());
            ps.setInt(8, customer.getLoyaltyPoints());
            ps.setInt(9, customer.getRoleId());
            ps.setBoolean(10, customer.getIsVerified() != null ? customer.getIsVerified() : false);
            ps.setTimestamp(11, Timestamp.valueOf(java.time.LocalDateTime.now()));
            ps.setInt(12, customer.getCustomerId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating customer: " + e.getMessage(), e);
        }
        return customer;
    }

    @Override
    public void delete(Customer entity) {
        deleteById(entity.getCustomerId());
    }

    public List<Customer> findByNameContain(String name) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE full_name LIKE ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customers by name: " + e.getMessage(), e);
        }
        return customers;
    }

    public List<Customer> findByPhoneContain(String phone) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE phone_number LIKE ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + phone + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customers by phone: " + e.getMessage(), e);
        }
        return customers;
    }

    public List<Customer> findByEmailContain(String email) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE email LIKE ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + email + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customers by email: " + e.getMessage(), e);
        }
        return customers;
    }

    public boolean validateAccount(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT hash_password FROM customers WHERE email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("hash_password");
                    return BCrypt.checkpw(password, storedHash);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error validating account: " + e.getMessage(), e);
        }
        return false;
    }

    public Optional<Customer> findCustomerByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return Optional.empty();
        }
        String sql = "SELECT * FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(buildCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding customer by email: " + e.getMessage(), e);
        }
        return Optional.empty();
    }

    public Customer getCustomerByEmailAndPassword(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("hash_password");
                if (BCrypt.checkpw(password, storedHash)) {
                    Customer customer = new Customer();
                    customer.setCustomerId(rs.getInt("customer_id"));
                    customer.setFullName(rs.getString("full_name"));
                    customer.setEmail(rs.getString("email"));
                    customer.setHashPassword(rs.getString("hash_password"));
                    customer.setPhoneNumber(rs.getString("phone_number"));
                    customer.setRoleId(rs.getInt("role_id"));
                    customer.setIsActive(rs.getBoolean("is_active"));
                    customer.setGender(rs.getString("gender"));
                    customer.setAddress(rs.getString("address"));
                    customer.setBirthday(rs.getDate("birthday"));
                    customer.setLoyaltyPoints(rs.getInt("loyalty_points"));
                    // Handle optional timestamp fields
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        customer.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        customer.setUpdatedAt(updatedAt.toLocalDateTime());
                    }
                    return customer; // <- THIS WAS MISSING!
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting customer by email and password: " + e.getMessage(), e);
        }
        return null;
    }

    public String getCustomerNameByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        String sql = "SELECT full_name FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("full_name");
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(CustomerDAO.class.getName()).log(Level.WARNING,
                    "Error getting customer name for email: " + email, e);
        }
        return null;
    }

    /**
     * Updates customer profile information
     *
     * @param customer Customer object with updated information
     * @return true if update was successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean updateProfile(Customer customer) throws SQLException {
        if (customer == null || customer.getCustomerId() == null) {
            return false;
        }

        String sql = "UPDATE customers SET full_name = ?, phone_number = ?, gender = ?, birthday = ?, address = ?, updated_at = ? WHERE customer_id = ?";

        try (Connection connection = DBContext.getConnection();
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, customer.getFullName());
            stmt.setString(2, customer.getPhoneNumber());
            stmt.setString(3, customer.getGender());
            stmt.setDate(4,
                    customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            stmt.setString(5, customer.getAddress());
            stmt.setTimestamp(6, java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
            stmt.setInt(7, customer.getCustomerId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    /**
     * Checks if a customer is verified by their email address.
     * 
     * @param email The customer's email
     * @return true if the customer exists and is_verified is true, false otherwise
     */
    public boolean isCustomerVerified(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT is_verified FROM customers WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("is_verified");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking if customer is verified: " + e.getMessage(), e);
        }
        return false;
    }

    public static void main(String[] args) {
        CustomerDAO customerDAO = new CustomerDAO();

        List<Customer> customers = customerDAO.findAll(1, 5);

        for (Customer customer : customers) {
            System.out.println(customer.toString());
        }
    }

    // Deprecated - kept for backward compatibility, but recommend using more
    // specific methods above
}
