/*
    Copyright © 2011 MLstate

    This file is part of OPA.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

/*
POSIX characters classes.
Remember that these classes must depend of the localization of the user.
That's why I only included the first 128 characters.

TODO if we do localization : Equivalence classes. See the POSIX doc.
[=e=] ----> parser r=[eéèêë...] -> r

Class           Meaning
[:alnum:]       Alphanumeric characters.
[:alpha:]       Alphabetic characters.
[:blank:]       Space and TAB characters.
[:cntrl:]       Control characters.
[:digit:]       Numeric characters.
[:graph:]       Characters that are both printable and visible. (A space is printable but not visible, whereas an ‘a’ is both.)
[:lower:]       Lowercase alphabetic characters.
[:print:]       Printable characters (characters that are not control characters).
[:punct:]       Punctuation characters (characters that are not letters, digits, control characters, or space characters).
[:space:]       Space characters (such as space, TAB, and formfeed, to name a few).
[:upper:]       Uppercase alphabetic characters.
[:xdigit:]      Characters that are hexadecimal digits.
*/

Posix = {{
  alnum = parser r=(alpha | digit) -> r
  alpha = parser r=(lower | upper) -> r
  blank = parser r=[ 	]-> r
  cntrl = parser r=[ --] -> r
  digit = parser r=[0-9] -> r
  graph = parser r=(alnum | punct) -> r
  lower = parser r=[a-z] -> r
  print = parser r=(graph | space) -> r
  punct = parser r=[!-/:-@[-`{-~] -> r
  space = parser r=[	-] -> r
  upper = parser r=[a-Z] -> r
  xdigit = parser r=(digit | [a-fA-F]) -> r
}}
