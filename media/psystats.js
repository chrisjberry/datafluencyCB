// Extra stuff for hiding and showing asides

$(document).ready(function() {
	$(".sidenote").each(function() {
		let theId = this.id;
		let theAsideLink = $(`a[href$="${theId}"]`);
		theAsideLink.append('<i class="glyphicon glyphicon-info-sign"></i>');

		theAsideLink.click(function(e) {
			let pos = $(this).position();
			$(this.hash).css({
				position: "absolute",
				top: pos.top,
				left: pos.left
			});
			$(this.hash).show();
			e.preventDefault();
		});

		$(this).prepend('<button type="button" class="close">×</button>');
	});

	// $("div .solution").prepend(
	// 	'<button type="button" class="close">×</button>'
	// );

	// TODO make it so that solution buttons are re-shown when
	// this is clicked... perhaps toggle everything in the parent div?
	$(".close").click(function(e) {
		$(this)
			.parent()
			.hide();

		e.preventDefault();
	});

	$("table").addClass("table");
});
