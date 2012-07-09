/*
    Copyright © 2011, 2012 MLstate

    This file is part of Opa.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

////////////////////////////////////////////////////////////////////////////
// BEWARE THIS FILE IS SHARED BEETWEEN THE CLIENT JAVASCRIPT AND NODE BSL //
////////////////////////////////////////////////////////////////////////////

/**
 * Implementation note: we need to check [console] at each call, as debuggers can be (de)activated dynamically 
 */

##register fatal: string, string -> void
##args(topic, value)
{
   if (console)
       console.error("[Opa]", "Fatal error", topic, value);
}

##register error: string, string -> void
##args(topic, value)
{
   if (console)
       console.error("[Opa]", topic, value);
}

##register warning: string, string -> void
##args(topic, value)
{
   if (console)
       console.warn("[Opa]", topic, value);
}

##register notice: string, string -> void
##args(topic, value)
{
   if (console)
       console.log("[Opa]", topic, value);
}

##register info: string, string -> void
##args(topic, value)
{
   if (console)
       console.info("[Opa]", topic, value);
}

##register debug: string, 'a -> void
##args(topic, value)
{
   if (console)
       console.log("[Opa]", topic, value); // we do not use debug, because it is deprecated since Gecko 5.0
}