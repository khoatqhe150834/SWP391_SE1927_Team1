/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.RememberMeTokenDAO;
import dao.UserDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import model.Customer;
import model.User;

/**
 * Controller for changing password in user profile
 * Requires user to be authenticated and provide current password
 */
@WebServlet(name = "ChangePasswordController", urlPatterns = { "/profile/change-password" })
public class ChangePasswordController extends HttpServlet {

    private CustomerDAO customerDAO;
    private UserDAO userDAO;
    private AccountDAO accountDAO;
    private RememberMeTokenDAO rememberMeTokenDAO;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        customerDAO = new CustomerDAO();
        userDAO = new UserDAO();
        accountDAO = new AccountDAO();
        rememberMeTokenDAO = new RememberMeTokenDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * Shows the change password form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is authenticated
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward to change password page
        request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes the password change request
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is authenticated
        HttpSession session = request.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("authenticated"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Preserve input values for potential error cases
        request.setAttribute("attemptedCurrentPassword", currentPassword);
        request.setAttribute("attemptedNewPassword", newPassword);
        request.setAttribute("attemptedConfirmPassword", confirmPassword);

        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Tất cả các trường đều bắt buộc.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request,
                    response);
            return;
        }

        // Check if new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request,
                    response);
            return;
        }

        // Validate new password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request,
                    response);
            return;
        }

        try {
            // Determine if user is staff or customer (similar to LoginController logic)
            User user = (User) session.getAttribute("user");
            Customer customer = (Customer) session.getAttribute("customer");

            String userEmail = null;
            boolean passwordChanged = false;

            if (user != null) {
                userEmail = user.getEmail();
                // Handle staff/admin password change
                passwordChanged = handleUserPasswordChange(user, currentPassword, newPassword, request);
            } else if (customer != null) {
                userEmail = customer.getEmail();
                // Handle customer password change
                passwordChanged = handleCustomerPasswordChange(customer, currentPassword, newPassword, request);
            } else {
                // No valid user found in session
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if (passwordChanged) {
                // Password changed successfully - clean up remember me tokens and cookies
                cleanupRememberMeData(userEmail, request, response);

                // Invalidate session for security
                session.invalidate();

                // Create new session for redirect message
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("passwordChangeSuccess", true);
                newSession.setAttribute("passwordChangeEmail", userEmail);

                // Redirect to login page with success message
                response.sendRedirect(request.getContextPath() + "/login?passwordChanged=true&email=" +
                        java.net.URLEncoder.encode(userEmail, "UTF-8"));
                return;
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/view/password/change-profile-password.jsp").forward(request, response);
    }

    /**
     * Handle password change for staff/admin users
     */
    private boolean handleUserPasswordChange(User user, String currentPassword, String newPassword,
            HttpServletRequest request) throws SQLException {
        // Verify current password by attempting login (similar to LoginController)
        User verifyUser = userDAO.getUserByEmailAndPassword(user.getEmail(), currentPassword);
        if (verifyUser == null) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            return false;
        }

        // Update password
        boolean success = accountDAO.updateUserPassword(user.getEmail(), newPassword);
        if (!success) {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            return false;
        }

        return true;
    }

    private boolean handleCustomerPasswordChange(Customer customer, String currentPassword, String newPassword,
            HttpServletRequest request) throws SQLException {
        // Verify current password by attempting login (similar to LoginController)
        Customer verifyCustomer = customerDAO.getCustomerByEmailAndPassword(customer.getEmail(), currentPassword);
        if (verifyCustomer == null) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            return false;
        }

        // Update password
        boolean success = accountDAO.updateCustomerPassword(customer.getEmail(), newPassword);
        if (!success) {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            return false;
        }

        return true;
    }

    /**
     * Clean up remember me tokens and cookies when password is changed
     * This prevents old passwords from being pre-filled on login
     */
    private void cleanupRememberMeData(String email, HttpServletRequest request, HttpServletResponse response) {
        try {
            // Delete remember me tokens from database
            rememberMeTokenDAO.deleteTokensByEmail(email);

            // Remove remember me cookie from browser
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        // Delete the cookie by setting maxAge to 0
                        Cookie deleteCookie = new Cookie("rememberedUser", "");
                        deleteCookie.setMaxAge(0);
                        deleteCookie.setPath("/");
                        deleteCookie.setHttpOnly(true);
                        deleteCookie.setSecure(request.isSecure());
                        response.addCookie(deleteCookie);
                        break;
                    }
                }
            }

        } catch (Exception e) {
            // Log error but don't break the password change process
            System.out.println("Error cleaning up remember me data: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Profile Password Change Controller";
    }
}
