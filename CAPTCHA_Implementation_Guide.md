SITE KEY: 6LcD4GIrAAAAAEQxHb-FotK15j9aU_CegmMGUgBC
SECRET KEY: 6LcD4GIrAAAAAIT7dN2AXmYUKUYXiXLgL_ONifEP

<html>
  <head>
    <title>reCAPTCHA demo: Simple page</title>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
  </head>
  <body>
    <form action="?" method="POST">
      <div class="g-recaptcha" data-sitekey="your_site_key"></div>
      <br/>
      <input type="submit" value="Submit">
    </form>
  </body>
</html>

<script type="text/javascript">
  var onloadCallback = function() {
    alert("grecaptcha is ready!");
  };
</script>
