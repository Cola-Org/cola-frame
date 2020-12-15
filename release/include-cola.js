function includeAll(root) {
	function writeScriptlet(file) {
		document.write("<script language=\"JavaScript\" type=\"text/javascript\" charset=\"utf-8\" src=\"" + root + file + "\"></script>");
	}

	function writeStyleSheet(file) {
		document.write("<link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" href=\"" + root + file + "\" />");
	}

	writeStyleSheet("semantic.min.css");
	writeStyleSheet("cola.min.css");
	document.write("<script language=\"JavaScript\" type=\"text/javascript\" charset=\"utf-8\"  src =\"//cdn.bootcdn.net/ajax/libs/jquery/2.2.4/jquery.js\" ></script>");

	writeScriptlet("3rd.min.js");
	writeScriptlet("semantic.min.js");
	writeScriptlet("cola.min.js");
}

includeAll(location.protocol + "//cola-org.github.io/cola-frame/release/1.0.8/");
document.write("<style>"
	+ "body{ padding: 1em; background: transparent;}" + "</style>");
