const passport = require('passport');
const bcrypt = require('bcrypt');
const { Strategy: LocalStrategy } = require('passport-local');
const User = require('../models/User');
const errorMessages = require('../utils/errorMessages');

module.exports = () => {
    passport.use(
        new LocalStrategy(
            {
                usernameField: 'username',
                passwordField: 'password',
            },
            async (username, password, done) => {
                try {
                    const user = await User.findOne(
                        { username: username } //name:unique
                    );
                    if (!user) {
                        return done(null, false, {
                            reason: errorMessages.userNotFound
                        });
                    }

                    const result = await bcrypt.compare(password, user.password);

                    if (result) return done(null, user);
                    else return done(null, false, {
                        reason: errorMessages.passwordError
                    }
                    );
                } catch (e) {
                    console.error(e);
                    return done(e);
                }
            }));
}