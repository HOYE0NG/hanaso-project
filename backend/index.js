require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const userRoutes = require('./routes/userRoutes');
const imgRoutes = require('./routes/imgRoutes');
const wordRoutes = require('./routes/wordRoutes');
const favoriteRoutes = require('./routes/favoriteRoutes');
const chatRoutes = require('./routes/chatRoutes');
const themeRoutes = require('./routes/themeRoutes');
const app = express();
const port = process.env.PORT || 4000;
const mongoURI = process.env.MONGO_URI || 'mongodb://0.0.0.0:27017/mydb';

mongoose.set('strictQuery', false);
mongoose.connect(mongoURI, {})
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.log(err));

const cors = require('cors');
app.use(cors())
app.use(express.json());

const session = require("express-session");
const cookieParser = require('cookie-parser');

app.use(session({
    secret: process.env.SECRET,
    resave: false,
    saveUninitialized: true,
    cookie: {
        secure: false, // HTTPS를 사용할 경우 true로 설정
        maxAge: 1000 * 60 * 60 * 24, // 세션 유지 기간 1일
    },
}));


const passport = require('passport');
app.use(cookieParser());
const passportConfig = require('./passport');
passportConfig();
app.use(passport.initialize());
app.use(passport.session());

app.use('/api/users', userRoutes);
app.use('/api/img', imgRoutes);
app.use('/api/words', wordRoutes);
app.use('/api/favorites',favoriteRoutes);
app.use('/api/chat',chatRoutes);
app.use('/api/themes',themeRoutes);
if (process.env.NODE_ENV !== 'test'){
    app.listen(port, () => console.log(`Server listening on port ${port}`));
}

module.exports = app