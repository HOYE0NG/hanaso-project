const express = require('express');
const router = express.Router();

const Sentence = require('../models/Sentence');

// Insert a sentence
router.post('/', async (req, res) => {
    const { theme, sentence, blankWord, koreanMeaning } = req.body;

    const newSentence = new Sentence({
        theme,
        sentence,
        blankWord,
        koreanMeaning
    });

    try {
        const savedSentence = await newSentence.save();

        res.json(savedSentence);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get a sentence
router.get('/:theme', async (req, res) => {
    try {
        console.log('theme');
        console.log(req.params.theme);
        const sentences = await Sentence.find({ theme: req.params.theme });
        console.log(sentences);
        res.json(sentences);
    } catch (err) {
        console.log(err.message);
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;