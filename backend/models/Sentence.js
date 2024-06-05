const mongoose = require('mongoose');

const sentenceSchema = new mongoose.Schema({
    theme: Number,
    sentence: String,
    blankWord: String,
    correctSentence: String,
    choices: [String],
    koreanMeaning: String
});

const Sentence = mongoose.model('Sentence', sentenceSchema);
module.exports = Sentence;
