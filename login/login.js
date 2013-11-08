// Generated by CoffeeScript 1.6.3
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', 'primedia_events', 'jquery-cookie-rjs'], function($, events) {
    var Login;
    Login = (function() {
      Login.prototype.hideIfLoggedInSelector = '.js_hidden_if_logged_in';

      Login.prototype.hideIfLoggedOutSelector = '.js_hidden_if_logged_out';

      function Login() {
        this._triggerModal = __bind(this._triggerModal, this);
        this._submitEmailRegistration = __bind(this._submitEmailRegistration, this);
        this._enableLoginRegistration = __bind(this._enableLoginRegistration, this);
        var _this = this;
        this._overrideDependencies();
        this.my = {
          zmail: $.cookie('zmail'),
          zid: $.cookie('zid'),
          session: $.cookie("sgn") === "temp" || $.cookie("sgn") === "perm",
          currentUrl: window.location.href,
          popupTypes: ["login", "register", "account", "reset", "confirm", "success"]
        };
        $(document).ready(function() {
          $('body').bind('new_zid_obtained', function() {
            return _this.my.zid = $.cookie('zid');
          });
          _this._welcomeMessage();
          _this._toggleLogIn();
          _this._enableLoginRegistration();
          $.each(_this.my.popupTypes, function(index, type) {
            return _this._bindForms(type);
          });
          return $("a.logout").click(function(e) {
            return _this._logOut(e);
          });
        });
      }

      Login.prototype.toggleRegistrationDiv = function($div) {
        var _this = this;
        if (!this.my.session) {
          this.wireupSocialLinks($div.show());
          return $.each(this.my.popupTypes, function(index, type) {
            return _this._bindForms(type);
          });
        }
      };

      Login.prototype.expireCookie = function(cookie) {
        var options;
        if (cookie) {
          options = {
            expires: new Date(1),
            path: "/",
            domain: "." + window.location.host
          };
          return $.cookie(cookie, "", options);
        }
      };

      Login.prototype.wireupSocialLinks = function($div) {
        var baseUrl, fbLink, googleLink, twitterLink;
        baseUrl = "" + zutron_host + "?zid_id=" + this.my.zid + "&referrer=" + (encodeURIComponent(this.my.currentUrl)) + "&technique=";
        fbLink = $div.find("a.icon_facebook48");
        twitterLink = $div.find("a.icon_twitter48");
        googleLink = $div.find("a.icon_google_plus48");
        this._bindSocialLink(fbLink, "" + baseUrl + "facebook", $div);
        this._bindSocialLink(twitterLink, "" + baseUrl + "twitter", $div);
        return this._bindSocialLink(googleLink, "" + baseUrl + "google_oauth2", $div);
      };

      Login.prototype._welcomeMessage = function() {
        if ($.cookie("user_type") === "new") {
          this._triggerModal($("#welcome_message"));
        }
        return this.expireCookie("user_type");
      };

      Login.prototype._enableLoginRegistration = function() {
        var _this = this;
        $('#zutron_register_form form').submit(function(e) {
          return _this._submitEmailRegistration($(e.target));
        });
        $('#zutron_account_form form').submit(function(e) {
          return _this._submitChangeEmail($(e.target));
        });
        $('#zutron_login_form form').submit(function(e) {
          return _this._submitLogin($(e.target));
        });
        $('#zutron_reset_form form').submit(function(e) {
          return _this._submitPasswordReset($(e.target));
        });
        return $('#zutron_confirm_form form').submit(function(e) {
          return _this._submitPasswordConfirm($(e.target));
        });
      };

      Login.prototype._submitEmailRegistration = function($form) {
        var _this = this;
        this._setHiddenValues($form);
        return $.ajax({
          type: 'POST',
          data: $form.serialize(),
          url: "" + zutron_host + "/auth/identity/register",
          beforeSend: function(xhr) {
            xhr.overrideMimeType("text/json");
            return xhr.setRequestHeader("Accept", "application/json");
          },
          success: function(data) {
            if (data['redirectUrl']) {
              _this._stayOrLeave($form);
              $("#zutron_login_form, #zutron_registration").prm_dialog_close();
              _this._setSessionType();
              _this._setEmail($form.find("#email").val());
              events.trigger('event/emailRegistrationSuccess', data);
              return _this._redirectOnSuccess(data, $form);
            } else {
              return _this._generateErrors(data, $form.parent().find(".errors"), 'emailRegistrationSuccessError');
            }
          },
          error: function(errors) {
            return _this._generateErrors($.parseJSON(errors.responseText), $form.parent().find(".errors"), 'emailRegistrationError');
          }
        });
      };

      Login.prototype._submitLogin = function($form) {
        var _this = this;
        this._setHiddenValues($form);
        return $.ajax({
          type: "POST",
          data: $form.serialize(),
          url: "" + zutron_host + "/auth/identity/callback",
          beforeSend: function(xhr) {
            xhr.overrideMimeType("text/json");
            return xhr.setRequestHeader("Accept", "application/json");
          },
          success: function(data) {
            if (data['redirectUrl']) {
              _this._stayOrLeave($form);
              $("#zutron_login_form, #zutron_registration").prm_dialog_close();
              _this._setSessionType();
              _this._setEmail($form.find("#auth_key").val());
              events.trigger('event/loginSuccess', data);
              return _this._redirectOnSuccess(data, $form);
            } else {
              return _this._generateErrors(data, $form.parent().find(".errors"), 'loginSuccessError');
            }
          },
          error: function(errors) {
            return _this._generateErrors($.parseJSON(errors.responseText), $form.parent().find(".errors"), 'loginError');
          }
        });
      };

      Login.prototype._submitChangeEmail = function($form) {
        var new_email,
          _this = this;
        new_email = {
          email: $('input[name="new_email"]').val(),
          email_confirmation: $('input[name="new_email_confirm"]').val()
        };
        return $.ajax({
          type: "GET",
          data: new_email,
          datatype: 'json',
          url: "" + zutron_host + "/zids/" + this.my.zid + "/email_change.json",
          beforeSend: function(xhr) {
            xhr.overrideMimeType("text/json");
            return xhr.setRequestHeader("Accept", "application/json");
          },
          success: function(data) {
            var error;
            if ((data != null) && data.error) {
              error = {
                'email': data.error
              };
              return _this._generateErrors(error, $form.parent().find(".errors", 'changeEmailSuccessError'));
            } else {
              _this._setEmail(new_email.email);
              events.trigger('event/changeEmailSuccess', data);
              $('#zutron_account_form').prm_dialog_close();
              return _this._triggerModal($("#zutron_success_form"));
            }
          },
          error: function(errors) {
            return _this._generateErrors($.parseJSON(errors.responseText), $form.parent().find(".errors", 'changeEmailError'));
          }
        });
      };

      Login.prototype._submitPasswordReset = function($form) {
        var _this = this;
        return $.ajax({
          type: 'POST',
          url: "" + zutron_host + "/password_reset?" + ($form.serialize()),
          beforeSend: function(xhr) {
            xhr.overrideMimeType("text/json");
            return xhr.setRequestHeader("Accept", "application/json");
          },
          success: function(data) {
            var error;
            if (data.error) {
              error = {
                'email': data.error
              };
              return _this._generateErrors(error, $form.parent().find(".errors"), 'passwordResetSuccessError');
            } else {
              $form.parent().empty();
              events.trigger('event/passwordResetSuccess', data);
              return $('.reset_success').html(data.success).show();
            }
          },
          error: function(errors) {
            return _this._generateErrors($.parseJSON(errors.responseText), $form.parent().find(".errors", 'passwordResetError'));
          }
        });
      };

      Login.prototype._submitPasswordConfirm = function($form) {
        var _this = this;
        return $.ajax({
          type: 'POST',
          data: $form.serialize(),
          url: "" + zutron_host + "/password_confirmation",
          beforeSend: function(xhr) {
            xhr.overrideMimeType("text/json");
            return xhr.setRequestHeader("Accept", "application/json");
          },
          success: function(data) {
            var error;
            if ((data != null) && data.error) {
              error = {
                'password': data.error
              };
              return _this._generateErrors(error, $form.parent().find(".errors", 'passwordConfirmSuccessError'));
            } else {
              $form.parent().empty();
              events.trigger('event/passwordConfirmSuccess', data);
              $('.reset_success').html(data.success).show();
              return _this._determineClient();
            }
          },
          error: function(errors) {
            return _this._generateErrors($.parseJSON(errors.responseText), $form.parent().find(".errors", 'passwordConfirmError'));
          }
        });
      };

      Login.prototype._clearInputs = function(formID) {
        var $inputs, $labels;
        $inputs = $(formID + ' input[type="email"]').add($(formID + ' input[type="password"]'));
        $labels = $("#z_form_labels label");
        return $inputs.each(function(index, elem) {
          $(elem).focus(function() {
            return $($labels[index]).hide();
          });
          $(elem).blur(function() {
            if ($(elem).val() === '') {
              return $($labels[index]).show();
            }
          });
          return $($labels[index]).click(function() {
            return $inputs[index].focus();
          });
        });
      };

      Login.prototype._redirectOnSuccess = function(obj, $form) {
        $form.prm_dialog_close();
        if (obj.redirectUrl) {
          return window.location.assign(obj.redirectUrl);
        }
      };

      Login.prototype._generateErrors = function(error, $box, eventName) {
        var $form, messages,
          _this = this;
        events.trigger('event/' + eventName, error);
        this._clearErrors($box.parent());
        messages = '';
        if (error != null) {
          $form = $box.parent().find('form');
          $.each(error, function(key, value) {
            var formattedError;
            $form.find("#" + key).parent('p').addClass('error');
            formattedError = _this._formatError(key, value);
            messages += "<li>" + formattedError + "</li>";
            return $form.find('.error input:first').focus();
          });
        } else {
          messages += "An error has occured.";
        }
        return $box.append("<ul>" + messages + "</ul>");
      };

      Login.prototype._formatError = function(key, value) {
        switch (key) {
          case "base":
            return value;
          case "auth_key":
            if (value) {
              return value;
            } else {
              return '';
            }
            break;
          case "email":
            if (value) {
              return "Email " + value;
            } else {
              return '';
            }
            break;
          case "password":
            if (value) {
              return "Password " + value;
            } else {
              return '';
            }
            break;
          case "password_confirmation":
            return "Password Confirmation " + value;
        }
      };

      Login.prototype._toggleLogIn = function() {
        var $changeLink, $logLink, $regLink;
        $regLink = $("a.register");
        $logLink = $("a.login");
        $changeLink = $('a.account');
        if (this.my.session) {
          $regLink.parent().addClass('hidden');
          $logLink.addClass("logout").removeClass("login");
          $('.link_text', $logLink).text('Log Out');
          if ($.cookie('z_type_email')) {
            $changeLink.parent().removeClass('hidden');
          }
          $(this.hideIfLoggedInSelector).addClass('hidden');
          return $(this.hideIfLoggedOutSelector).removeClass('hidden');
        } else {
          $regLink.parent().removeClass('hidden');
          $('a.logout .link_text').text('Log In');
          $(this.hideIfLoggedInSelector).removeClass('hidden');
          return $(this.hideIfLoggedOutSelector).addClass('hidden');
        }
      };

      Login.prototype._bindForms = function(type) {
        var formID,
          _this = this;
        formID = "#zutron_" + type + "_form";
        if (this.MOBILE && $(formID).is(':visible')) {
          this.wireupSocialLinks($(formID));
          this._clearInputs(formID);
        }
        return $("a." + type).click(function() {
          $('.prm_dialog').prm_dialog_close();
          return _this._triggerModal($(formID));
        });
      };

      Login.prototype._triggerModal = function($div) {
        this._clearErrors($div);
        $div.prm_dialog_open();
        if (this.my.zmail) {
          $div.find('#email, #auth_key').val(this.my.zmail);
        }
        $div.find(':input').filter(':visible:first').focus();
        $div.on("click", "a.close", function() {
          return $div.prm_dialog_close();
        });
        return this.wireupSocialLinks($div);
      };

      Login.prototype._clearErrors = function($div) {
        $div.find('form p').removeClass('error');
        return $div.find('.errors').empty();
      };

      Login.prototype._bindSocialLink = function($link, url, $div) {
        var _this = this;
        return $link.on("click", function() {
          _this._stayOrLeave($div);
          return _this._redirectTo(url);
        });
      };

      Login.prototype._stayOrLeave = function($form) {
        var options, staySignedIn;
        staySignedIn = $form.find('input[type="checkbox"]').attr('checked');
        if (staySignedIn) {
          options = {
            path: "/",
            domain: window.location.host
          };
          return $.cookie("stay", "true", options);
        } else {
          return this.expireCookie("sgn");
        }
      };

      Login.prototype._logOut = function(e) {
        var all_cookies,
          _this = this;
        e.preventDefault();
        all_cookies = ["provider", "sgn", "zid", "z_type_email"];
        $.each(all_cookies, function(index, cookie) {
          return _this.expireCookie(cookie);
        });
        return window.location.replace(this.my.currentUrl);
      };

      Login.prototype._redirectTo = function(url) {
        var _this = this;
        return $.ajax({
          type: "get",
          url: zutron_host + "/ops/heartbeat/riak",
          success: function() {
            return window.location.assign(url);
          },
          error: function() {
            _this.my.registrationForm.prm_dialog_close();
            $("#zutron_login_form, #zutron_registration").prm_dialog_close();
            return _this._triggerModal($("#zutron_error"));
          }
        });
      };

      Login.prototype._setHiddenValues = function($form) {
        $form.find("input#state").val(this.my.zid);
        return $form.find("input#origin").val(encodeURIComponent(this.my.currentUrl));
      };

      Login.prototype._determineClient = function() {
        var clients,
          _this = this;
        if (this.my.currentUrl.indexOf('client') > 0) {
          clients = ["iOS", "android"];
          return $.each(clients, function(client) {
            var myClient;
            myClient = _this.my.currentUrl.substring(_this.my.currentUrl.indexOf('client'), location.href.length);
            myClient = myClient.split("=")[1].toLowerCase();
            return _this._createAppButton(myClient);
          });
        } else {
          return $('#reset_return_link').attr('href', "http://" + window.location.host).show();
        }
      };

      Login.prototype._createAppButton = function(client) {
        var btn, launchUrl;
        if (client) {
          launchUrl = "com.primedia.Apartments://settings";
        }
        btn = "<a href='" + launchUrl + "' class='" + client + "_app_button'>Launch ApartmentGuide App</a>";
        return $('#app_container').html(btn);
      };

      Login.prototype._setSessionType = function() {
        return $.cookie('z_type_email', 'profile');
      };

      Login.prototype._setEmail = function(email) {
        this.my.zmail = email;
        return $.cookie('zmail', email);
      };

      Login.prototype._overrideDependencies = function() {
        this.MOBILE = window.location.host.match(/(^m\.|^local\.m\.)/) != null;
        this.BIGWEB = !this.MOBILE;
        if (this.BIGWEB) {
          return this._clearInputs = function() {};
        }
      };

      return Login;

    })();
    return {
      instance: {},
      init: function() {
        return this.instance = new Login();
      },
      wireupSocialLinks: function() {
        return this.instance.wireupSocialLinks();
      },
      toggleRegistrationDiv: function(div) {
        return this.instance.toggleRegistrationDiv(div);
      },
      expireCookie: function() {
        return this.instance.expireCookie();
      },
      session: function() {
        return this.instance.my.session;
      }
    };
  });

}).call(this);
