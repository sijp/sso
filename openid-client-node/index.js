const passport = require("passport");
const OpenIDStrategy = require("passport-openidconnect").Strategy;
const express = require("express");
const session = require("express-session");
const app = express();

passport.use(
  new OpenIDStrategy(
    {
      issuer: "http://localhost:3000",
      clientID: "q1w2e3",
      clientSecret: "abcd1234",
      authorizationURL: "http://localhost:3000/authorize",
      tokenURL: "http://localhost:3000/token",
      callbackURL: "http://localhost:5000/auth/callback",
      skipUserProfile: true,
      passReqToCallback: true
    },
    function (
      req,
      issuer,
      userId,
      profile,
      accessToken,
      refreshToken,
      params,
      cb
    ) {
      console.log(arguments);

      req.session.userId = userId;

      return cb(null, profile);
    }
  )
);

app.use(
  session({
    secret: "secret squirrel",
    resave: false,
    saveUninitialized: true
  })
);
app.use(passport.initialize());
app.use(passport.session());

app.get("/", (req, res) => {
  if (req.session.userId) {
    return res.send(
      `Hello ${JSON.stringify(req.session.userId)} you are logged in via SSO`
    );
  }
  res.redirect("/login");
});

app.get(
  "/login",
  passport.authenticate("openidconnect", {
    successReturnToOrRedirect: "/",
    scope: "openid"
  })
);

app.get(
  "/auth/callback",
  passport.authenticate("openidconnect", {
    callback: true,
    successReturnToOrRedirect: "/info",
    failureRedirect: "/"
  })
);

app.listen(5000, () => {
  console.log("Listening on 5000");
});
