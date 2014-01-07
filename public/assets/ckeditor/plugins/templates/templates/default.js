﻿/*
 Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
*/
CKEDITOR.addTemplates("default",
	{imagesPath:CKEDITOR.getUrl(CKEDITOR.plugins.getPath("templates")+"templates/images/"),
	templates:[
		{title:"Simple Signature",
		image:"template1.gif",
		description:"A simple signature with firm's informations.",
		html:'<table border="0" style="font-family:sans-serif;font-size:12px;width:322px;">
				<tbody style="font-family:sans-serif;font-size:12px;border-bottom:0px none #808080;border-left:0px none #808080;border-right:0px none #808080;border-top:0px none #808080;width:322px;border-spacing:2px 2px;"><tr valign="top" style="font-family:sans-serif;font-size:12px;border-bottom:0px none #808080;border-left:0px none #808080;border-right:0px none #808080;border-top:0px none #808080;width:322px;border-spacing:2px 2px;">				
					<td style="font-family:sans-serif;font-size:12px;text-align:left;vertical-align:top;padding:1px;width:316px;border-spacing:2px 2px;">
						<span style="font-family:sans-serif;font-size:13px;text-align:left;border-spacing:2px 2px;">
							<span style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #808080;color:#808080;border-bottom:0px none #808080;border-left:0px none #808080;border-right:0px none #808080;border-top:0px none #808080;outline:#808080 none 0px;border-spacing:2px 2px;">
								<strong class="text-color theme-font" style="font-family:Arial;font-size:13px;text-align:left;text-decoration:none solid #00A1E6;color:#00A1E6;border-bottom:0px none #00A1E6;border-left:0px none #00A1E6;border-right:0px none #00A1E6;border-top:0px none #00A1E6;outline:#00A1E6 none 0px;border-spacing:2px 2px;">VARIABLE_NAME</strong>
								<span style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #888888;color:#888888;border-bottom:0px none #888888;border-left:0px none #888888;border-right:0px none #888888;border-top:0px none #888888;outline:#888888 none 0px;border-spacing:2px 2px;"><em style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #888888;color:#888888;border-bottom:0px none #888888;border-left:0px none #888888;border-right:0px none #888888;border-top:0px none #888888;outline:#888888 none 0px;border-spacing:2px 2px;"> VARIABLE_JOB</em></span>
								<span style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #888888;color:#888888;border-bottom:0px none #888888;border-left:0px none #888888;border-right:0px none #888888;border-top:0px none #888888;outline:#888888 none 0px;border-spacing:2px 2px;"><em style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #888888;color:#888888;border-bottom:0px none #888888;border-left:0px none #888888;border-right:0px none #888888;border-top:0px none #888888;outline:#888888 none 0px;border-spacing:2px 2px;">, firm</em></span>
							</span>
						</span>
						<br style="font-family:sans-serif;font-size:12px;text-align:left;border-spacing:2px 2px;">
						<div style="font-family:sans-serif;font-size:12px;text-align:left;width:316px;border-spacing:2px 2px;">
							<span style="font-family:sans-serif;font-size:13px;text-align:left;border-spacing:2px 2px;">								
								<span style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #808080;color:#808080;border-bottom:0px none #808080;border-left:0px none #808080;border-right:0px none #808080;border-top:0px none #808080;outline:#808080 none 0px;border-spacing:2px 2px;">
									Tel: VARIABLE_PHONE
								</span>								
								<span style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #808080;color:#808080;border-bottom:0px none #808080;border-left:0px none #808080;border-right:0px none #808080;border-top:0px none #808080;outline:#808080 none 0px;border-spacing:2px 2px;">
									<span class="text-color" style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #00A1E6;color:#00A1E6;border-bottom:0px none #00A1E6;border-left:0px none #00A1E6;border-right:0px none #00A1E6;border-top:0px none #00A1E6;outline:#00A1E6 none 0px;border-spacing:2px 2px;"> | </span>
									Email: VARIABLE_MAIL
								</span>								
							</span>
						</div>												
						<span style="font-family:sans-serif;font-size:13px;text-align:left;border-spacing:2px 2px;">
							<span style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #666699;color:#666699;border-bottom:0px none #666699;border-left:0px none #666699;border-right:0px none #666699;border-top:0px none #666699;outline:#666699 none 0px;border-spacing:2px 2px;">website<br style="font-family:sans-serif;font-size:13px;text-align:left;text-decoration:none solid #666699;color:#666699;border-bottom:0px none #666699;border-left:0px none #666699;border-right:0px none #666699;border-top:0px none #666699;outline:#666699 none 0px;border-spacing:2px 2px;"></span>
						</span>						
					</td>
				</tr>
			</tbody></table>'},
		{title:"Image + Text",
		image:"template2.gif",
		description:"A template that defines two colums, one with an image, one with some text.",
		html:'<table cellspacing="0" cellpadding="0" border="0"><tr><td><img scr="" style="margin-right:10px" height="100" width="100"></td><td>Some text</td></tr></table>'},
		{title:"Text + Image",
		image:"template3.gif",
		description:"A template that defines two colums, one with some text, one with an image.",
		html:'<table cellspacing="0" cellpadding="0" border="0"><tr><td>Some text</td><td><img scr="" style="margin-right:10px" height="100" width="100"></td></tr></table>'}
	]}
);