$(function () {
	$.image_preview = function (input, context, size) {
		// defulat size = 100px
		if (typeof(size) === 'undefined')
			size = 100;

		var files = !!input.prop('files') ? input.prop('files') : [];
		
		if (!files.length || !window.FileReader)
			return;

		if (/^image/.test(files[0].type)) {
			// only accept image file
			var reader = new FileReader();

			reader.onloadend = function () {
				var html = "";
				html += "<img src='"+ this.result + "' title='"+ this.name +"' width='"+ size +"px' height='"+ size +"px' />"
				context.html(html);
			};
			reader.readAsDataURL(files[0]);
		}
	};
})