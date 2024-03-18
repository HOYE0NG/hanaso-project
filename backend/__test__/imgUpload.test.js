const request = require('supertest');
const fs = require('fs');
const path = require('path');
const app = require('../index');

describe('POST /api/img/upload', () => {
    const filePath = path.join(__dirname, 'test-image.png');

    it('uploads an image file', async () => {
        const response = await request(app)
            .post('/api/img/upload')
            .attach('img', filePath);

        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('url');

        // 업로드된 파일 삭제
        const uploadedFilePath = path.join(__dirname, '../uploads', path.basename(response.body.url));
        expect(fs.existsSync(uploadedFilePath)).toBe(true); // 파일이 업로드되었는지 확인
    });

    it('returns 400 if no image file is provided', async () => {
        const response = await request(app)
            .post('/api/img/upload');

        expect(response.status).toBe(500);
    });
});
