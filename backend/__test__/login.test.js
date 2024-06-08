
const request = require('supertest');
const app = require('../index');
const User = require('../models/User');

describe('POST /login', () => {
    afterEach(async () => {
        // 테스트 후에 사용자 삭제
        await User.deleteMany({ username: 'testuser1' });
    });
    it('responds with user data after successful login', async () => {
        const userData = {
            username: 'testuser1',
            password: 'testpassword',
        };

        // 사용자 생성
        const user = new User(userData);
        await user.save();

        const response = await request(app)
            .post('/api/users/login')
            .send(userData);

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('username', 'testuser1');
    });

    it('responds with 401 for invalid login', async () => {
        const userData = {
            username: 'invaliduser',
            password: 'invalidpassword',
        };

        const response = await request(app)
            .post('/api/users/login')
            .send(userData);

        expect(response.status).toBe(401);
    });


});
