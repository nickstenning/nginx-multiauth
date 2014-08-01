Hi. You look like a nice person.

You should probably leave. Seriously, you don't want to read this. Turn around.

Really.

If you're still here, you're probably one of those people drawn inextricably to
technological disasters because you want to understand exactly what set of
circumstances conspired to balance that train carriage perfectly on end atop the
pink Mini Cooper. Do you work in operations, by any chance?

Anyway, this is a small experiment to discover if it is possible to host an API
which requires bearer token auth, supplied in the HTTP "Authorization" header,
behind HTTP Basic authentication provided by nginx.

Why is this a problem? Well, because the standard mechanism for doing bearer
token auth is to require the provision of a request header like

    Authorization: Bearer abcdef123

But HTTP Basic authentication says that you should send

    Authorization: Basic Zm9vOmJhcg==

where the gibberish on the right hand side is

    b64encode(username + ":" + password)

Now, this wouldn't be a problem but for two things:

1. The specs (RFC2616, RFC2617) aren't clear on whether multiple Authorization
   headers are allowed. In practice, nginx will reject a request with multiple
   Authorization headers with an HTTP 400 (Bad Request).

2. The "Authorization" header has no normative form, as far as I can tell. There
   is no specified mechanism for providing multiple claims for auth in a single
   header.

We would appear to have arrived at an impasse, except for the fact that nginx
(at least the version I'm testing with, 1.4.6) appears to *ignore* trailing data
at the end of a valid HTTP Basic auth header. That is, if

    Authorization: Basic Zm9vOmJhcg==

will allow you through nginx's auth check, then so will

    Authorization: Basic Zm9vOmJhcg== More Data!

and even

    Authorization: Basic Zm9vOmJhcg==AllKindsOfGibberish

This is, without question, a slightly worrying feature. But hey, it helps us
with our original problem. The solution is in sight! Simply ask nginx to strip
off the start of the authorization header when passing a request upstream,
leaving only that part of the Authorization header it doesn't know what to do
with:

    map $http_authorization $auth_passthru {
      default "";
      "~Basic \S+\s+(?P<authsuffix>.+)$" "$authsuffix";
    }

This declaration makes nginx define a new variable, $auth_passthru, which
contains nothing if there is no trailing data on the Authorization header, or if
there is no Authorization header at all, but which contains only the trailing
data (after any whitespace) otherwise.

So, make a request with

    Authorization: Basic Zm9vOmJhcg==, Bearer abcdef123

and the proxy will see

    Authorization: Bearer abcdef123

Beautiful!

But seriously? Don't do this.
