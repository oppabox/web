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

	$.image_preview_multiple = function (files, context, size) {
		// defulat size = 100px
		if (typeof(size) === 'undefined')
			size = 100;

		// init
		context.html("");

		for (var i = 0; i < files.length; i++) {
			if (files[i].type === undefined) {
				// file[i] just contains url, not a file object
				var html = "<a class='thumbnail'>";
				html += "<img src='"+ files[i] +"' class='img-responsive img-center' />" 
				html += "</a>"
				context.append(html);
			}
			else if (/^image/.test(files[i].type)) {
				// only accept image file
				var reader = new FileReader();

				var html = "<a class='thumbnail image_" + i + "' >";
				html += "</a>"
				context.append(html);

				var context_a = context.find("a.image_" + i);
				reader_callback(reader, context_a);

				reader.readAsDataURL(files[i]);
				
			}
		}
	};

	var reader_callback = function (reader, context) {
		reader.onloadend = function (e) {
			var html = "<img src='"+ this.result + "' class='img-responsive img-center' />"
			context.html(html);
		};
	};

	$.image_preview_with_locale = function (files, locales, context_prefix, size) {

		$.each(locales, function (i, v){
			$.image_preview_multiple(files[v], $("#" + context_prefix + v), size);
		});
	};

	// helper 
	// return index of array with given function
	// -1 for not found
	Array.prototype.indexOfWith = function (f) {
		for (i = 0; i < this.length; i++) {
			if (f(this[i]))
				return i;
		}
		return -1;
	};

	$.get_dashboard_statistic = function (type, options, callbacks) {
		var url;
		switch (type) {
			case "all":
				url = "/admin/dashboard/get_all_statistic";
				break;
			case "box":
				url = "/admin/dashboard/get_box_statistic"
				break;
			case "item":
				url = "/admin/dashboard/get_item_statistic"
				break;
		}
		$.ajax({
      url: url,
      type: "POST",
      dataType:"JSON",
      data: {
      	id: options["id"],
        date_from: options["from"],
        date_to: options["to"]
      },
      success: function(data) {
        callbacks(data);
      }
    });
	};
})