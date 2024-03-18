const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const UserSchema = new mongoose.Schema({
  username: { type: String, required: true, unique:true },
  password: { type: String, required: true, maxlength: 100 },
  profileImg: { type: String }, // 프로필 이미지 경로
}, {
  versionKey: false});


UserSchema.pre('save', async function (next) {
  try {
    const user = this;
    if(user.isModified('password')) {
      const salt = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, salt);
      next();
    }
  } catch (error) {
    next(error);
  }
});


const User = mongoose.model('User', UserSchema);

module.exports = User;