const mongoose = require('mongoose');

const FavoriteSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    wordId: { type: mongoose.Schema.Types.ObjectId, ref: 'Word' }
});

module.exports = mongoose.model('Favorite', FavoriteSchema);