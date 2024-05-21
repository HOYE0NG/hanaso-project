const express = require('express');
const router = express.Router();

const User = require('../models/User');
const passport = require('passport');
const { isLoggedIn, isNotLoggedIn } = require('../utils/middlewares');
const errorMessages = require('../utils/errorMessages');


//Login
router.post('/login', isNotLoggedIn, async(req, res, next) => {
    console.log(req.body);
    passport.authenticate('local',  (err, user, info) => {

        if (err) {
            console.error(err);
            return next(err);
        }

        if (info) {
            console.error(info);
            return res.status(401).send(info.reason);
        }

        // 사용자 인증에 성공한 경우, req.login 통해 세션에 사용자 정보 저장
        return req.login(user, async(loginErr) => {
            if (loginErr) {
                console.error(loginErr);
                return next(loginErr);
            }
            //console.log('Session: ', req.session);
            try {
                const { password, ...userData } = user.toObject();
                console.log(userData);
                return res.json(userData);
            } catch (error) {
                console.error(error);
                return res.status(500).json({ message: errorMessages.serverError });
            }
        });
    })(req, res, next);
});


//Logout
router.get('/logout', isLoggedIn,  async(req, res) => {

    req.logout(function(err) {
        if (err) {
            console.error(err);
            return res.status(500).json({ message: errorMessages.logoutError });
        }
        req.session.destroy(function(err) {
            if (err) {
                console.error(err);
                return res.status(500).json({ message: errorMessages.sessionError });
            }
            res.end();
        });
    });
});

// Create user
router.post('/', isNotLoggedIn, async (req, res) => {
    console.log("user ")
    const user = new User(req.body);

    try {
        console.log("user",user);
        await user.save();
        const { password, ...userData } = user.toObject();
        return res.json(userData);
    } catch (err) {
        if (err.code === 11000 && err.keyPattern && err.keyPattern.username === 1) {
            console.log(err);
            res.status(409).json({ message: errorMessages.duplicateUsername });
        } else {
            console.log(err);
            res.status(400).json({ message: err.message });
        }
    }
});

// Update user
router.put('/', isLoggedIn,async (req, res) => {
    try {
        const userId = req.user._id;
        const user = await User.findByIdAndUpdate(userId, req.body, { new: true });
        if (!user) {
            return res.status(404).json({ message: errorMessages.userNotFound});
        }
       
        const { password, ...userData } = updatedUser.toObject();
        return res.json(userData);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

//출석체크
router.post('/attendance', isLoggedIn, async (req, res) => {
    try {
        console.log('attendance');
        // Get the user from the request
        const user = await User.findById(req.user.id);

        // Get the date from the request body
        const { date } = req.body;

        // Save the attendance data
        user.attendance.push(date);
        await user.save();

        res.json({ message: 'Attendance data saved successfully.' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});
module.exports = router;