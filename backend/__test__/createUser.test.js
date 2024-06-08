const request = require('supertest');
const app = require('../index');
const User = require('../models/User');

describe('POST /api/users', () => {
    afterEach(async () => {
        // 테스트 후에 사용자 삭제
        await User.deleteMany({ username: { $in: ['testuser', 'existinguser'] } });

    });
    it('creates a new user', async () => {
        const userData = {
            username: 'testuser',
            password: 'password123',
            profileImg: 'profile.jpg',
        };

        const response = await request(app)
            .post('/api/users')
            .send(userData);

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('username', 'testuser');
        expect(response.body).toHaveProperty('profileImg', 'profile.jpg');
        expect(response.body).not.toHaveProperty('password');
    });

    it('returns 400 for duplicate username', async () => {
        const existingUser = new User({
            username: 'existinguser',
            password: 'password123',
        });
        await existingUser.save();

        const userData = {
            username: 'existinguser',
            password: 'password456',
        };

        const response = await request(app)
            .post('/api/users')
            .send(userData);

        expect(response.status).toBe(400);
    });


});
