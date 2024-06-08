const mongoose = require('mongoose');

const WordSchema = new mongoose.Schema({
    theme: Number,
    word: String,
    meaning: String,
    soundUrl: String
});

module.exports = mongoose.model('Word', WordSchema);