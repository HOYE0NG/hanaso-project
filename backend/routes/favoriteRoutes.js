
const express = require('express');
const router = express.Router();
const Favorite = require('../models/Favorite');
const { isLoggedIn } = require('../utils/middlewares');

// Add a word to favorites
router.post('/',isLoggedIn, async (req, res) => {
    const favorite = new Favorite({
        userId: req.user._id,
        wordId: req.body.wordId
    });
    console.log('add favorite');
    try {
        const newFavorite = await favorite.save();
        res.status(201).json(newFavorite);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// Middleware function for getting favorite by wordId and userId
async function getFavorite(req, res, next) {
    let favorite;
    try {
        favorite = await Favorite.findOne({ wordId: req.params.id, userId: req.user._id });
        console.log('get favorite');
        if (favorite == null) {
            console.log('Cannot find favorite');
            return res.status(404).json({ message: 'Cannot find favorite' });
        }
    } catch (err) {
        console.log(err.message);
        return res.status(500).json({ message: err.message });
    }

    res.favorite = favorite;
    next();
}

// Remove a word from favorites
router.delete('/:id', getFavorite, async (req, res) => {
    try {
        console.log(res.favorite);
        const result = await Favorite.findByIdAndDelete(res.favorite._id);
        console.log('delete favorite');
        res.status(200).json({ message: 'Favorite deleted' });
    } catch (err) {
        console.log(err.message);
        res.status(500).json({ message: err.message });
    }
});




module.exports = router;