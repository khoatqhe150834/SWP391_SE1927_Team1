package controller;

import dao.PromotionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Promotion;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller handling promotion-related requests URL Pattern: /promotion/*
 * Supports actions: list, view, create, edit, delete, search
 */
@WebServlet(urlPatterns = {"/promotion/*"})
public class PromotionController extends HttpServlet {

    private PromotionDAO promotionDAO;
    private static final Logger logger = Logger.getLogger(PromotionController.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        promotionDAO = new PromotionDAO();
        logger.info("PromotionController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        logger.info("GET request - PathInfo: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                handleListPromotions(request, response);
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length < 2) {
                handleListPromotions(request, response);
                return;
            }

            String action = pathParts[1].toLowerCase();

            switch (action) {
                case "list":
                    handleListPromotions(request, response);
                    break;
                case "view":
                    handleViewPromotion(request, response);
                    break;
                case "create":
                    handleShowCreateForm(request, response);
                    break;
                case "edit":
                    handleShowEditForm(request, response);
                    break;
                case "deactivate":
                    handleDeactivatePromotion(request, response);
                    break;
                case "activate":
                    handleActivatePromotion(request, response);
                    break;
                case "scheduled":
                    handleScheduledPromotion(request, response);
                    break;
                case "search":
                    handleListPromotions(request, response);
                    break;
                default:
                    logger.warning("Invalid action: " + action);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not found: " + action);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in GET request", e);
            handleError(request, response, "An error occurred: " + e.getMessage(), "error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        logger.info("POST request - Action: " + action);

        try {
            if (action == null || action.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action parameter is missing");
                return;
            }

            switch (action.toLowerCase()) {
                case "create":
                    handleCreatePromotion(request, response);
                    break;
                case "update":
                    handleUpdatePromotion(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action: " + action);
                    break;
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in POST request", e);
            handleError(request, response, "An error occurred: " + e.getMessage(), "error");
        }
    }

    /**
     * Handle promotion list with pagination and filtering
     */
    private void handleListPromotions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
            String status = getStringParameter(request, "status");

            // Get sorting parameters
            String sortBy = getStringParameter(request, "sortBy");
            String sortOrder = getStringParameter(request, "sortOrder");

            // Get search parameters
            String searchType = getStringParameter(request, "searchType");
            String searchValue = getStringParameter(request, "searchValue");

            // Validate parameters
            if (page < 1) {
                page = 1;
            }
            if (pageSize < 1) {
                pageSize = DEFAULT_PAGE_SIZE;
            }
            if (pageSize > 100) {
                pageSize = 100;
            }

            List<Promotion> promotions;
            int totalPromotions;

            // Map sortBy sang tên cột SQL
            String sortColumn = sortBy;
            if ("id".equals(sortBy)) {
                sortColumn = "promotion_id";
            } else if ("name".equals(sortBy)) {
                sortColumn = "title";
            }

            // Handle search
            if (searchValue != null && !searchValue.isEmpty()) {
                promotions = promotionDAO.searchPromotions(searchValue, page, pageSize,
                        sortColumn != null ? sortColumn : "created_at", sortOrder != null ? sortOrder : "desc");
                totalPromotions = promotionDAO.getTotalSearchResults(searchValue);
            } else if (status != null && !status.isEmpty()) {
                promotions = promotionDAO.findByStatus(status, page, pageSize, sortColumn, sortOrder);
                totalPromotions = promotionDAO.getTotalPromotionsByStatus(status);
            } else {
                promotions = promotionDAO.findAll(page, pageSize, sortColumn, sortOrder);
                totalPromotions = promotionDAO.getTotalPromotions();
            }

            // Sau khi lấy promotions (dưới đoạn set promotions = ...)
            if (sortBy != null && sortOrder != null) {
                if ("id".equals(sortBy)) {
                    promotions.sort(java.util.Comparator.comparing(Promotion::getPromotionId));
                } else if ("desc".equals(sortOrder)) {
                    promotions.sort(java.util.Comparator.comparing(Promotion::getPromotionId).reversed());
                }
            }

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalPromotions / pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (page > totalPages) {
                page = totalPages;
            }

            // Set request attributes
            request.setAttribute("listPromotion", promotions);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalPromotions", totalPromotions);
            request.setAttribute("status", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchType", searchType);
            request.setAttribute("searchValue", searchValue);

            logger.info(String.format("Loaded promotion list - Page: %d, Size: %d, Total: %d, Found: %d",
                    page, pageSize, totalPromotions, promotions.size()));

            request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading promotion list", e);
            handleError(request, response, "Error loading promotion list: " + e.getMessage(), "error");
        }
    }

    /**
     * Handle viewing promotion details
     */
    private void handleViewPromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String promotionIdStr = request.getParameter("id");

            // Kiểm tra xem parameter 'id' có tồn tại và không rỗng hay không
            if (promotionIdStr == null || promotionIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Promotion ID is missing in the URL. Please provide an 'id' parameter.");
                return;
            }
            // --- ĐẾN ĐÂY ---

            // Phần còn lại của phương thức giữ nguyên
            int promotionId = Integer.parseInt(promotionIdStr);

            if (promotionId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid promotion ID.");
                return;
            }

            Optional<Promotion> promotionOpt = this.promotionDAO.findById(promotionId);

            if (promotionOpt.isPresent()) {
                request.setAttribute("promotion", promotionOpt.get());

                request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_details.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Promotion not found with ID: " + promotionId);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid promotion ID format. ID must be a number.");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error viewing promotion", e);
            // Giả sử bạn có phương thức handleError
            handleError(request, response, "An error occurred while retrieving promotion details.", "error");
        }
    }

    /**
     * Display create promotion form
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_edit.jsp")
                .forward(request, response);
    }

    /**
     * Display edit promotion form
     */
    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                throw new IllegalArgumentException("Invalid promotion ID");
            }

            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (promotionOpt.isPresent()) {
                request.setAttribute("promotion", promotionOpt.get());
                request.setAttribute("isEdit", true);
                request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_edit.jsp")
                        .forward(request, response);
            } else {
                throw new IllegalArgumentException("Promotion not found with ID: " + promotionId);
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error displaying edit form", e);
            request.setAttribute("error", "Error displaying edit form: " + e.getMessage());
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_edit.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handle creating a promotion
     */
    private void handleCreatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get and validate data
            String title = getStringParameter(request, "title");
            String promotionCode = getStringParameter(request, "promotionCode");
            String discountType = getStringParameter(request, "discountType");
            String discountValueStr = getStringParameter(request, "discountValue");
            String description = getStringParameter(request, "description");
            String status = getStringParameter(request, "status", "SCHEDULED");

            validatePromotionData(title, promotionCode, discountType, discountValueStr);

            // Create promotion object
            Promotion promotion = new Promotion();
            promotion.setTitle(title);
            promotion.setPromotionCode(promotionCode != null ? promotionCode.toUpperCase() : null);
            promotion.setDiscountType(discountType);
            promotion.setDiscountValue(new BigDecimal(discountValueStr));
            promotion.setDescription(description);
            promotion.setStatus(status);
            promotion.setStartDate(LocalDateTime.now());
            promotion.setEndDate(LocalDateTime.now().plusMonths(1));
            promotion.setCurrentUsageCount(0);
            promotion.setIsAutoApply(false);
            promotion.setMinimumAppointmentValue(BigDecimal.ZERO);
            promotion.setApplicableScope("ENTIRE_APPOINTMENT");

            // Save promotion
            promotionDAO.save(promotion);

            logger.info("Promotion created successfully: " + promotion.getPromotionId());

            request.setAttribute("toastMessage", "Promotion created successfully");
            request.setAttribute("toastType", "success");
            handleListPromotions(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating promotion", e);
            request.setAttribute("error", "Error creating promotion: " + e.getMessage());
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_form.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handle updating a promotion
     */
    private void handleUpdatePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get and validate ID
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                throw new IllegalArgumentException("Invalid promotion ID");
            }

            Optional<Promotion> promotionOpt = promotionDAO.findById(promotionId);
            if (!promotionOpt.isPresent()) {
                throw new IllegalArgumentException("Promotion not found with ID: " + promotionId);
            }

            Promotion promotion = promotionOpt.get();

            // Get and validate data
            String title = getStringParameter(request, "title");
            String promotionCode = getStringParameter(request, "promotionCode");
            String discountType = getStringParameter(request, "discountType");
            String discountValueStr = getStringParameter(request, "discountValue");
            String description = getStringParameter(request, "description");
            String status = getStringParameter(request, "status", promotion.getStatus());
            String startDateStr = getStringParameter(request, "startDate");
            String endDateStr = getStringParameter(request, "endDate");

            validatePromotionData(title, promotionCode, discountType, discountValueStr);

            // Update data
            promotion.setTitle(title);
            promotion.setPromotionCode(promotionCode != null ? promotionCode.toUpperCase() : null);
            promotion.setDiscountType(discountType);
            promotion.setDiscountValue(new BigDecimal(discountValueStr));
            promotion.setDescription(description);
            promotion.setStatus(status);

            // Update dates if provided
            if (startDateStr != null && !startDateStr.isEmpty()) {
                promotion.setStartDate(LocalDateTime.parse(startDateStr + "T00:00:00"));
            }
            if (endDateStr != null && !endDateStr.isEmpty()) {
                promotion.setEndDate(LocalDateTime.parse(endDateStr + "T23:59:59"));
            }

            // Update promotion
            promotionDAO.update(promotion);

            logger.info("Promotion updated successfully: " + promotionId);

            request.setAttribute("toastMessage", "Promotion updated successfully");
            request.setAttribute("toastType", "success");

            // Redirect to list with parameters
            response.sendRedirect(request.getContextPath() + "/promotion/list");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating promotion", e);
            request.setAttribute("error", "Error updating promotion: " + e.getMessage());
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_edit.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Handle deleting a promotion
     */
    private void handleDeletePromotion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                throw new IllegalArgumentException("Invalid promotion ID");
            }

            promotionDAO.deleteById(promotionId);
            logger.info("Promotion deleted successfully: " + promotionId);

            request.setAttribute("toastMessage", "Promotion deleted successfully");
            request.setAttribute("toastType", "success");
            handleListPromotions(request, response);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting promotion", e);
            handleError(request, response, "Error deleting promotion: " + e.getMessage(), "error");
        }
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, String toastType)
            throws ServletException, IOException {

        request.setAttribute("toastMessage", errorMessage);
        request.setAttribute("toastType", toastType);
        request.getRequestDispatcher("/WEB-INF/view/admin_pages/promotion_list.jsp")
                .forward(request, response);
    }

    /**
     * Get integer parameter
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramValue = request.getParameter(paramName);
        if (paramValue != null && !paramValue.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramValue.trim());
            } catch (NumberFormatException e) {
                logger.warning("Invalid number parameter " + paramName + ": " + paramValue);
            }
        }
        return defaultValue;
    }

    /**
     * Get string parameter
     */
    private String getStringParameter(HttpServletRequest request, String paramName, String defaultValue) {
        String paramValue = request.getParameter(paramName);
        return (paramValue != null && !paramValue.trim().isEmpty()) ? paramValue.trim() : defaultValue;
    }

    private String getStringParameter(HttpServletRequest request, String paramName) {
        return getStringParameter(request, paramName, null);
    }

    /**
     * Validate promotion data
     */
    private void validatePromotionData(String title, String promotionCode, String discountType, String discountValueStr)
            throws IllegalArgumentException {

        if (title == null || title.trim().length() < 3) {
            throw new IllegalArgumentException("Title must be at least 3 characters long");
        }
        if (promotionCode != null && !promotionCode.matches("^[A-Z0-9]{3,10}$")) {
            throw new IllegalArgumentException("Promotion code must be 3-10 characters, containing only uppercase letters and numbers");
        }
        if (!"PERCENTAGE".equalsIgnoreCase(discountType) && !"FIXED".equalsIgnoreCase(discountType)) {
            throw new IllegalArgumentException("Discount type must be 'PERCENTAGE' or 'FIXED'");
        }
        try {
            BigDecimal discountValue = new BigDecimal(discountValueStr);
            if (discountValue.compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("Discount value must be greater than 0");
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid discount value");
        }
    }

    private void handleDeactivatePromotion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectUrl = buildListRedirectUrl(request);

        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid promotion ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (promotionDAO.deactivatePromotion(promotionId)) {
                request.getSession().setAttribute("successMessage", "promotion has been deactivated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to deactivate the promotion.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deactivating promotion", e);
            request.getSession().setAttribute("errorMessage", "Error deactivating promotion: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private void handleActivatePromotion(HttpServletRequest request, HttpServletResponse response) throws IOException {
          String redirectUrl = buildListRedirectUrl(request);

        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid promotion ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (promotionDAO.activatePromotion(promotionId)) {
                request.getSession().setAttribute("successMessage", "promotion has been deactivated successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to activate the promotion.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error activating promotion", e);
            request.getSession().setAttribute("errorMessage", "Error activating promotion: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private void handleScheduledPromotion(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectUrl = buildListRedirectUrl(request);

        try {
            int promotionId = getIntParameter(request, "id", 0);
            if (promotionId <= 0) {
                request.getSession().setAttribute("errorMessage", "Invalid promotion ID provided.");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (promotionDAO.scheduledPromotion(promotionId)) {
                request.getSession().setAttribute("successMessage", "promotion has been scheduled successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to scheduled the promotion.");
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error scheduleding promotion", e);
            request.getSession().setAttribute("errorMessage", "Error scheduledting promotion: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private String buildListRedirectUrl(HttpServletRequest request) {
        String page = request.getParameter("page");
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<String> params = new ArrayList<>();
        if (page != null && !page.isEmpty()) {
            params.add("page=" + page);
        }
        if (search != null && !search.isEmpty()) {
            try {
                // Quan trọng: Mã hóa giá trị tìm kiếm để tránh lỗi URL
                params.add("search=" + URLEncoder.encode(search, StandardCharsets.UTF_8.toString()));
            } catch (Exception e) {
                logger.warning("Could not encode search parameter: " + e.getMessage());
            }
        }
        if (status != null && !status.isEmpty()) {
            params.add("status=" + status);
        }

        String queryString = String.join("&", params);
        if (queryString.isEmpty()) {
            return request.getContextPath() + "/promotion/list";
        } else {
            return request.getContextPath() + "/promotion/list?" + queryString;
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t");
    }

}
