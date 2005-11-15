{
(* Ocsigen
 * http_lexer.mll Copyright (C) 2005 Denis Berthod
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

open Http_parser
open Http_frame
}

let blank = [' ' '\t']
let strin=[^ ':' ' ' '\n' '\r' '\t']*
let integer = ['0'-'9']*
let proto =['h' 'H'] ['t' 'T'] ['t' 'T'] ['p' 'P'] '/' integer '.' integer

rule token =
  parse
  |blank                {print_string " ";token lexbuf}
  |"GET"                {print_string "GET";METHOD "GET"}
  |"POST"               {print_string "POST";METHOD "POST"}
  |"HEAD"               {METHOD "HEAD"}
  |"PUT"                {METHOD "PUT"}
  |"DELETE"             {METHOD "DELETE"}
  |"TRACE"              {METHOD "TRACE"}
  |"OPTIONS"            {METHOD "OPTIONS"}
  |"CONNECT"            {METHOD "CONNECT"}
  |"LINK"               {METHOD "LINK"}
  |"UNLINK"             {METHOD "UNLINK"}
  |"PATCH"              {METHOD "PATCH"}
  |"\r\n"               {print_endline "";EOL}
  |":"                  {print_string ":";COLON}
  |"\n"                 {print_endline "";EOL}
  |integer              {print_string (Lexing.lexeme lexbuf);
			 CODE (int_of_string (Lexing.lexeme lexbuf))}
  |proto                {print_string (Lexing.lexeme lexbuf);
			 PROTO (Lexing.lexeme lexbuf)}
  |strin                {print_string (Lexing.lexeme lexbuf);
			 STRING (Lexing.lexeme lexbuf)}
  |eof                  {raise (Http_error.Http_exception (Some 400,["Unexpected end of
                                file"]))}
  |_                    {raise (Http_error.Http_exception (Some 400,["lexer error"
                        ^(Lexing.lexeme lexbuf)]))}
