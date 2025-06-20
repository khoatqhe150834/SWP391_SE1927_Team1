<%-- Document : login Created on : May 27, 2025, 7:34:53 AM Author : quang --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@page
contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="keywords" content="" />
    <meta name="author" content="" />
    <meta name="robots" content="" />
    <meta
      name="description"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:title"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:description"
      content="BeautyZone : Beauty Spa Salon HTML Template"
    />
    <meta
      property="og:image"
      content="../../beautyzone.dexignzone.com/xhtml/social-image.png"
    />
    <meta name="format-detection" content="telephone=no" />

    <!-- FAVICONS ICON -->
     <link
      rel="icon"
      href="${pageContext.request.contextPath}/assets/home/images/favicon.ico"
      type="image/x-icon"
    />
    <link
      rel="shortcut icon"
      type="image/x-icon"
      href="${pageContext.request.contextPath}/assets/home/images/favicon.png"
    />
    <!-- PAGE TITLE HERE -->
    <title>BeautyZone : Beauty Spa Salon HTML Template</title>

    <!-- MOBILE SPECIFIC -->
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!--[if lt IE 9]>
      <script src="js/html5shiv.min.js"></script>
      <script src="js/respond.min.js"></script>
    <![endif]-->

    <!-- STYLESHEETS -->
    <jsp:include page="/WEB-INF/view/common/home/stylesheet.jsp"></jsp:include>
  </head>
  <body id="bg">
    <div class="page-wraper">
      <div id="loading-area"></div>
      <!-- header -->
      <jsp:include page="/WEB-INF/view/common/home/header.jsp"></jsp:include>

      <!-- header END -->
      <!-- Content -->
      <div class="page-content bg-white">
        <!-- inner page banner -->
        <div
          class="dlab-bnr-inr overlay-primary bg-pt"
           style="
            background-image: url(${pageContext.request.contextPath}/assets/home/images/banner/bnr2.jpg);
          "
        >
          <div class="container">
            <div class="dlab-bnr-inr-entry">
              <h1 class="text-white">Đăng nhập</h1>
              <!-- Breadcrumb row -->
              <div class="breadcrumb-row">
                <ul class="list-inline">
                  <li><a href="index.html">Trang chủ</a></li>
                  <li>Đăng nhập</li>
                </ul>
              </div>
              <!-- Breadcrumb row END -->
            </div>
          </div>
        </div>
        <!-- inner page banner END -->
        <!-- contact area -->
        <div class="section-full content-inner shop-account">
          <!-- Product -->
          <div class="container">
            <div class="row">
              <div class="col-md-12 text-center">
                <h3 class="font-weight-700 m-t0 m-b20">Đăng nhập tài khoản</h3>
              </div>
            </div>
            <div>
              <div class="max-w500 m-auto m-b30">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        ${error}
                        <c:if test="${showResendLink == true}">
                            <br><br>
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/resend-verification?email=${customerEmail}" 
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="fa fa-envelope"></i> Gửi lại email xác thực
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success ${param.passwordChanged == 'true' ? 'password-change-success' : ''}" style="margin-bottom: 20px;">
                        <c:if test="${param.passwordChanged == 'true'}">
                            <i class="fa fa-check-circle" style="font-size: 18px; margin-right: 8px;"></i>
                        </c:if>
                        ${success}
                        <c:if test="${param.passwordChanged == 'true'}">
                            <br><small style="margin-top: 8px; display: block; opacity: 0.9;">
                                <i class="fa fa-info-circle"></i> Email của bạn đã được điền sẵn bên dưới
                            </small>
                        </c:if>
                    </div>
                </c:if>
                <div class="p-a30 border-1 seth">
                  <div class="tab-content nav">
                      <form id="loginForm" method="post" action="login"  class="tab-pane active col-12 p-a0" >
                      <h4 class="font-weight-700">ĐĂNG NHẬP</h4>
                      <p class="font-weight-600">
                        Nếu bạn đã có tài khoản, vui lòng đăng nhập.
                      </p>
                      <div class="form-group">
                        <label class="font-weight-700">E-MAIL *</label>
                        <input
                          name="email"
                          id="emailInput"
                          required="true"
                          class="form-control"
                          placeholder="example@gmail.com"
                          type="email"
                          value="${attemptedEmail != null ? attemptedEmail : (prefillEmail != null ? prefillEmail : (rememberedEmail != null ? rememberedEmail : ''))}"
                        />
                        <div id="emailError" class="field-error-message" style="display: none;"></div>
                      </div>
                      <div class="form-group">
                        <label class="font-weight-700">MẬT KHẨU *</label>
                        <input
                          name="password"
                          id="passwordInput"
                          required="true"
                          class="form-control"
                          placeholder="******"
                          type="password"
                          value="${attemptedPassword != null ? attemptedPassword : (prefillPassword != null ? prefillPassword : (rememberedPassword != null ? rememberedPassword : ''))}"
                        />
                        <div id="passwordError" class="field-error-message" style="display: none;"></div>
                      </div>

<!-- Remember Me Checkbox -->
<div class="form-group">
  <div class="form-check">
    <input 
      type="checkbox" 
      name="rememberMe" 
      id="rememberMe" 
      class="form-check-input"
      style="margin-right: 8px;"
      value="true"
      ${rememberMeChecked ? 'checked="checked"' : ''}
    />
    <label for="rememberMe" class="form-check-label font-weight-600">
      Ghi nhớ tôi
    </label>
  </div>
</div>

<!-- reCAPTCHA Widget -->
<div class="form-group">
  <div class="g-recaptcha" data-sitekey="6LcD4GIrAAAAAEQxHb-FotK15j9aU_CegmMGUgBC" 
       data-theme="light" data-size="normal"></div>
  <div id="recaptchaError" class="field-error-message" style="display: none;"></div>
</div>

                      <div class="text-left">
                       <button class="site-button m-r5 button-lg radius-no">ĐĂNG NHẬP</button>
                        <a
                          
                          href="${pageContext.request.contextPath}/reset-password"
                          class="m-l5"
                          ><i class="fa fa-unlock-alt"></i> Quên mật khẩu</a
                        >
                      </div>
                    </form>
                    <form
                      id="forgot-password"
                      class="tab-pane fade col-12 p-a0"
                    >
                      <h4 class="font-weight-700">QUÊN MẬT KHẨU ?</h4>
                      <p class="font-weight-600">
                        Chúng tôi sẽ gửi cho bạn một email để đặt lại mật khẩu
                        của bạn.
                      </p>
                      <div class="form-group">
                        <label class="font-weight-700">E-MAIL *</label>
                        <input
                          name="dzName"
                          required=""
                          class="form-control"
                          placeholder="Email của bạn"
                          type="email"
                        />
                      </div>
                      <div class="text-left">
                        <a
                          class="site-button outline gray button-lg radius-no"
                          data-toggle="tab"
                          href="#login"
                          >Quay lại</a
                        >
                        <button class="site-button m-r5 button-lg radius-no">Gửi</button>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- Product END -->
        </div>

        <!-- contact area  END -->
      </div>
      <!-- Content END-->
      <!-- Footer -->
      <jsp:include page="/WEB-INF/view/common/home/footer.jsp"></jsp:include>
      <!-- Footer END -->
      <button class="scroltop fa fa-chevron-up"></button>
    </div>
    <!-- JAVASCRIPT FILES ========================================= -->
    <jsp:include page="/WEB-INF/view/common/home/js.jsp"></jsp:include>
    
    <!-- Google reCAPTCHA v2 -->
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    
    <!-- Common Email Validation Utility -->
    <script src="${pageContext.request.contextPath}/assets/home/js/common/email-validation.js"></script>
    
    <!-- Login Form Validation -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize common email validator
            const emailValidator = EmailValidator.init('#emailInput', '#emailError');
            
            const passwordInput = document.getElementById('passwordInput');
            const passwordError = document.getElementById('passwordError');
            const loginForm = document.getElementById('loginForm');
            
            // Password validation function
            function validatePassword(password) {
                if (!password || password.trim() === '') {
                    return 'Vui lòng nhập mật khẩu';
                }
                
                if (password.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                
                return null;
            }
            
            function showPasswordError(message) {
                passwordError.textContent = message;
                passwordError.style.display = 'block';
                passwordInput.classList.add('field-error');
                passwordInput.classList.remove('field-valid');
            }
            
            function hidePasswordError() {
                passwordError.style.display = 'none';
                passwordError.textContent = '';
                passwordInput.classList.remove('field-error');
                passwordInput.classList.add('field-valid');
            }
            
            function clearPasswordValidation() {
                passwordError.style.display = 'none';
                passwordError.textContent = '';
                passwordInput.classList.remove('field-error', 'field-valid');
            }
            
            // Real-time password validation
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                const error = validatePassword(password);
                
                if (error) {
                    showPasswordError(error);
                } else if (password) {
                    hidePasswordError();
                } else {
                    clearPasswordValidation();
                }
            });
            
            // reCAPTCHA validation functions
            const recaptchaError = document.getElementById('recaptchaError');
            
            function showRecaptchaError(message) {
                recaptchaError.textContent = message;
                recaptchaError.style.display = 'block';
            }
            
            function hideRecaptchaError() {
                recaptchaError.style.display = 'none';
                recaptchaError.textContent = '';
            }
            
            // Form submission validation
            loginForm.addEventListener('submit', function(e) {
                // Get reCAPTCHA response
                const recaptchaResponse = grecaptcha.getResponse();
                
                // Validate reCAPTCHA first
                if (!recaptchaResponse || recaptchaResponse.length === 0) {
                    showRecaptchaError('Vui lòng xác thực reCAPTCHA trước khi đăng nhập.');
                    e.preventDefault();
                    return false;
                } else {
                    hideRecaptchaError();
                }
                
                const emailResult = emailValidator.validate();
                const passwordValidation = validatePassword(passwordInput.value);
                
                let hasErrors = false;
                
                if (!emailResult.isValid) {
                    hasErrors = true;
                }
                
                if (passwordValidation) {
                    showPasswordError(passwordValidation);
                    hasErrors = true;
                } else {
                    hidePasswordError();
                }
                
                if (hasErrors) {
                    e.preventDefault();
                    
                    // Focus on first error field
                    if (!emailResult.isValid) {
                        emailValidator.focus();
                    } else if (passwordValidation) {
                        passwordInput.focus();
                    }
                }
            });
            
            // Handle password change success prefill
            const urlParams = new URLSearchParams(window.location.search);
            const isPasswordChanged = urlParams.get('passwordChanged') === 'true';
            
            if (isPasswordChanged) {
                // Highlight the pre-filled email field
                if (emailInput.value) {
                    emailInput.classList.add('password-change-prefill');
                    
                    // Add a gentle pulse effect to draw attention
                    emailInput.style.animation = 'pulse 3s ease-in-out 2';
                    
                    // Focus on password field since email is already filled
                    setTimeout(function() {
                        passwordInput.focus();
                    }, 1000);
                }
                
                // Make success message more prominent
                const successAlert = document.querySelector('.password-change-success');
                if (successAlert) {
                    successAlert.style.boxShadow = '0 4px 20px rgba(40, 167, 69, 0.3)';
                }
            }
            
            // Legacy: Check if user just changed password via session storage
            const passwordJustChanged = sessionStorage.getItem('passwordJustChanged');
            const loginEmail = sessionStorage.getItem('loginEmail');
            const loginPassword = sessionStorage.getItem('loginPassword');
            
            if (passwordJustChanged === 'true' && loginEmail && loginPassword) {
                // Prefill the form
                if (emailInput && passwordInput) {
                    emailInput.value = loginEmail;
                    passwordInput.value = loginPassword;
                    
                    // Add visual indicators
                    emailInput.classList.add('prefilled-success');
                    passwordInput.classList.add('prefilled-success');
                    
                    // Focus on login button
                    setTimeout(function() {
                        const loginButton = document.querySelector('.site-button');
                        if (loginButton) {
                            loginButton.focus();
                            
                            // Add pulsing effect to login button
                            loginButton.style.animation = 'pulse 2s infinite';
                        }
                    }, 500);
                    
                    // Clear the session storage after use
                    sessionStorage.removeItem('passwordJustChanged');
                    sessionStorage.removeItem('loginEmail');
                    sessionStorage.removeItem('loginPassword');
                }
            }
        });
    </script>
    
    <style>
        .prefilled-success {
            background-color: #f8fff8 !important;
            border-color: #28a745 !important;
            box-shadow: 0 0 5px rgba(40, 167, 69, 0.3) !important;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Enhanced styling for password change success */
        .password-change-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb) !important;
            border: 2px solid #28a745 !important;
            border-radius: 8px !important;
            padding: 20px !important;
            font-weight: 600 !important;
            animation: slideInFromTop 0.5s ease-out;
        }
        
        @keyframes slideInFromTop {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Highlight the email field when pre-filled from password change */
        .form-control.password-change-prefill {
            background-color: #f8fff8 !important;
            border-color: #28a745 !important;
            box-shadow: 0 0 8px rgba(40, 167, 69, 0.3) !important;
        }
        
        /* Inline error messages without background */
        .field-error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            font-weight: 500;
            line-height: 1.4;
            padding: 0;
            background: none;
            border: none;
            animation: fadeInError 0.3s ease-in;
        }
        
        @keyframes fadeInError {
            from {
                opacity: 0;
                transform: translateY(-5px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Field validation states */
        .form-control.field-error {
            border-color: #dc3545;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
        }
        
        .form-control.field-valid {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
    </style>
    
    <!-- Auto-focus and highlight for prefilled login -->
    <c:if test="${not empty prefillEmail && not empty prefillPassword}">
    <script>
        $(document).ready(function() {
            // Add visual indicator that fields are prefilled
            $('input[name="email"]').addClass('prefilled');
            $('input[name="password"]').addClass('prefilled');
            
            // Focus on the login button to encourage user to just click login
            
        });
    </script>
    <style>
        .prefilled {
            background-color: #f8fff8 !important;
            border-color: #28a745 !important;
        }
    </style>
    </c:if>
    
    <!-- Handle failed login attempts -->
    <c:if test="${not empty attemptedEmail && not empty error}">
    <script>
        $(document).ready(function() {
            // Add visual indicator for failed attempt
            $('input[name="email"]').addClass('attempted-login');
            $('input[name="password"]').addClass('attempted-login').focus().select();
            
            // Focus on password field since email is likely correct
            setTimeout(function() {
                $('input[name="password"]').focus().select();
            }, 100);
        });
    </script>
    <style>
        .attempted-login {
            background-color: #fff9f9 !important;
            border-color: #dc3545 !important;
        }
    </style>
    </c:if>
  </body>

  <!-- Mirrored from www.beautyzone.dexignzone.com/xhtml/login.html by HTTrack Website Copier/3.x [XR&CO'2014], Sat, 24 May 2025 16:40:31 GMT -->
</html>
