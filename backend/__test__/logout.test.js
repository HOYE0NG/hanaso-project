const request = require('supertest');
const app = require('../index');
const User = require('../models/User');

describe('GET /logout', () => {
    afterEach(async () => {
        // 테스트 후에 사용자 삭제
        await User.deleteMany({ username: 'testuser2' });
    });
    it('logs out the user and destroys session', async () => {
        const userData = {
            username: 'testuser2',
            password: 'testpassword',
        };

        // 사용자 생성
        const user = new User(userData);
        await user.save();

        // 로그인
        const agent = request.agent(app);
        await agent
            .post('/api/users/login')
            .send(userData);

        const response = await agent
            .get('/api/users/logout');

        expect(response.status).toBe(200);

        // 로그아웃 후에는 세션이 없어야 함
        const session = await agent.get('/session');
        expect(session.status).toBe(404);
    });

    it('returns 403 if not logged in error occurs', async () => {
        // 이 테스트는 not logged in 에러가 발생하는 상황을 시뮬레이션
        const agent = request.agent(app);
        const response = await agent
            .get('/api/users/logout');

        expect(response.status).toBe(403);
    });


});
