const express = require('express');
const router = express.Router();
const Word = require('../models/Word');
const Favorite = require('../models/Favorite');
const {isLoggedIn} = require("../utils/middlewares");

router.get('/:id', isLoggedIn,async (req, res) => {
    console.log(req.params.id);
    try {
        const words = await Word.find({ theme: req.params.id });
        const favorites = await Favorite.find({ userId: req.user._id });

        const wordsWithIsStar = words.map(word => {
            const isStar = favorites.some(favorite => favorite.wordId.equals(word._id));
            return { ...word._doc, isStar };
        });
        console.log(wordsWithIsStar);
        res.json(wordsWithIsStar);
    } catch (err) {
        console.log(err.message);
        res.status(500).json({ message: err.message });
    }
});

//post
router.post('/', async (req, res) => {
    console.log(req.body);
    const word = new Word({
        theme: req.body.theme,
        word: req.body.word,
        meaning: req.body.meaning,
        soundUrl: req.body.soundUrl,
    });

    try {
        const newWord = await word.save();
        res.status(201).json(newWord);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

module.exports = router;