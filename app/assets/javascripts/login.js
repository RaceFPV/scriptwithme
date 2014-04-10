$(document).ready(function() {
	var signInInstead = false;
	// Click on the Sign in link on Signup modal.
	$("#signup_modal header a").click(function(event) {
		signInInstead = true;
	});
	$("#signup_modal").on("hidden", function() {
		if (signInInstead) {
			signInInstead = false;
			$(".signin-link").click();
		}
	});
	$(".signin-form").submit(function(event) {
		event.preventDefault();
		$.ajax({
			url: "/users/sign_in.json",
			type: "post",
			dataType: "json",
			data: $(this).serialize(),
			success: function(data) {
				$(".header-nav > .signin-dropdown").removeClass("open");
				$(document).trigger("user:signed-in", {user: data});
			},
			error: function(xhr) {
				var responseText = xhr.responseText;
				try {
					object = $.parseJSON(responseText);

					if (object.error) {
						$(".signin-form .error").show().html(object.error);
					}
				} catch (exception) {
					$(document).trigger("error:signup", {status: status});
				}
			}
		});
	});
	$(".signup-form").submit(function(event) {
		event.preventDefault();
		$.ajax({
			url: "/users.json",
			type: "post",
			dataType: "json",
			data: $(this).serialize(),
			success: function(data) {
				$("#signup_modal").modal("hide");
				$(document).trigger("user:created", {user: data});
				$(document).trigger("user:signed-in", {user: data});
			},
			error: function(xhr, status) {
				var responseText = xhr.responseText;
				try {
					object = $.parseJSON(responseText);

					if (object.errors) {
						$(".signup-form .control-group.error").removeClass("error");
						for (var p in object.errors) {
							$(".signup-form ." + p + "-control-group").addClass("error");
						}
						var template = Handlebars.compile($(".signup-form-errors-template").html());
						$(".signup-form .errors").show().html(template(object.errors));
					}
				} catch (exception) {
					$(document).trigger("error:signup", {status: status});
				}
			}
		});
	});
	$(document).bind("user:signed-in", function(event, data) {
		loggedIn = true;
		$(".signin-dropdown").hide();
		$(".welcome-nav").hide();
		var template = Handlebars.compile($(".signout-nav-template").html());
		$(".signout-dropdown").html(template(data.user)).show();
	});
	$(document).bind("dialog:show-signup-dialog", function() {
		$(".signup-form .control-group.error").removeClass("error");
		$(".signup-form .errors").hide().html("");
		$("#signup_modal").modal("show");
	});
	$(document).bind("dialog:hide-signup-dialog", function() {
		$("#signup_modal").modal("hide");
	});
	$(document).on("click", ".signin-dropdown .dropdown-toggle", function(event) {
		$(".signin-form .error").hide().html("");
	});
});