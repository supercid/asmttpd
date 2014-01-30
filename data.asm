;asmttpd - Web server for Linux written in amd64 assembly.
;Copyright (C) 2014  nemasu <nemasu@gmail.com>
;
;This file is part of asmttpd.
;
;asmttpd is free software: you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation, either version 2 of the License, or
;(at your option) any later version.
;
;asmttpd is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;
;You should have received a copy of the GNU General Public License
;along with asmttpd.  If not, see <http://www.gnu.org/licenses/>.

    sockaddr_in: ;struct
		sin_family dw AF_INET
		sin_port   dw LISTEN_PORT
		sin_addr   dd 0 ;INADDR_ANY
	directory_path dq 0    
	timeval: ;struct
        tv_sec  dq 0
        tv_usec dq 0
    sigaction: ;struct
		sa_handler  dq 0
		sa_flags    dq SA_RESTORER ; also dq, because padding
		sa_restorer dq 0
		sa_mask     dq 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	queue_futex dq 0
	queue_min dq 0
	queue_max dq 0
	queue_start dq 0
	queue_end   dq 0
	signal_futex dq 0

	;Strings
	in_enter db "In Enter:",0x00
	in_enter_len equ $ - in_enter
	in_exit  db "In Exit:", 0x00
	in_exit_len equ $ - in_exit
	new_line db 0x0a
	start_text db "asmttpd - ",ASMTTPD_VERSION,0x0a,0x00
	start_text_len equ $ - start_text
	msg_error     db "An error has occured, exiting",0x00
	msg_error_len equ $ - msg_error
	msg_help      db "Usage: ./asmttpd /path/to/directory",0x00
	msg_help_len  equ $ - msg_help
	msg_using_directory dd "Using Document Root: ",0x00
	msg_using_directory_len equ $ - msg_using_directory
	msg_not_a_directory dd "Error: Specified document root is not a directory",0x00
	msg_not_a_directory_len equ $ - msg_not_a_directory
	msg_request_log dd 0x0a,"Request: ",0x00
	msg_request_log_len equ $ - msg_request_log


	filter_test db "/home/nemasu/../something",0x00
	filter_test_len equ $ - filter_test

	filter_prev_dir db "../",0x00
	filter_prev_dir_len equ $ - filter_prev_dir

	crlf db 0x0d,0x0a,0x00
	crlf_len equ $ - crlf

	;HTTP
	http_200 db "HTTP/1.1 200 OK",0x0d,0x0a,0x00
	http_200_len equ $ - http_200
	http_404 db "HTTP/1.1 404 Not Found",0x0d,0x0a,0x00
	http_404_len equ $ - http_404
	http_404_text db "I'm sorry, Dave. I'm afraid I can't do that. 404 Not Found",0x00
	http_404_text_len equ $ - http_404_text_len
	server_header db     "Server: asmttpd/",ASMTTPD_VERSION,0x0d,0x0a,0x00
	server_header_len equ $ - server_header
	connection_header db "Connection: close",0x0d,0x0a,0x00
	connection_header_len equ $ - connection_header
	
	content_type db "Content-Type: ",0x00
	content_type_len equ $ - content_type
	
	;Content-Type
	content_type_html db "text/html",0x0d,0x0a,0x00
	content_type_html_len equ $ - content_type_html
	
	content_type_octet_stream db "application/octet-stream",0x0d,0x0a,0x00
	content_type_octet_stream_len equ $ - content_type_octet_stream
	
	content_type_xhtml db "application/xhtml+xml",0x0d,0x0a,0x00
	content_type_xhtml_len equ $ - content_type_xhtml
	
	content_type_xml db "text/xml",0x0d,0x0a,0x00
	content_type_xml_len equ $ - content_type_xml
	
	content_type_javascript db "application/javascript",0x0d,0x0a,0x00
	content_type_javascript_len equ $ - content_type_javascript
	
	content_type_css db "text/css",0x0d,0x0a,0x00
	content_type_css_len equ $ - content_type_css

	content_type_jpeg db "image/jpeg",0x0d,0x0a,0x00
	content_type_jpeg_len equ $ - content_type_jpeg

	content_type_png db "image/png",0x0d,0x0a,0x00
	content_type_png_len equ $ - content_type_png
	
	content_type_gif db "image/gif",0x0d,0x0a,0x00
	content_type_gif_len equ $ - content_type_gif

	
	;Content extension
	extension_html	   db ".html",0x00
	extension_htm  	   db ".htm" ,0x00
	extension_javascript db ".js",  0x00
	extension_css		   db ".css", 0x00
	extension_xhtml	   db ".xhtml",0x00
	extension_xml	   db ".xml",0x00
	extension_gif	   db ".gif",0x00
	extension_jpg	   db ".jpg",0x00
	extension_jpeg	   db ".jpeg",0x00
	extension_png	   db ".png",0x00